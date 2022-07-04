package visitor;

import ast.nodes.*;

interface Visitor {
    
    function visitFileNode(node:FileNode):Void;

    function visitIdentNode(node:IdentNode):Void;

    function visitInstructionNode(node:InstructionNode):Void;

    function visitIntegerNode(node:IntegerNode):Void;

    function visitLabelNode(node:LabelNode):Void;
}