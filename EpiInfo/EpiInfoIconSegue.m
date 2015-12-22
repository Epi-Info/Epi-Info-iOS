//
//  EpiInfoIconSegue.m
//  EpiInfo
//
//  Created by John Copeland on 10/30/13.
//

#import "EpiInfoIconSegue.h"
#import "StatCalcViewController.h"
#import "SampleSizeAndPowerViewController.h"
#import "AnalysisViewController.h"

@implementation EpiInfoIconSegue
- (void)perform
{
    UIViewController *desViewController = (UIViewController *)self.destinationViewController;
//    if ([desViewController isKindOfClass:[AnalysisViewController class]])
//        return;
    StatCalcViewController *srcViewController = (StatCalcViewController *)self.sourceViewController;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
    {
        [srcViewController.navigationController pushViewController:desViewController animated:YES];
        return;
    }
    
    UIView *srcView = [(UIViewController *)self.sourceViewController view];
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    UIImageView *imageView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(srcViewController.buttonPressed.superview.superview.frame.origin.x + srcViewController.frameOfButtonPressed.origin.x,
                                                                  srcViewController.buttonPressed.superview.superview.frame.origin.y + srcViewController.frameOfButtonPressed.origin.y + 1.5 * srcViewController.navigationController.navigationBar.frame.size.height,
                                                                  60, 60)];
    else
    {
        if (UIInterfaceOrientationIsPortrait([srcViewController interfaceOrientation]))
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(srcViewController.buttonPressed.superview.superview.frame.origin.x + srcViewController.frameOfButtonPressed.origin.x,
                                                                      srcViewController.buttonPressed.superview.superview.frame.origin.y + srcViewController.frameOfButtonPressed.origin.y + srcViewController.navigationController.navigationBar.frame.size.height,
                                                                      76, 76)];
        }
        else
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(srcViewController.buttonPressed.superview.superview.frame.origin.y + srcViewController.frameOfButtonPressed.origin.y + srcViewController.navigationController.navigationBar.frame.size.height + 20,
                                                                      srcView.frame.size.width - (srcViewController.buttonPressed.superview.superview.frame.origin.x + srcViewController.frameOfButtonPressed.origin.x) - 80,
                                                                      76, 76)];
            [imageView setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        }
    }

    [imageView setClipsToBounds:YES];
    [imageView setImage:[UIImage imageNamed:[srcViewController imageFileToUseInSegue]]];
    [mainWindow addSubview:imageView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                             [imageView setFrame:CGRectMake(0, srcView.frame.origin.y - srcViewController.navigationController.navigationBar.frame.size.height, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
                         else
                         {
                             if (UIInterfaceOrientationIsPortrait([srcViewController interfaceOrientation]))
                             {
                                 [imageView setFrame:CGRectMake(0, srcView.frame.origin.y - srcViewController.navigationController.navigationBar.frame.size.height, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
                             }
                             else
                             {
                                 [imageView setFrame:CGRectMake(20, srcView.frame.size.width - srcView.frame.size.height - 44, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         [srcViewController.navigationController pushViewController:desViewController animated:NO];
                         [imageView removeFromSuperview];
                     }];
}
@end
