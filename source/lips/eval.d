import ASTItems;

import std.stdio;

ASTNode call(ASTFunc func, ref Env env, ASTNode[] args)
{
    // 組み込み関数
    if (auto builtin = cast(ASTBuiltin)func)
    {
        return builtin.eval(env, args);
    }

    // ユーザ定義関数
    //  環境をつくり、そこに引数を加えて、中身をevalする
    Env funcenv = env.dup;
    for (int i = 0; i < func.params.length; i++) {
        funcenv[func.params[i]] = args[i];
    }
    return eval(func.proc, funcenv);
}

ASTNode eval(ASTNode node, ref Env env)
{
    if (node.type == NodeType.list)
    {
        if (node.elements.length == 0)
        {
            return node; // false
        }
        if (auto op = cast(ASTIdentifier)node.elements[0]) {
            if (! (op.name in env)) {
                throw new Exception("unknown function:" ~ op.name);
            }
            if (auto func = cast(ASTFunc)env[op.name]) {
                return call(func, env, node.elements[1..$]);
            }
        }
        else if (node.elements.length == 1) {
            return eval(node.elements[0], env);
        }

        throw new Exception("only function simbol can have arguments");
    }
    else if (auto integer = cast(ASTInteger)node)
    {
        return integer;
    }
    else if (auto str = cast(ASTString)node)
    {
        return str;
    }
    else if (auto identifier = cast(ASTIdentifier)node) {
        if (! (identifier.name in env)) {
            throw new Exception("unkown symbol " ~ identifier.toString);
        }
        return env[identifier.name];
    }

    throw new Exception("Unknown Type Node " ~ node.toString);
}