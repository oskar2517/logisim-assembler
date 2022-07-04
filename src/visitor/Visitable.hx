package visitor;

interface Visitable {
    
    function accept(visitor:Visitor):Void;
}