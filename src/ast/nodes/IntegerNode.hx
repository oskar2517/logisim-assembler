package ast.nodes;

import visitor.Visitor;

class IntegerNode extends Node {
    
    public final nodes:Array<Node> = [];
    public final value:Int;

    public function new(value:Int) {
        super(Integer);

        this.value = value;
    }

    public function accept(visitor:Visitor) {
        visitor.visitIntegerNode(this);
    }
}