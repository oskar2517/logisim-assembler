package ast.nodes;

import visitor.Visitor;

class InstructionNode extends Node {

    public final nodes:Array<Node> = [];
    public final mnemonic:String;
    public final immediate:Node;

    public function new(mnemonic:String, immediate:Node) {
        super(Integer);

        this.mnemonic = mnemonic;
        this.immediate = immediate;
    }

    public function accept(visitor:Visitor) {
        visitor.visitInstructionNode(this);
    }
}