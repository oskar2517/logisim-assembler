package codegen;

typedef OpCode = {
    mnemonic:String,
    address:Int
}

typedef AssemblerConfig = {
    opCodes:Array<OpCode>,
    instructionWidth:Int,
    opCodeWidth:Int
}