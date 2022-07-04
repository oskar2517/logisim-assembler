package lexer;

inline function isLinebreak(s:String):Bool {
    return ~/\r\n|\r|\n/.match(s);
}

inline function isAscii(s:String):Bool {
    return ~/^[a-zA-Z0-9_\$]+$/.match(s);
}

inline function isNumber(s:String):Bool {
    return ~/^[0-9]+$/.match(s);
}