//
//  EpiInfoNavigationController.m
//  EpiInfo
//
//  Created by John Copeland on 6/17/13.
//

#import "EpiInfoNavigationController.h"
#import "StatCalcViewController.h"


@interface EpiInfoNavigationController ()

@end

@implementation EpiInfoNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    if ([[self.topViewController.class description] isEqualToString:@"EpiInfoViewController"])
        return [self.topViewController shouldAutorotate];
    else if ([[self.topViewController.class description] isEqualToString:@"AnalysisViewController"])
        return [self.topViewController shouldAutorotate];
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        UIViewController *uivc = [super popViewControllerAnimated:animated];
        return uivc;
    }

    UIViewController *uivc;
    NSString *lastVC = [[[self.viewControllers objectAtIndex:self.viewControllers.count - 1] class] description];

    if ([lastVC isEqualToString:@"StatCalc2x2ViewController"] ||
        [lastVC isEqualToString:@"MatchedPairCalculatorViewController"] ||
        [lastVC isEqualToString:@"SampleSizeAndPowerViewController"] ||
        [lastVC isEqualToString:@"ChiSquareCalculatorViewController"] ||
        [lastVC isEqualToString:@"PoissonCalculatorViewController"] ||
        [lastVC isEqualToString:@"BinomialCalculatorViewController"] ||
        [lastVC isEqualToString:@"PopulationSurveyViewController"] ||
        [lastVC isEqualToString:@"CohortSampleSizeViewController"] ||
        [lastVC isEqualToString:@"AnalysisViewController"] ||
        [lastVC isEqualToString:@"StatCalcViewController"] ||
        [lastVC isEqualToString:@"DataEntryViewController"] ||
        [lastVC isEqualToString:@"VHFViewController"] ||
        [lastVC isEqualToString:@"SimulationsViewController"] ||
        [lastVC isEqualToString:@"EpiInfo.SimulationsViewControllerSwift"] ||
        [lastVC isEqualToString:@"GrowthPercentilesViewController"] ||
        [lastVC isEqualToString:@"UnmatchedCaseControlSampleSizeViewController"])
    {
        UIImage *screenshot;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            UIView *lastView = [[self.viewControllers objectAtIndex:self.viewControllers.count - 1] view];
            UIGraphicsBeginImageContext(lastView.frame.size);
            [lastView.layer renderInContext:UIGraphicsGetCurrentContext()];
            screenshot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        StatCalcViewController *srcViewController = (StatCalcViewController *)[self.viewControllers objectAtIndex:self.viewControllers.count - 2];
        
        UIView *lastView = [[self.viewControllers objectAtIndex:self.viewControllers.count - 1] view];
        UIView *lastViewsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lastView.frame.size.width, lastView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
        [lastViewsView setBackgroundColor:[UIColor clearColor]];
        [lastView setFrame:CGRectMake(0, srcViewController.navigationController.navigationBar.frame.size.height, lastView.frame.size.width, lastView.frame.size.height)];
        [lastViewsView addSubview:lastView];
        UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [mainWindow addSubview:lastViewsView];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             [lastViewsView setTransform:CGAffineTransformMakeScale(0.2, 0.1)];
                             [lastViewsView setFrame:CGRectMake([srcViewController buttonPressed].superview.frame.origin.x, [srcViewController buttonPressed].superview.frame.origin.y + 2.5 * srcViewController.navigationController.navigationBar.frame.size.height, 20, 20)];
                         }
                         completion:^(BOOL finished){
                             [lastViewsView removeFromSuperview];
                         }];
        
        uivc = [super popViewControllerAnimated:NO];
//        StatCalcViewController *srcViewController = (StatCalcViewController *)[self.viewControllers objectAtIndex:self.viewControllers.count - 1];
//        UIView *srcView = [srcViewController view];
//        UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//        
//        UIImageView *imageView;
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, srcView.frame.origin.y - srcViewController.navigationController.navigationBar.frame.size.height, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
//        else
//        {
//            if (UIInterfaceOrientationIsPortrait([uivc interfaceOrientation]))
//            {
//                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, srcView.frame.origin.y - srcViewController.navigationController.navigationBar.frame.size.height, srcView.frame.size.width, srcView.frame.size.height + srcViewController.navigationController.navigationBar.frame.size.height)];
//            }
//            else
//            {
//                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-74, 136, 1024, 704 + srcViewController.navigationController.navigationBar.frame.size.height)];
//                [imageView setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
//            }
//        }
//        
//        [imageView setClipsToBounds:YES];
//
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && UIInterfaceOrientationIsLandscape([uivc interfaceOrientation]))
//            [imageView setImage:screenshot];
//        else
//            [imageView setImage:[UIImage imageNamed:[srcViewController imageFileToUseInSegue]]];
//        
//        [mainWindow addSubview:imageView];
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//                                 [imageView setFrame:CGRectMake(srcViewController.buttonPressed.superview.superview.frame.origin.x + srcViewController.frameOfButtonPressed.origin.x,
//                                                                srcViewController.buttonPressed.superview.superview.frame.origin.y + srcViewController.frameOfButtonPressed.origin.y + 1.5 * srcViewController.navigationController.navigationBar.frame.size.height,
//                                                                60, 60)];
//                             else
//                             {
//                                 if (UIInterfaceOrientationIsPortrait([uivc interfaceOrientation]))
//                                 {
//                                     [imageView setFrame:CGRectMake(srcViewController.buttonPressed.superview.superview.frame.origin.x + srcViewController.frameOfButtonPressed.origin.x,
//                                                                    srcViewController.buttonPressed.superview.superview.frame.origin.y + srcViewController.frameOfButtonPressed.origin.y + srcViewController.navigationController.navigationBar.frame.size.height,
//                                                                    76, 76)];
//                                 }
//                                 else
//                                 {
//                                     [imageView setFrame:CGRectMake(srcViewController.buttonPressed.superview.superview.frame.origin.y + srcViewController.frameOfButtonPressed.origin.y + srcViewController.navigationController.navigationBar.frame.size.height + 20,
//                                                                    srcView.frame.size.width - (srcViewController.buttonPressed.superview.superview.frame.origin.x + srcViewController.frameOfButtonPressed.origin.x) - 80,
//                                                                    76, 76)];
//                                 }
//                             }
//                         }
//                         completion:^(BOOL finished){
//                             [imageView removeFromSuperview];
//                         }];
    }
    else
    {
        uivc = [super popViewControllerAnimated:animated];
    }
    return uivc;
}

@end
