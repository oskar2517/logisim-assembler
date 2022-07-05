package parser;

import util.Util.error;
import ast.nodes.InstructionNode;
import ast.nodes.Node;
import ast.nodes.IdentNode;
import ast.nodes.LabelNode;
import ast.nodes.IntegerNode;
import ast.nodes.FileNode;
import lexer.TokenType;
import lexer.Token;
import lexer.Lexer;

class Parser {

    final lexer:Lexer;
    public final ast = new FileNode();
    var currentToken:Token;

    public function new(lexer:Lexer) {
        this.lexer = lexer;

        currentToken = lexer.readToken();
    }

    function expectLinebreak() {
        if (currentToken.type != Linebreak && currentToken.type != Eof) {
            error('Unexpected token type ${currentToken.type}, expected Linebreak or Eof.');
        }
    }

    function expectToken(type:TokenType) {
        if (currentToken.type != type) {
            error('Unexpected token type ${currentToken.type}, expected $type.');
        }
    }

    function nextToken() {
        currentToken = lexer.readToken();
    }

    public function parse() {
        while (currentToken.type != Eof) {
            parseGlobal();
        }
    }

    function parseInteger() {
        expectToken(Integer);
        final value = Std.parseInt(currentToken.literal);
        if (value == null) {
            error('Could not parse integer from ${currentToken.literal}');
        }
        nextToken();
        expectLinebreak();
        nextToken();

        return new IntegerNode(value);
    }

    function parseLabel() {
        expectToken(Ident);
        final name = currentToken.literal;
        nextToken();
        expectToken(Colon);
        nextToken();

        if (currentToken.type == Linebreak) {
            nextToken();
        }

        return new LabelNode(name);
    }

    function parseInstruction() {
        expectToken(Ident);
        final mnemonic = currentToken.literal;
        nextToken();
        final immediate:Node = if (currentToken.type == Ident) {
            final node = new IdentNode(currentToken.literal);
            nextToken();

            node;
        } else if (currentToken.type == Integer) {
            final n = Std.parseInt(currentToken.literal);
            if (n == null) {
                error('Could not parse integer from ${currentToken.literal}');
            }
            nextToken();

            new IntegerNode(n);
        } else {
            null;
        }
        expectLinebreak();
        nextToken();

        return new InstructionNode(mnemonic, immediate);
    }

    function parseGlobal() {
        switch (currentToken.type) {
            case Integer: ast.addNode(parseInteger());
            case Ident: if (lexer.peekToken().type == Colon) {
                ast.addNode(parseLabel());
            } else {
                ast.addNode(parseInstruction());
            }
            case Illegal: error('Illegal token ${currentToken.literal}.');
            default: error('Unexpected token type ${currentToken.type} (${currentToken.literal}).');
        }
    }
}