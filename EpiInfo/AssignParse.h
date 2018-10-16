//
//  AssignParse.h
//  EpiInfo
//
//  Created by John Copeland on 8/5/16.
//

#ifndef AssignParse_h
#define AssignParse_h

#include <stdio.h>
#include <string.h>

struct AssignPieces {
    char* initialText;
    char* element0;
    struct AssignPieces *token0;
    char* operator;
    char* element1;
    struct AssignPieces *token1;
};

struct AssignPieces parseAssign(char* statement);
#endif /* AssignParse_h */
