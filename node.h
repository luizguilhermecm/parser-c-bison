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
        char * node_id;
};


struct Node *newNode(TreeNode* _one,
                 TreeNode* _two,
                 TreeNode* _three,
                 TreeNode* _four);

void setType(TreeNode* _node, int type);
void setId(TreeNode* _node, char* id);
char * getId(TreeNode* _node);
