
import std.conv;

enum NodeType
{
    identifier,
    integer,
    string,
    node

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
        this.type = NodeType.node;
        this.op = null;
        this.args = [];
    }
    this(ASTNode op, ASTNode[] args) {
        this.type  = NodeType.node;
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
        return "int:"~value.to!string;
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
        return "str:"~value;
    }
}