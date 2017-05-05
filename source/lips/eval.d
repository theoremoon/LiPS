import ASTItems, types;

import std.stdio,
 std.traits;

ASTNode eval(ASTNode node)
{
    if (node.type == NodeType.node)
    {
        // function
        if (node.op is null)
        {
            throw new Exception("empty list is not valid");
        }
        if (auto op = cast(ASTIdentifier)node.op) {
            if (op.name == "print")
            {
                writeln(eval(node.args[0]));
            }
        }
        else {
            throw new Exception("function must be symbol");
        }
        return null;
    }
    else if (auto integer = cast(ASTInteger)node)
    {
        return integer;
    }
    else if (auto str = cast(ASTString)node)
    {
        return str;
    }
    else if (auto identifier = cast(ASTIdentifier)node) {
        return identifier;
    }
    
    throw new Exception("Unknown Type Node " ~ node.toString);
}