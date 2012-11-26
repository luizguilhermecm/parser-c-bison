#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PRIME 253

typedef struct HashTable HashTable;
typedef struct HashNode HashNode;
struct HashTable
{
        HashNode* Bucket[PRIME];
        char* name;
        HashTable* FuncList;
        char* func_type;
        int numFunc;
        int numArgs;
};

struct HashNode
{
        char* type;
        char* identifier;
        HashNode* next;
};

struct HashTable * newHashTable(char* aux);

void newHashNode(HashTable* aux, char* t, char* id);

struct HashTable * newFunc(HashTable* aux, char* t, char* id);

void hasEqual(HashNode*, char*);
