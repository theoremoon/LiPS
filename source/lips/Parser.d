

import Token, ASTItems;

import std.conv, std.stdio;

class Parser
{
    public
    {
        int p;
        Token[] src;
    }

    this(Token[] src)
    {
        this.p = 0;
        this.src = src;
    }

    ASTNode parse() {
        p++;
        return parseImpl();
    }

    ASTNode parseImpl()
    {

        ASTNode[] nodes;
        while (true)
        {
            final switch (src[p].type)
            {
            case TokenType.open:
                p++;
                nodes ~= parseImpl();
                break;
            case TokenType.close:
                p++;
                if (nodes.length == 0) {
                    return new ASTNode();
                }
                else if (nodes.length == 1) {
                    return new ASTNode(nodes[0], []);
                }

                return new ASTNode(nodes[0], nodes[1..$]);
           
            case TokenType.string:
                nodes ~= new ASTString(src[p].value);
                p++;
                break;
            case TokenType.integer:
                nodes ~= new ASTInteger(src[p].value.to!int);
                p++;
                break;
            case TokenType.identifier:
                nodes ~= new ASTIdentifier(src[p].value);
                p++;
                break;
            }
        }

        // throw new Exception("INVALID");
    }
}

ASTNode parse(Token[] src)
{
    auto parser = new Parser(src);
    return parser.parse();
}
