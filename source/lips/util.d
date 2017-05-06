import ASTItems;


bool is_false(ASTNode node) {
    return node.type == NodeType.list && node.elements.length == 0;
}