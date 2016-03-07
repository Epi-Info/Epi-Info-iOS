//
//  DialogModel.h
//  EpiInfo
//
//  Created by admin on 2/29/16.
//  Copyright © 2016 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogModel : NSObject
{
    NSString *from;
    NSString *name;
   // NSString *element;
    NSString *beforeAfter;
    NSString *title;
    NSString *subject;
    BOOL displayed;
}

@property(nonatomic) NSString *from;
@property(nonatomic) NSString *name;
//@property(nonatomic) NSString *element;
@property(nonatomic) NSString *beforeAfter;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *subject;
@property(nonatomic) BOOL displayed;

-(id)initWithFrom:(NSString *)newFrom name:(NSString *)newName beforeAfter:(NSString *)newbeforeAfter title:(NSString *)newTitle subject:(NSString *)newSubject displayed:(BOOL)newDisplayed;
@end