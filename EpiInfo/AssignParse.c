//
//  AssignParse.c
//  EpiInfo
//
//  Created by John Copeland on 8/5/16.
//

#include <stdio.h>
#include <string.h>
#include "AssignParse.h"

int substringEquals(char* string0, int startIndex, int substringLength, char* string1) {
    if (strlen(string1) != substringLength) {
        return 0;
    }
    for (int i = 0; i < substringLength; i++) {
        if (string0[startIndex + i] != string1[i]) {
            return 0;
        }
    }
    return 1;
}

int firstIndexOf(char* s, char c) {
    for (int i = 0; i < strlen(s); i++) {
        if (s[i] == c) {
            return i;
        }
    }
    return -1;
}

void tokenizeFunctionParameters(struct AssignPieces ap) {
    int commaIndex = firstIndexOf(ap.initialText, ',');
    printf("%s has a comma at %d.\n", ap.initialText, commaIndex);
    if (commaIndex < 0) {
        return;
    }
    
    char stra[strlen(ap.initialText)];
    memcpy(stra, &ap.initialText[1], commaIndex - 1);
    stra[commaIndex - 1] = '\0';
    ap.token0->initialText = stra;
    printf("%s\n", ap.token0->initialText);
}

void tokenize(struct AssignPieces ap) {
    if (strpbrk(ap.initialText, "+-/*")) {
        printf("%s contains arithmetic\n", ap.initialText);
    }
    else if (strpbrk(ap.initialText, ")(")) {
        if (substringEquals(ap.initialText, 0, 5, "years") == 1) {
            ap.token0->initialText = "years";
            char* strbuff = ap.initialText;
            memcpy(strbuff, &ap.initialText[5], strlen(ap.initialText) - 5);
            strbuff[strlen(ap.initialText) - 5] = '\0';
            ap.token1->initialText = strbuff;
            printf("%s\n", ap.token1->initialText);
            tokenizeFunctionParameters(*ap.token1);
            printf("%s\n", ap.token1->initialText);
            printf("%s\n", ap.token1->token0->initialText);
        }
        else if (substringEquals(ap.initialText, 0, 5, "months") == 1) {
            printf("months\n");
        }
        else if (substringEquals(ap.initialText, 0, 5, "days") == 1) {
            printf("days\n");
        }
    }
    else {
        return;
    }
    return;
}

struct AssignPieces parseAssign(char* statement) {
    char one = statement[0];
    printf("%c\n", one);
    static char retstmt[100];
    strcpy(retstmt, "Hello, ");
    strcat(retstmt, statement);
    struct AssignPieces ap;
    ap.initialText = statement;
    tokenize(ap);
    printf("%s\n", ap.token1->initialText);
    return ap;
}
