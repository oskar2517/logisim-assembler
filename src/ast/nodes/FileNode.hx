package ast.nodes;

import visitor.Visitor;

class FileNode extends Node {
    
    public final nodes:Array<Node> = [];

    public function new() {
        super(File);
    }

    public function addNode(node:Node) {
        nodes.push(node);
    }

    public function accept(visitor:Visitor) {
        visitor.visitFileNode(this);
    }
}