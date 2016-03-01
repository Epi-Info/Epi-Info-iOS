//
//  RelateButton.h
//  EpiInfo
//
//  Created by John Copeland on 2/25/16.
//

#import <UIKit/UIKit.h>

@interface RelateButton : UIButton
{
    NSString *relatedViewName;
    UIViewController *rootViewController;
    UIView *parentEDV;
    UIView *dismissView;
    UIView *edv;
    UIView *orangeBannerBackground;
    UIView *orangeBanner;
}
-(void)setRelatedViewName:(NSString *)rvn;
-(NSString *)relatedViewName;
-(void)setRootViewController:(UIViewController *)rvc;
-(UIViewController *)rootViewController;
-(void)setParentEDV:(UIView *)medv;
-(UIView *)parentEDV;
@end
