package codegen;

import haxe.io.Bytes;
import haxe.Json;
import util.Util.error;
import haxe.ds.StringMap;
import visitor.Visitor;
import ast.nodes.*;
import codegen.Config.AssemblerConfig;

class CodeGeneratorVisitor implements Visitor {

    final microcode:String;
    final labels:StringMap<Int> = new StringMap();
    final opCodes:StringMap<Int> = new StringMap();
    var config:AssemblerConfig;
    final bufferOutput = new StringBuf(); 

    public function new(microcode:String) {
        this.microcode = microcode;

        parseConfig();
        populateOpCodes();
    }

    public function getOutput():String {
        return bufferOutput.toString();
    }

    function populateOpCodes() {
        for (op in config.opCodes) {
            opCodes.set(op.mnemonic, op.address);
        }
    }

    function parseConfig() {
        try {
            final lines = ~/(\r\n|\r|\n)/g.split(microcode);
            final configJson = lines[2].substr(2);

            config = Json.parse(configJson).config;
        } catch (e) {
            error('Could not parse assembler config');
        }
    }

    function collectLabels(nodes:Array<Node>) {
        var byteIndex = 0;
        for (n in nodes) {
            if (n is LabelNode) {
                final label = cast(n, LabelNode);
                labels.set(label.name, byteIndex);
            } else {
                byteIndex += 1;
            }
        }
    }

    function binaryExtend(value:Int):Int {
        final r = value % 8;
        final e = (r != 0) ? 8 - r : 0;

        return Std.int((value + e) / 8);
    }

    function writeInteger(n:Int, out:Bytes) {
        for (i in 0...config.instructionWidth) {
            final byteIndex = binaryExtend(config.instructionWidth) - 1 - Std.int(i / 8);

            var currentData = out.get(byteIndex);
            currentData |= ((n >>> i) & 1) << (i % 8);

            out.set(byteIndex, currentData);
        }
    }

    public function visitFileNode(node:FileNode) {
        collectLabels(node.nodes);

        bufferOutput.add("v3.0 hex words plain\r\n");
        
        for (n in node.nodes) {
            n.accept(this);
        }
    }

    public function visitIdentNode(node:IdentNode) {}

    public function visitInstructionNode(node:InstructionNode) {
        if (!opCodes.exists(node.mnemonic)) {
            error('Unknown operation ${node.mnemonic}');
        }

        final operation = opCodes.get(node.mnemonic);

        final instruction = Bytes.alloc(binaryExtend(config.instructionWidth));
        final immediate = if (node.immediate is IntegerNode) {
            final integerNode = cast(node.immediate, IntegerNode);

            integerNode.value;
        } else if (node.immediate is IdentNode) {
            final identNode = cast(node.immediate, IdentNode);

            if (labels.exists(identNode.value)) {
                labels.get(identNode.value);
            } else {
                error('Use of undefined label ${identNode.value}');
                0;
            }
        } else {
            0;
        }

        // Write immediate
        writeInteger(immediate, instruction);

        // Write opcode
        for (i in 0...config.opCodeWidth) {
            final byteIndex = Std.int(i / 8);

            var currentData = instruction.get(byteIndex);
            currentData |= ((operation >>> (config.opCodeWidth - i - 1)) & 1) << (7 - (i % 8));
            
            instruction.set(byteIndex, currentData);
        }

        bufferOutput.add(instruction.toHex());
        bufferOutput.add("\r\n");
    }

    public function visitIntegerNode(node:IntegerNode) {
        final instruction = Bytes.alloc(binaryExtend(config.instructionWidth));
        writeInteger(node.value, instruction);

        bufferOutput.add(instruction.toHex());
        bufferOutput.add("\r\n");
    }

    public function visitLabelNode(node:LabelNode) {}
}