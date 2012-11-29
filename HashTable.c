#include "HashTable.h"

struct HashTable* newHashTable(char* aux)
{
        HashTable* foo = (HashTable*)malloc(sizeof(struct HashTable));
        foo->name = aux;

        return foo;
}

void newHashNode(HashTable* aux, char* t, char* id, char* arg)
{

        int ascValue = 0;
        int hashValue;
        int count;
        for(count = 0; id[count] != '\0'; count++){
                ascValue += id[count];
        }

        do{
                hashValue = ascValue % PRIME;
        }while(hashValue > PRIME);

        HashNode* newBucket;

        if(aux->Bucket[hashValue]!= NULL){
                hasEqual(aux->Bucket[hashValue], id);

                newBucket = (HashNode*)malloc(sizeof(struct HashNode));
                newBucket->type = t;
                newBucket->identifier = id;
                newBucket->isArg = arg;
                newBucket->next = aux->Bucket[hashValue];
                aux->Bucket[hashValue] = newBucket;
       }else{
                newBucket = (HashNode*)malloc(sizeof(struct HashNode));
                newBucket->type = t;
                newBucket->identifier = id;
                newBucket->isArg = arg;
                newBucket->next = NULL;
                aux->Bucket[hashValue] = newBucket;
       }

}

void hasEqual(HashNode* foo, char* id)
{
        if(foo){
                if(strcmp(foo->identifier,id) == 0){
                        printf("sao iguais\n");
                }
                foo = foo->next;
        }       
}

struct HashTable* newFunc(HashTable* aux, char* t, char* id)
{
        HashTable* foo = newHashTable(id);
        foo->FuncList = aux->FuncList;
        aux->FuncList = foo;
        foo->func_type = t;
        newHashNode(aux,t,id,"FUNC");

        return foo;
}


struct HashNode * newHNode(char* t, char* id, char* isArg){
        HashNode* aux = (HashNode*)malloc(sizeof(struct HashNode));
        aux->type = t;
        aux->identifier = id;
        aux->isArg = isArg;

        return aux;
}

void insertNode(HashTable* aux, HashNode* hnode)
{
        char* t = hnode->type;
        char* id = hnode->identifier;
        char* arg = hnode->isArg;
        int ascValue = 0;
        int hashValue;
        int count;
        for(count = 0; id[count] != '\0'; count++){
                ascValue += id[count];
        }

        do{
                hashValue = ascValue % PRIME;
        }while(hashValue > PRIME);

        HashNode* newBucket;

        if(aux->Bucket[hashValue]!= NULL){
                hasEqual(aux->Bucket[hashValue], id);

                newBucket = (HashNode*)malloc(sizeof(struct HashNode));
                newBucket->type = t;
                newBucket->identifier = id;
                newBucket->isArg = arg;
                newBucket->next = aux->Bucket[hashValue];
                aux->Bucket[hashValue] = newBucket;
       }else{
                newBucket = (HashNode*)malloc(sizeof(struct HashNode));
                newBucket->type = t;
                newBucket->identifier = id;
                newBucket->isArg = arg;
                newBucket->next = NULL;
                aux->Bucket[hashValue] = newBucket;
       }
}
