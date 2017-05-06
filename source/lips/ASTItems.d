
import std.conv;

enum NodeType
{
    identifier,
    integer,
    string,
    list,
    func

}

class ASTNode
{    
    public {
        NodeType type;
        ASTNode op;
        ASTNode[] args;
    }

    this()
    {
        this.type = NodeType.list;
        this.op = null;
        this.args = [];
    }
    this(ASTNode op, ASTNode[] args) {
        this.type  = NodeType.list;
        this.op = op;
        this.args = args;
    }

    override string toString() {
        string s = "(" ~ op.toString;

        foreach (arg; args) {
            s = s ~ " " ~ arg.toString;
        }
        s ~= ")";

        return s;
    }
}

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

class ASTFunc : ASTNode
{
    public {
        string name;
        string[] params;
        ASTNode proc;
    }
    this(string name, string[] params, ASTNode proc) {
        super();
        this.type = NodeType.func;
        this.name = name;
        this.params = params;
        this.proc = proc;
    }
}
alias Env = ASTNode[string];
alias BuiltinFunc = ASTNode function(ASTNode[] args, ref Env env);
class ASTBuiltin : ASTFunc
{
    public {
         BuiltinFunc func;
    }
    this(string name, BuiltinFunc func) {
        super(name, [], null);
        this.func = func;
    }
    ASTNode eval(Env env, ASTNode[] args) {
        return func(args, env);
    }
}