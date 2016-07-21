//
//  DialogModel.m
//  EpiInfo
//
//  Created by admin on 2/29/16.
//  Copyright © 2016 John Copeland. All rights reserved.
//

#import "DialogModel.h"

@implementation DialogModel
@synthesize from;
@synthesize name;
//@synthesize element;
@synthesize beforeAfter;
@synthesize title;
@synthesize subject;
@synthesize displayed;

-(id)initWithFrom:(NSString *)newFrom name:(NSString *)newName beforeAfter:(NSString *)newbeforeAfter title:(NSString *)newTitle subject:(NSString *)newSubject displayed:(BOOL)newDisplayed{
    self = [super init];
    if (self!=nil) {
        self.from = newFrom;
        self.name = newName;
       // self.element = newElement;
        self.beforeAfter = newbeforeAfter;
        self.title = newTitle;
        self.subject = newSubject;
        self.displayed = newDisplayed;
    }
    
    return self;
}
@end
