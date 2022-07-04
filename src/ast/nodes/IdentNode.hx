package ast.nodes;

import visitor.Visitor;

class IdentNode extends Node {
    
    public final nodes:Array<Node> = [];
    public final value:String;

    public function new(value:String) {
        super(Ident);

        this.value = value;
    }

    public function accept(visitor:Visitor) {
        visitor.visitIdentNode(this);
    }
}