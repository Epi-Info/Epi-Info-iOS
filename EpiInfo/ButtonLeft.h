//
//  ButtonLeft.h
//  EpiInfo
//
//  Created by John Copeland on 5/30/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonLeft : UIButton
{
    UISlider *slider;
}
- (id)initWithFrame:(CGRect)frame AndSlider:(UISlider *)slider;
@end
