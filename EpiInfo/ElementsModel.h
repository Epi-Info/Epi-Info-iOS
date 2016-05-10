//
//  ElementsModel.h
//  EpiInfo
//
//  Created by admin on 1/14/16.
//  Copyright © 2016 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ElementsModel : NSObject
{
    NSString *elementName;
    NSString *uniqueId;
    int type;
    int tag;
    BOOL req;
    NSString *promptText;
    BOOL input;
}

@property(nonatomic) NSString *elementName;
@property(nonatomic) NSString *uniqueId;
@property(nonatomic) int type;
@property(nonatomic) int tag;
@property(nonatomic)BOOL req;
@property(nonatomic) NSString *promptText;
@property(nonatomic)BOOL input;


-(id)initWithElement:(NSString *)newElement uniqueId:(NSString *)newUniqueId type:(int)newType tag:(int)newTag required:(BOOL)newReq prompt:(NSString *)newPrompt value:(BOOL)newValue;

@end
