import ASTItems, eval;

import std.stdio;

ASTNode builtin_print(ASTNode[] args, Env env) {
    ASTNode v = eval.eval(args[0], env);
    writeln(v);

    return v;
}

ASTNode builtin_add(ASTNode[] args, Env env) {
    auto v1 = eval.eval(args[0], env);
    auto v2 = eval.eval(args[1], env);
    if (auto v3 = cast(ASTInteger)v1) {
        if (auto v4 = cast(ASTInteger)v2) {
            return new ASTInteger(v3.value + v4.value);
        }
    }
    throw new Exception("invalid arguments");
}