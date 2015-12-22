//
//  SampleSizeAndPowerViewController.m
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//

#import "SampleSizeAndPowerViewController.h"
#import "PopulationSurveyViewController.h"

@implementation SampleSizeAndPowerViewController
-(BlurryView *)blurryView
{
    return blurryView;
}
- (CGRect)frameOfButtonPressed
{
    return frameOfButtonPressed;
}
- (UIButton *)buttonPressed
{
    return buttonPressed;
}
- (void)setImageFileToUseInSegue:(NSString *)imageFile
{
    imageFileToUseInSegue = imageFile;
}
- (NSString *)imageFileToUseInSegue
{
    return imageFileToUseInSegue;
}

-(void)viewDidLoad
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SampleSize" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.populationSurveyButton setTitle:@"" forState:UIControlStateNormal];
            [self.cohortButton setTitle:@"" forState:UIControlStateNormal];
            [self.unmatchedCaseControlButton setTitle:@"" forState:UIControlStateNormal];
        }
        
        button1Frame = CGRectMake(30, 60, 260, 44);
        button2Frame = CGRectMake(30, 111, 260, 44);
        button3Frame = CGRectMake(30, 162, 260, 44);
        
        [self.populationSurveyButton setFrame:button1Frame];
        [self.cohortButton setFrame:button2Frame];
        [self.unmatchedCaseControlButton setFrame:button3Frame];

        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
        [fadingColorView setImage:[UIImage imageNamed:@"FadeDownS.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        CGRect cdcImageFrame = CGRectMake(2, [self.view frame].size.height - 146, (450.0 / 272.0) * 100.0, 100.0);
        cdcImageView = [[UIImageView alloc] initWithFrame:cdcImageFrame];
        
        // Convert color imate to black and white
        UIImage *cdcImage = [UIImage imageNamed:@"CDCLogo.jpeg"];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef contextRef = CGBitmapContextCreate(nil, cdcImage.size.width, cdcImage.size.height, 8, cdcImage.size.width, colorSpace, kCGImageAlphaNone);
        CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
        CGContextSetShouldAntialias(contextRef, NO);
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cdcImage.size.width, cdcImage.size.height), [cdcImage CGImage]);
        CGImageRef bwImage = CGBitmapContextCreateImage(contextRef);
        CGContextRelease(contextRef);
        CGColorSpaceRelease(colorSpace);
        UIImage *bwCDCImage = [UIImage imageWithCGImage:bwImage];
        CGImageRelease(bwImage);
        
        [cdcImageView setImage:bwCDCImage];
        [cdcImageView setAlpha:0.2];
        
        CGRect hhsImageFrame = CGRectMake(-2.0 - (300.0 / 293.0) * 100.0 + [self.view frame].size.width, [self.view frame].size.height - 146, (300.0 / 293.0) * 100.0, 100.0);
        hhsImageView = [[UIImageView alloc] initWithFrame:hhsImageFrame];
        UIImage *hhsImage = [UIImage imageNamed:@"HHSLogo.jpeg"];
        [hhsImageView setImage:hhsImage];
        [hhsImageView setAlpha:0.2];

        [self.view addSubview:cdcImageView];
        [self.view addSubview:hhsImageView];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.populationSurveyButton setBackgroundColor:[UIColor whiteColor]];
            [self.populationSurveyButton.layer setCornerRadius:10.0];
            [self.populationSurveyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.cohortButton setBackgroundColor:[UIColor whiteColor]];
            [self.cohortButton.layer setCornerRadius:10.0];
            [self.cohortButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [self.unmatchedCaseControlButton setBackgroundColor:[UIColor whiteColor]];
            [self.unmatchedCaseControlButton.layer setCornerRadius:10.0];
            [self.unmatchedCaseControlButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            blurryView = [BlurryView new];
            [blurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y - 20, button1Frame.size.width + 40, button3Frame.origin.y - button1Frame.origin.y + button3Frame.size.height + 40)];
            [self.view addSubview:blurryView];
//            [blurryView setBlurTintColor:[UIColor colorWithRed:50/255.0 green:71/255.0 blue:92/255.0 alpha:1.0]];
            [blurryView setBlurTintColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [blurryView.layer setCornerRadius:40.0];
            
            UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800), sqrtf(800), 60, 90)];
            UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(blurryView.frame.size.width - sqrtf(800) - 60, sqrtf(800), 60, 90)];
            UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(sqrtf(800) + 60 + (v3.frame.origin.x - (sqrtf(800) + 60)) / 2.0 - 57 / 2.0, sqrtf(800), 60, 90)];
            
            [v1 setBackgroundColor:[UIColor clearColor]];
            [v2 setBackgroundColor:[UIColor clearColor]];
            [v3 setBackgroundColor:[UIColor clearColor]];
            
            [blurryView addSubview:v1];
            [blurryView addSubview:v2];
            [blurryView addSubview:v3];
            
            [self.populationSurveyButton setFrame:CGRectMake(0, 0, 60, 60)];
            [self.cohortButton setFrame:CGRectMake(0, 0, 60, 60)];
            [self.unmatchedCaseControlButton setFrame:CGRectMake(0, 0, 60, 60)];
            
            [self.populationSurveyButton.layer setCornerRadius:10.0];
            [self.cohortButton.layer setCornerRadius:10.0];
            [self.unmatchedCaseControlButton.layer setCornerRadius:10.0];
            
            [self.populationSurveyButton setBackgroundImage:[UIImage imageNamed:@"PopulationStudy.png"] forState:UIControlStateNormal];
            [self.cohortButton setBackgroundImage:[UIImage imageNamed:@"CohortCrossSectional.png"] forState:UIControlStateNormal];
            [self.unmatchedCaseControlButton setBackgroundImage:[UIImage imageNamed:@"UnmatchedCaseControl.png"] forState:UIControlStateNormal];
            
            [self.populationSurveyButton setClipsToBounds:YES];
            [self.cohortButton setClipsToBounds:YES];
            [self.unmatchedCaseControlButton setClipsToBounds:YES];
            
            [self.populationSurveyButton setBackgroundColor:[UIColor clearColor]];
            [self.cohortButton setBackgroundColor:[UIColor clearColor]];
            [self.unmatchedCaseControlButton setBackgroundColor:[UIColor clearColor]];
            
            [self.populationSurveyButton setTitle:@"Population survey" forState:UIControlStateNormal];
            [self.cohortButton setTitle:@"Cohort or cross sectional" forState:UIControlStateNormal];
            [self.unmatchedCaseControlButton setTitle:@"Unmatched case control" forState:UIControlStateNormal];
            
            [self.populationSurveyButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.cohortButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.unmatchedCaseControlButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            [v1 addSubview:self.populationSurveyButton];
            [v2 addSubview:self.cohortButton];
            [v3 addSubview:self.unmatchedCaseControlButton];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 60, 12)];
            UILabel *label1b = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, 60, 12)];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(-8, 64, 76, 12)];
            UILabel *label2b = [[UILabel alloc] initWithFrame:CGRectMake(-13, 76, 86, 12)];
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(-5, 64, 70, 12)];
            UILabel *label3b = [[UILabel alloc] initWithFrame:CGRectMake(-5, 76, 70, 12)];
            
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label1b setBackgroundColor:[UIColor clearColor]];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2b setBackgroundColor:[UIColor clearColor]];
            [label3 setBackgroundColor:[UIColor clearColor]];
            [label3b setBackgroundColor:[UIColor clearColor]];
            
            [label1 setText:@"Population"];
            [label1b setText:@"Survey"];
            [label2 setText:@"Cohort or"];
            [label2b setText:@"CrossSectional"];
            [label3 setText:@"Unmatched"];
            [label3b setText:@"CaseControl"];
            
            [label1 setTextColor:[UIColor whiteColor]];
            [label1b setTextColor:[UIColor whiteColor]];
            [label2 setTextColor:[UIColor whiteColor]];
            [label2b setTextColor:[UIColor whiteColor]];
            [label3 setTextColor:[UIColor whiteColor]];
            [label3b setTextColor:[UIColor whiteColor]];
            
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1b setTextAlignment:NSTextAlignmentCenter];
            [label2 setTextAlignment:NSTextAlignmentCenter];
            [label2b setTextAlignment:NSTextAlignmentCenter];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [label3b setTextAlignment:NSTextAlignmentCenter];
            
            [label1 setFont:[UIFont systemFontOfSize:12.0]];
            [label1b setFont:[UIFont systemFontOfSize:12.0]];
            [label2 setFont:[UIFont systemFontOfSize:12.0]];
            [label2b setFont:[UIFont systemFontOfSize:12.0]];
            [label3 setFont:[UIFont systemFontOfSize:12.0]];
            [label3b setFont:[UIFont systemFontOfSize:12.0]];
            
            [v1 addSubview:label1];
            [v1 addSubview:label1b];
            [v2 addSubview:label2];
            [v2 addSubview:label2b];
            [v3 addSubview:label3];
            [v3 addSubview:label3b];
            
            [blurryView setFrame:CGRectMake(button1Frame.origin.x - 20, button1Frame.origin.y, button1Frame.size.width + 40, v3.frame.origin.y + v3.frame.size.height + sqrtf(800))];
            
            self.title = @"Epi Info StatCalc";
            UILabel *phoneHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 19.5, 280, 21)];
            [phoneHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [phoneHeaderLabel setTextColor:[UIColor whiteColor]];
            [phoneHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [phoneHeaderLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [phoneHeaderLabel setText:@"Sample Size and Power"];
            [self.view addSubview:phoneHeaderLabel];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self.populationSurveyButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.cohortButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.unmatchedCaseControlButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.populationSurveyButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 -  button1Frame.size.width / 2.0, button1Frame.origin.y - 40, button1Frame.size.width, button1Frame.size.height)];
                [self.cohortButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 -  button1Frame.size.width / 2.0, button2Frame.origin.y - 40, button1Frame.size.width, button1Frame.size.height)];
                [self.unmatchedCaseControlButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 -  button1Frame.size.width / 2.0, button3Frame.origin.y - 40, button1Frame.size.width, button1Frame.size.height)];
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [self.populationSurveyButton setFrame:button1Frame];
                    [self.cohortButton setFrame:button2Frame];
                    [self.unmatchedCaseControlButton setFrame:button3Frame];
                    
                    [self.view bringSubviewToFront:self.populationSurveyButton];
                    [self.view bringSubviewToFront:self.cohortButton];
                    [self.view bringSubviewToFront:self.unmatchedCaseControlButton];
                }
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
    }
//    Commented lines were used to create a screenshot image.
//    UIView *tmpV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    
//    UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.navigationController.navigationBar.bounds.size.height)];
//    UIGraphicsBeginImageContext(self.navigationController.navigationBar.bounds.size);
//    [self.navigationController.navigationBar.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *bar = UIGraphicsGetImageFromCurrentImageContext();
//    [barView setImage:bar];
//    UIGraphicsEndImageContext();
//    
//    UIImageView *screenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height)];
//    UIGraphicsBeginImageContext(screenView.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
//    [screenView setImage:screen];
//    UIGraphicsEndImageContext();
//    
//    [tmpV addSubview:barView];
//    [tmpV addSubview:screenView];
//    
//    UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + self.navigationController.navigationBar.bounds.size.height));
//    [tmpV.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData *imageData = UIImagePNGRepresentation(imageToSave);
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/SampleSizeScreen.png" atomically:YES];
//    To here
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    frameOfButtonPressed = [[(UIButton *)sender superview] frame];
    buttonPressed = (UIButton *)sender;
    if ([segue.identifier isEqualToString:@"ShowPopulationSurvey"])
    {
        [self setImageFileToUseInSegue:@"PhonePopulationSSScreenshot"];
    }
    else if ([segue.identifier isEqualToString:@"ShowCohortStudy"])
    {
        [self setImageFileToUseInSegue:@"PhoneCohortSSScreenshot"];
    }
    else if ([segue.identifier isEqualToString:@"ShowUnmatchedCaseControlStudy"])
    {
        [self setImageFileToUseInSegue:@"PhoneCCSSScreenshot"];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentOrientationPortrait = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
        }];
        if (currentOrientationPortrait)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.populationSurveyButton setFrame:button1Frame];
                [self.cohortButton setFrame:button2Frame];
                [self.unmatchedCaseControlButton setFrame:button3Frame];

                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.populationSurveyButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 -  button1Frame.size.width / 2.0, button1Frame.origin.y - 40, button1Frame.size.width, button1Frame.size.height)];
                [self.cohortButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 -  button1Frame.size.width / 2.0, button2Frame.origin.y - 40, button1Frame.size.width, button1Frame.size.height)];
                [self.unmatchedCaseControlButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 -  button1Frame.size.width / 2.0, button3Frame.origin.y - 40, button1Frame.size.width, button1Frame.size.height)];
                
                [cdcImageView setFrame:CGRectMake(2, [self.view frame].size.height - 50, (450.0 / 272.0) * 50.0, 50.0)];
                [hhsImageView setFrame:CGRectMake(-2.0 - (300.0 / 293.0) * 50.0 + [self.view frame].size.width, [self.view frame].size.height - 50, (300.0 / 293.0) * 50.0, 50.0)];
                [fadingColorView setFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
            }];
        }
    }
}
@end
