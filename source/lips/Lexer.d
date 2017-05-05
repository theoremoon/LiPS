/** Lexical Analyzer */

import ASTItems, Token;

import std.string, core.stdc.ctype, std.conv, std.algorithm;

Token[] lex(string src)
{
    Token[] tokens;
    int p = 0;
    while (p < src.length)
    {
        while (p < src.length && src[p].isspace)
        {
            p++;
        }

        if (src[p].isdigit)
        {
            // 数値のTokenize
            int p2 = p + 1;
            while (p2 < src.length && src[p .. p2].isNumeric)
            {
                p2++;
            }
            p2--;

            tokens ~= new Token(TokenType.integer, src[p .. p2]);
            p = p2;
        }
        else if (src[p] == '\'')
        {
            // 文字列のTokenize
            p++;
            int p2 = p + 1;
            while (p2 < src.length && src[p2] != '\'')
            {
                p2++;
            }
            tokens ~= new Token(TokenType.string, src[p .. p2]);
            p = p2+1;
        }
        else if (src[p] == '(')
        {
            p++;
            tokens ~= new Token(TokenType.open, "(");
        }
        else if (src[p] == ')')
        {
            p++;
            tokens ~= new Token(TokenType.close, ")");
        }
        else
        {
            int p2 = p + 1;
            while (p2 < src.length && !src[p2].isspace && !"()'".canFind(src[p2]))
            {
                p2++;
            }
            tokens ~= new Token(TokenType.identifier, src[p .. p2]);
            p = p2;
        }

    }

    return tokens;
}
