

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

    /// parseOne のラッパ
    ASTNode parse() {
        return parseOne();
    }

    /// これ以上無理というところまでパースする
    ASTNode[] parseAll() {
	ASTNode[] nodes;
	while (p < src.length) {
	    nodes ~= parseOne();
	}
	return nodes;
    }

    ASTNode parseParen() {
        ASTNode[] nodes;
        while (p < src.length) {
            if (src[p].type == TokenType.close) {
                p++;
                break;
            }
            nodes ~= parseOne();
        }

        return new ASTNode(nodes);
    }

    ASTNode parseOne() {
        ASTNode node;
        final switch (src[p].type)
        {
            case TokenType.open:
                p++;
                node = parseParen();
                break;
            case TokenType.close:
                throw new Exception(") appears. too many");
            case TokenType.string:
                node = new ASTString(src[p].value);
                p++;
                break;
            case TokenType.integer:
                node = new ASTInteger(src[p].value.to!int);
                p++;
                break;
            case TokenType.identifier:
                node = new ASTIdentifier(src[p].value);
                p++;
                break;
            case TokenType.quote:
                ASTNode[] quote;
                quote ~= new ASTIdentifier("quote");
                p++;
                quote ~= parseOne();
                node = new ASTNode(quote);
                break;
            case TokenType.qquote:
                ASTNode[] quote;
                quote ~= new ASTIdentifier("qquote");
                p++;
                quote ~= parseOne();
                node = new ASTNode(quote);
                break;
            case TokenType.unquote:
                ASTNode[] quote;
                quote ~= new ASTIdentifier("unquote");
                p++;
                quote ~= parseOne();
                node = new ASTNode(quote);
                break;
        }
        return node;
    }
}

/// Parserにつっこんで parseするだけ
ASTNode[] parse(Token[] src)
{
    auto parser = new Parser(src);
    return parser.parseAll();
}
