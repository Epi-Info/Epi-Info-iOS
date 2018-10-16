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
@synthesize page;
@synthesize uniqueId;
@synthesize type;
@synthesize tag;
@synthesize req;
@synthesize promptText;
@synthesize input;
@synthesize enable;
@synthesize highlight;
@synthesize hide;
@synthesize fieldValue;


-(id)initWithElement:(NSString *)newElement page:(NSString *)newPage uniqueId:(NSString *)newUniqueId type:(int)newType tag:(int)newTag required:(BOOL)newReq prompt:(NSString *)newPrompt value:(BOOL)newValue enable:(BOOL)newEnable highlight:(BOOL)newHighlight hidden:(BOOL)newHide fieldValue:(NSString *)newFieldValue
{
    self = [super init];
    if (self!=nil) {
        self.elementName = newElement;
        self.page = newPage;
        self.uniqueId = newUniqueId;
        self.type = newType;
        self.tag = newTag;
        self.req = newReq;
        self.promptText = newPrompt;
        self.input = newValue;
        self.enable = newEnable;
        self.highlight = newHighlight;
        self.hide = newHide;
        self.fieldValue = newFieldValue;
    }
    return self;
}
@end
