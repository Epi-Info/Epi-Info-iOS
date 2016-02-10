//
//  ElementsModel.m
//  EpiInfo
//
//  Created by admin on 1/14/16.
//  Copyright © 2016 John Copeland. All rights reserved.
//

#import "ElementsModel.h"

@implementation ElementsModel
@synthesize elementName;
@synthesize uniqueId;
@synthesize type;
@synthesize tag;
@synthesize req;
@synthesize promptText;

-(id)initWithElement:(NSString *)newElement uniqueId:(NSString *)newUniqueId type:(int)newType tag:(int)newTag required:(BOOL)newReq prompt:(NSString *)newPrompt;
{
    self = [super init];
    if (self!=nil) {
        elementName = newElement;
        uniqueId = newUniqueId;
        type = newType;
        tag = newTag;
        req = newReq;
        promptText = newPrompt;
    }
    return self;
}
@end
