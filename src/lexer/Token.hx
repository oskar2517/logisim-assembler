package lexer;

class Token {
    
    public final type:TokenType;
    public final literal:String;

    public function new(type:TokenType, literal:String) {
        this.type = type;
        this.literal = literal;
    }

    public function toString():String {
        return '($type, $literal)';
    }
}