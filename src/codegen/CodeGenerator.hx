package codegen;

import ast.nodes.FileNode;

class CodeGenerator {

    public static function generate(ast:FileNode, microcode:String):String {
        final codeGen = new CodeGeneratorVisitor(microcode);
        ast.accept(codeGen);

        return codeGen.getOutput();
    }
}