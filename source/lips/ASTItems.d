// 構文木のパーツになるクラス
import std.conv;


/// はいはいenum enum
enum NodeType
{
    identifier,
    integer,
    string,
    list,
    func

}

/// 基本クラス。リストにもなるらしい
class ASTNode
{    
    public {
        NodeType type;
        ASTNode[] elements;
    }

    this() {
        this([]);
    }
    this(ASTNode[] elements) {
        this.type  = NodeType.list;
        this.elements = elements;
    }

    // toString では普通に木を吐く
    override string toString() {
        string s = "(";

        foreach (e; elements) {
            s = s ~ " " ~ e.toString;
        }
        s ~= ")";

        return s;
    }
}

/// 識別子。Symbolともいう
class ASTIdentifier : ASTNode
{
    public {
        string name;
    }

    this(string name) {
        super();
        this.type = NodeType.identifier;
        this.name = name;
    }

    override string toString()
    {
        return "ident:" ~ name ;
    }
}

/// Integer
class ASTInteger : ASTNode
{
    public {
        int value;
    }
    this(int value) {
        super();
        this.type = NodeType.integer;
        this.value = value;
    }

    override string toString()
    {
        return value.to!string;
    }
}

/// String
class ASTString : ASTNode
{
    public {
        string value;
    }
    this(string value) {
        super();
        this.type = NodeType.string;
        this.value = value;
    }
    override string toString()
    {
        return value;
    }
}


/// 関数関数
class ASTFunc : ASTNode
{
    public {
        string[] params; /// 仮引数
        ASTNode proc; /// 本体（bodyが予約後だったぽい？
    }
    this(string[] params, ASTNode proc) {
        super();
        this.type = NodeType.func;
        this.params = params;
        this.proc = proc;
    }
}

/// 環境
alias Env = ASTNode[string];

/// 組み込み関数の型
alias BuiltinFunc = ASTNode function(ASTNode[] elements, ref Env env);

/// 組み込み関数
class ASTBuiltin : ASTFunc
{
    public {
         BuiltinFunc func;
    }
    this(BuiltinFunc func) {
        super([], null);
        this.func = func;
    }
    ASTNode eval(ref Env env, ASTNode[] elements) {
        return func(elements, env);
    }
}