import ASTItems;

import std.stdio;

ASTNode call(ASTFunc func, ref Env env, ASTNode[] args)
{
    if (auto builtin = cast(ASTBuiltin)func)
    {
        return builtin.eval(env, args);
    }
    return eval(func.proc, env);
}

ASTNode eval(ASTNode node, ref Env env)
{
    if (node.type == NodeType.list)
    {
        if (node.op is null)
        {
            return node; // false
        }
        if (auto op = cast(ASTIdentifier)node.op) {
            if (! (op.name in env)) {
                throw new Exception("unknown function:" ~ op.name);
            }
            if (auto func = cast(ASTFunc)env[op.name]) {
                return call(func, env, node.args);
            }
        }
        else if (node.args.length == 0) {
            return eval(node.op, env);
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