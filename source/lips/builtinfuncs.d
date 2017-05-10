/// 組み込み関数

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
ASTNode builtin_macro(ASTNode[] args, ref Env env) {
    string[] params;
    foreach (arg; args[0].elements) {
        if (auto param = cast(ASTIdentifier)arg) {
            params ~= param.name;
        }
        else {
            throw new Exception("macro parameter " ~ arg.toString ~ " is not a symbol");
        }
    }
    ASTMacro astmacro = new ASTMacro(params, args[1]);
    return astmacro;
}
ASTNode builtin_func(ASTNode[]args, ref Env env) {
    string[] params;
    foreach (arg; args[0].elements) {
        if (auto param = cast(ASTIdentifier)arg) {
            params ~= param.name;
        }
        else {
            throw new Exception("function parameter " ~ arg.toString ~ " is not a symbol");
        }
    }

    ASTFunc f = new ASTFunc(params, args[1]);
    return f;
}
ASTNode builtin_do(ASTNode[] args, ref Env env) {
    Env newenv = env.dup;
    ASTNode result;
    foreach (exp; args) {
        result = eval.eval(exp, newenv);
    }
    return result;
}
ASTNode builtin_quote(ASTNode[] args, ref Env env) {
    return args[0];
}
ASTNode builtin_qquote(ASTNode[] args, ref Env env) {
    return eval.qquote(args[0], env);
}
ASTNode builtin_list(ASTNode[] args, ref Env env) {
    ASTNode[] elements;
    foreach (arg; args) {
        elements ~= eval.eval(arg, env);
    }
    return new ASTNode(elements);
}
ASTNode builtin_nth(ASTNode[] args, ref Env env) {
    if (auto nth = cast(ASTInteger)eval.eval(args[0], env)) {
        auto list = eval.eval(args[1], env);
        return eval.eval(list.elements[nth.value], env);
    }
    throw new Exception("first argument must be int value");
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
        if (auto intval = cast(ASTInteger)eval.eval(arg, env)) {
            retval += intval.value;
        }
        else {
            throw new Exception("expected int but given is " ~ arg.toString);
        }
    }
    return new ASTInteger(retval);
}

ASTNode builtin_sub(ASTNode[] args, ref Env env) {
    if (auto initval = cast(ASTInteger)eval.eval(args[0], env)) {
        int retval = initval.value;        
        foreach (arg; args[1..$]) {
            if (auto intval = cast(ASTInteger)eval.eval(arg, env)) {
                retval -= intval.value;
            }
            else {
                throw new Exception("expected int but given is " ~ arg.toString);
            }
        }
        return new ASTInteger(retval);
    }
    throw new Exception("invalid arugments " ~ args[0].toString);
}

ASTNode builtin_multiply(ASTNode[] args, ref Env env) {
    int retval = 1;
    foreach (arg; args) {
        if (auto intval = cast(ASTInteger)eval.eval(arg, env)) {
            retval *= intval.value;
        }
        else {
            throw new Exception("expected int but given is " ~ arg.toString);
        }
    }
    return new ASTInteger(retval);
}
ASTNode builtin_eq(ASTNode[] args, ref Env env) {
    ASTNode v1 = eval.eval(args[0], env);
    ASTNode v2 = eval.eval(args[1], env);
    if (auto v3 = cast(ASTInteger)v1) {
        if (auto v4 = cast(ASTInteger)v2) {
            if (v3.value == v4.value) {
                return new ASTInteger(1);
            }
            return new ASTNode([]);
        }
    }
    throw new Exception("ERR " ~ v1.toString ~ " " ~ v2.toString);
}