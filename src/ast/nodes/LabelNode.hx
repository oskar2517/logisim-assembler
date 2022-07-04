package ast.nodes;

import visitor.Visitor;

class LabelNode extends Node {
    
    public final nodes:Array<Node> = [];
    public final name:String;

    public function new(name:String) {
        super(Label);

        this.name = name;
    }

    public function accept(visitor:Visitor) {
        visitor.visitLabelNode(this);
    }
}