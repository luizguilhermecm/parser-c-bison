#include <stdio.h>
#include <stdlib.h>

typedef struct Node TreeNode;
struct Node
{
        TreeNode* one;
        TreeNode* two;
        TreeNode* three;
        TreeNode* four;

        int value;
        int node_type;
        char * lval_id;
        char * lval_tipo;
};


struct Node *newNode(TreeNode* _one,
                 TreeNode* _two,
                 TreeNode* _three,
                 TreeNode* _four);

void setType(TreeNode* _node, int type);
void setId(TreeNode* _node, char* id);
void setTipo(TreeNode* _node, char* tipo);
char * getId(TreeNode* _node);
char * getTipo(TreeNode* _node);
