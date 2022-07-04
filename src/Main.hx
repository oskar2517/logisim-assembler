import hxargs.Args;
import codegen.CodeGenerator;
import parser.Parser;
import lexer.Lexer;
import sys.io.File;

function main() {
    final config = {
        inputPath: null,
        outputPath: null,
        showHelp: false,
        microcodePath: null
    };

    final argumentHandler = Args.generate([
        @doc("Print this message")
        ["--help", "-h"] => function() {
            config.showHelp = true;
        },
        @doc("Specify an input file")
        ["--input", "-i"] => function(path) {
            config.inputPath = path;
        },
        @doc("Specify an output file")
        ["--output", "-o"] => function(path) {
            config.outputPath = path;
        },
        @doc("Specify a microcode hex file")
        ["--microcode", "-mc"] => function(path) {
            config.microcodePath = path;
        }
    ]);

    #if interp
    config.inputPath = "code.txt";
    config.outputPath = "compiled_code.txt";
    config.microcodePath = "microcode.hex";
    #else
    argumentHandler.parse(Sys.args());
    #end

    if (config.inputPath == null || config.outputPath == null || config.microcodePath == null) {
        config.showHelp = true;
    } else {
        final assembly = File.getContent(config.inputPath);
        final microcode = File.getContent(config.microcodePath);
    
        final lexer = new Lexer(assembly); 
        final parser = new Parser(lexer);
        parser.parse();
    
        final hex = CodeGenerator.generate(parser.ast, microcode);
        File.saveContent(config.outputPath, hex);
    }

    if (config.showHelp) {
        Sys.println("Usage: asm [-options]");
        Sys.println("");
        Sys.println("Options:");
        Sys.println(argumentHandler.getDoc());
        Sys.exit(0);
    }
}