package ast.nodes;

import visitor.Visitable;

abstract class Node implements Visitable {
    
    public final type:NodeType;

    public function new(type:NodeType) {
        this.type = type;
    }
}