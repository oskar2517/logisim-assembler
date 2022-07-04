package lexer;

import lexer.LexerHelper.isLinebreak;
import lexer.LexerHelper.isNumber;
import lexer.LexerHelper.isAscii;

class Lexer {
    
    private final code:String;
    var currentChar = " ";
    var position = 0;

    public function new(code:String) {
        this.code = code;
    }

    function readChar() {
        currentChar = if (position >= code.length) {
            "\u{0}";
        } else {
            code.charAt(position);
        }

        position++;

        eatComment();
    }

    function peekChar():String {
        return (position >= code.length) ? "\u{0}" : code.charAt(position);
    }

    function readIdent():String {
        final startPosition = position;

        while (isAscii(peekChar()) || peekChar() == "_") {
            readChar();
        }

        return code.substring(startPosition - 1, position);
    }

    function readInteger():String {
        final startPosition = position;

        while (isNumber(peekChar())) {
            readChar();
        }

        return code.substring(startPosition - 1, position);
    }

    function eatWhitespace() {
        while (currentChar == " " || currentChar == "\t") {
            readChar();
        }
    }

    function eatComment() {
        if (currentChar == "/" && peekChar() == "/") {
            while (!isLinebreak(currentChar) && currentChar != "\u{0}") {
                readChar();
            }
        }
    }

    function eatLinebreak() {
        while (isLinebreak(peekChar()) || peekChar() == " " || peekChar() == "\t") {
            readChar();
        }
    }

    public function tokenize() {
        while (currentChar != "\u{0}") {
            final token = readToken();
            trace(token.toString());
        }
    }

    public function peekToken():Token {
        final lastPosition = position;
        final lastChar = currentChar;
        final token = readToken();
        position = lastPosition;
        currentChar = lastChar;

        return token;
    }

    public function readToken():Token {
        readChar();
        eatWhitespace();

        return switch (currentChar) {
            case ":": new Token(Colon, currentChar);
            case ";": new Token(Semicolon, currentChar);
            case "\u{0}": new Token(Eof, currentChar);
            default:
                if (isLinebreak(currentChar)) {
                    eatLinebreak();
                    return new Token(Linebreak, "\\n");
                }

                if (isNumber(currentChar)) {
                    final number = readInteger();
                    return new Token(Integer, number);
                }

                if (isAscii(currentChar)) {
                    final ident = readIdent();

                    return new Token(Ident, ident);
                }

                return new Token(Illegal, currentChar);
        }
    }
}