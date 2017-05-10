/// 字句解析
import ASTItems, Token;

import std.string, core.stdc.ctype, std.conv, std.algorithm;

class Lexer
{
    public {
        string src;
        int p = 0;
    }

    this(string src) {
        this.src = src;
        this.p = 0;
    }

    void skip(){
        while (p < src.length && src[p].isspace)
        {
            p++;
        }
    }

    Token lexInt()
    {
        // 数値を殴る
        if (! src[p].isdigit) {
            return null;
        }
    
        int p2 = p + 1;
        while (p2<=src.length && src[p .. p2].isNumeric)
        {
            p2++;
        }
        p2--; // [p..p2]は既にnumericではないのでこうする

        auto token = new Token(TokenType.integer, src[p .. p2]);
        p = p2;

        return token;
    }

    Token lexStr()
    {
        if (src[p] != '"') {
            return null;
        }
        p++;
        int p2 = p + 1;
        while (p2<src.length && src[p2] != '"')
        {
            p2++;
        }
        // 最後の"は文字列ではないので、p2--とかしなくていい
        auto token = new Token(TokenType.string, src[p .. p2]);
        p = p2+1; // "を読み飛ばしてる

        return token;
    }

    Token lexOthers() {
        if (src[p] == '(')
        {
            p++;
            return new Token(TokenType.open, "(");
        }
        else if (src[p] == ')')
        {
            p++;
            return new Token(TokenType.close, ")");
        }
        else if (src[p]== '\'') 
        {
            p++;
            return new Token(TokenType.quote, "'");
        }
        else if (src[p]== '`') 
        {
            p++;
            return new Token(TokenType.qquote, "`");
        }
        else if (src[p]== ',') 
        {
            p++;
            return new Token(TokenType.unquote, ",");
        }
        return null;
    }

    Token lexIdentifier() {
        int p2 = p + 1;
        // 空白とか区切り文字が来るまで読み続けちゃえ
        while (p2<src.length && !src[p2].isspace && !"()'\"".canFind(src[p2]))
        {
            p2++;
        }
        auto token = new Token(TokenType.identifier, src[p .. p2]);
        p = p2;
        return token;
    }

    Token lexOne()
    {
        skip();
        if (p >= src.length) {
            return null;
        }
        auto token = lexInt();
        if (token) {
            return token;
        }
        token = lexStr();
        if (token) {
            return token;
        }
        token = lexOthers();
        if (token) {
            return token;
        }
        token = lexIdentifier;
        if (token) {
            return token;
        }
        return null;
    }

    Token[] lex()
    {
        Token[] tokens;
        Token token;
        while(true) {
            token = lexOne();
            if (token is null) {
                break;
            }
            tokens ~= token;
        }
        return tokens;
    }
}

/// 字句解析するよ
Token[] lex(string src)
{
    Lexer lexer = new Lexer(src);
    return lexer.lex();
}
