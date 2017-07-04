import ASTItems;

import std.stdio, std.conv;

/// 準クオート
ASTNode qquote(ASTNode node, ref Env env) {
    // リスト以外ならそのまま返していいでしょ
    if (node.type != NodeType.list) {
        return node;
    }

    if (auto unquote = cast(ASTIdentifier)node.elements[0]) {
        // unquote
        if (unquote.name == "unquote") { // 定数使ってるし負けた気がする
            return eval(node.elements[1], env);
        }
    }


    // unquoteじゃないなら中をsemiquoteしていく
    ASTNode[] nodes;
    foreach (element; node.elements) {
        nodes ~= qquote(element, env);
    }
    return new ASTNode(nodes);
}

/// 関数呼び出し
ASTNode call(ASTFunc func, ref Env env, ASTNode[] args)
{
    // 組み込み関数
    //  関数の中で引数を評価する
    if (auto builtin = cast(ASTBuiltin)func)
    {
        return builtin.eval(env, args);
    }

    // マクロ
    if (auto lipsmacro = cast(ASTMacro)func) {
        Env macroenv = env.dup;
        for (int i = 0; i < func.params.length; i++) {
            macroenv[func.params[i]] = args[i];
        }
        return eval(eval(lipsmacro.proc, macroenv), env);
    }

    // ユーザ定義関数
    //  環境をつくり、そこに引数を加えて、procをevalする
    Env funcenv = env.dup;
    for (int i = 0; i < func.params.length; i++) {
        funcenv[func.params[i]] = eval(args[i], env);
    }
    return eval(func.proc, funcenv);
}

/// ASTNodeを評価します
ASTNode eval(ASTNode node, ref Env env)
{
    if (node.type == NodeType.list)
    {
        // false
        if (node.elements.length == 0)
        {
            return node;
        }

        ASTNode val = eval(node.elements[0], env);
        // 関数
        if (auto func = cast(ASTFunc)val) {
            return call(func, env, node.elements[1..$]);
        }
        
        // 関数以外 (x)
        else if (node.elements.length == 1) {
            if (val.type == NodeType.list) {
                return eval(val, env);
            }
            return val;
        }

        throw new Exception("only function can have arguments " ~ node.toString);
    }
    else if (auto integer = cast(ASTInteger)node)
    {
        return integer;
    }
    else if (auto str = cast(ASTString)node)
    {
        return str;
    }
    // Symbol
    else if (auto identifier = cast(ASTIdentifier)node) {
        if (! (identifier.name in env)) {
            // throw new Exception("unkown symbol " ~ identifier.toString);
            return identifier;
        }
        return env[identifier.name];
    }
    else if (auto func = cast(ASTFunc)node) {
        return func;
    }
    else if (auto macro_ = cast(ASTMacro)node) {
        return macro_;
    }

    throw new Exception("Unknown Type Node " ~ node.toString);
}
