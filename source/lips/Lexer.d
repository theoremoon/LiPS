/// 字句解析
import ASTItems, Token;

import std.string, core.stdc.ctype, std.conv, std.algorithm;

/// 字句解析するよ
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
        // これがないと空白終わりのときに死ぬ
        if (p >= src.length) {
            break;
        }

        // 数値を殴る
        if (src[p].isdigit)
        {
            int p2 = p + 1;
            while (p2 < src.length && src[p .. p2].isNumeric)
            {
                p2++;
            }
            p2--;　// [p..p2]は既にnumericではないのでこうする

            tokens ~= new Token(TokenType.integer, src[p .. p2]);
            p = p2;
        }
        // 文字列
        else if (src[p] == '\'')
        {
            p++;
            int p2 = p + 1;
            while (p2 < src.length && src[p2] != '\'')
            {
                p2++;
            }
            // 最後の'は文字列ではないので、p2--とかしなくていい
            tokens ~= new Token(TokenType.string, src[p .. p2]);
            p = p2+1; // 'を読み飛ばしてる
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
        // 識別子
        else
        {
            int p2 = p + 1;
            // 空白とか区切り文字が来るまで読み続けちゃえ
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
