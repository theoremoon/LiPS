import std.conv;

enum TokenType
{
    integer,
    string,
    open,
    close,
    identifier,
}

class Token
{
    public {
        TokenType type;
        string value;
    }

    public {
        this(TokenType type, string value) {
            this.type = type;
            this.value = value;
        }

        override string toString()
        {
            return " " ~ type.to!string ~ ":" ~ value ~ " ";
            // return "Token{type=" ~ type.to!string ~ ", value=" ~ value ~ "}";
        }
    }
}