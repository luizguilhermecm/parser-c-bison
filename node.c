#include <node.h>

struct Node *newNode(TreeNode* _one, TreeNode* _two, TreeNode* _three, TreeNode* _four)
{
        TreeNode* aux = (TreeNode*)malloc(sizeof(struct Node));
        aux->one = _one;
        aux->two = _two;
        aux->three = _three;
        aux->four = _four;
        
        aux->node_type = -1;

        return aux;
}
void setId(TreeNode* _node, char* id)
{
        _node->node_id = id;
}

char * getId(TreeNode* _node)
{
        return _node->node_id;
}

void setType(TreeNode* _node, int type)
{
        _node->node_type = type;
}
