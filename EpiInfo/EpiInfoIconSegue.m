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
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
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
//    [mainWindow addSubview:imageView];
    
    UIView *analysisSubViewToSave;
    UIView *destinationView = [desViewController view];
    for (UIView *v in [destinationView subviews])
        if (v.frame.origin.y < 0.0 && [desViewController isKindOfClass:[AnalysisViewController class]])
        {
            analysisSubViewToSave = v;
            [v removeFromSuperview];
        }
    UIView *desView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, destinationView.frame.size.width, destinationView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)];
    [desView setBackgroundColor:[UIColor clearColor]];
    [destinationView setFrame:CGRectMake(0, srcViewController.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, destinationView.frame.size.width, destinationView.frame.size.height)];
    [desView addSubview:destinationView];
//    [desView setFrame:[imageView frame]];
    [desView  setTransform:CGAffineTransformMakeScale(0.2, 0.1)];
    CGPoint centerPoint = [desView center];
    [desView setCenter:imageView.center];
    [mainWindow addSubview:desView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [desView  setTransform:CGAffineTransformIdentity];
                         [desView setCenter:centerPoint];
//                         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//                         {
//                             [desView setFrame:CGRectMake(0, srcView.frame.origin.y - srcViewController.navigationController.navigationBar.frame.size.height, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
//                         }
//                         else
//                         {
//                             if (UIInterfaceOrientationIsPortrait([srcViewController interfaceOrientation]))
//                             {
//                                 [desView setFrame:CGRectMake(0, srcView.frame.origin.y - srcViewController.navigationController.navigationBar.frame.size.height, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
//                             }
//                             else
//                             {
//                                 [desView setFrame:CGRectMake(20, srcView.frame.size.width - srcView.frame.size.height - 44, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
//                             }
//                         }
                     }
                     completion:^(BOOL finished){
                         [srcViewController.navigationController pushViewController:desViewController animated:NO];
                         if (analysisSubViewToSave)
                             [[desViewController view] addSubview:analysisSubViewToSave];
                         [desView removeFromSuperview];
                     }];
}
@end
