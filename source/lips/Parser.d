

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

    /// parseImpl のラッパ
    ASTNode parse() {
        p++; // ( を読み飛ばす
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
              
                return new ASTNode(nodes);
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
    }
}

/// Parserにつっこんで parseするだけ
ASTNode parse(Token[] src)
{
    auto parser = new Parser(src);
    return parser.parse();
}
