import ASTItems, eval;

import std.stdio;

ASTNode builtin_print(ASTNode[] args, Env env) {
    writeln(args);
    ASTNode v = eval.eval(args[0], env);
    writeln(v);

    return v;
}