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
        _node->lval_id = id;
}

char * getId(TreeNode* _node)
{
        return _node->lval_id;
}

void setTipo(TreeNode* _node, char* tipo)
{
        _node->lval_tipo = tipo;
}

char * getTipo(TreeNode* _node)
{
        return _node->lval_tipo;
}

void setType(TreeNode* _node, int type)
{
        _node->node_type = type;
}

void setHnode(TreeNode* foo, HashNode* aux)
{
        foo->hnode = aux;
}

struct HashNode * getHnode(TreeNode * aux)
{
        return aux->hnode;
}
