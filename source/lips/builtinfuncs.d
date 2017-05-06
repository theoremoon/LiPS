import ASTItems, eval, util;

import std.stdio, std.conv;

ASTNode builtin_print(ASTNode[] args, ref Env env) {
    ASTNode v = eval.eval(args[0], env);
    writeln(v);

    return v;
}
ASTNode builtin_def(ASTNode[] args, ref Env env) {
    if (auto name = cast(ASTIdentifier)args[0]) {
        auto value = eval.eval(args[1], env);
        env[name.name] = value;
        return value;
    }
    throw new Exception("ERROR");
}
ASTNode builtin_func(ASTNode[]args, ref Env env) {
    if (auto name = cast(ASTIdentifier)args[0]) {
        string[] params;
        foreach (arg; args[1].op ~ args[1].args) {
            if (auto param = cast(ASTIdentifier)arg) {
                params ~= param.name;
            }
            else {
                throw new Exception("function parameter " ~ arg.toString ~ " is not a symbol");
            }
        }

        return new ASTFunc(name.name, params, args[2]);
    }
    throw new Exception("error");
}
ASTNode builtin_do(ASTNode[] args, ref Env env) {
    Env newenv = env.dup;
    ASTNode result;
    foreach (exp; args) {
        result = eval.eval(exp, newenv);
    }
    return result;
}

ASTNode builtin_if(ASTNode[] args, ref Env env) {
    if (args.length != 3) {
        throw new Exception("the if function have excatly 3 arguments but " ~ args.length.to!string ~ " given");
    }

    ASTNode cond = args[0];
    ASTNode when_true = args[1];
    ASTNode when_false = args[2];

    ASTNode result = eval.eval(cond, env);
    if (is_false(result)) {
        return eval.eval(when_false, env);
    }
    return eval.eval(when_true, env);
}

ASTNode builtin_add(ASTNode[] args, ref Env env) {
    int retval = 0;
    foreach (arg; args) {
        if (auto intval = cast(ASTInteger)arg) {
            retval += intval.value;
        }
        else {
            throw new Exception("expected int but given is " ~ arg.toString);
        }
    }
    return new ASTInteger(retval);
}

ASTNode builtin_subtract(ASTNode[] args, ref Env env) {
    int retval = 0;
    foreach (arg; args) {
        if (auto intval = cast(ASTInteger)arg) {
            retval -= intval.value;
        }
        else {
            throw new Exception("expected int but given is " ~ arg.toString);
        }
    }
    return new ASTInteger(retval);
}

ASTNode builtin_multiply(ASTNode[] args, ref Env env) {
    int retval = 1;
    foreach (arg; args) {
        if (auto intval = cast(ASTInteger)arg) {
            retval *= intval.value;
        }
        else {
            throw new Exception("expected int but given is " ~ arg.toString);
        }
    }
    return new ASTInteger(retval);
}