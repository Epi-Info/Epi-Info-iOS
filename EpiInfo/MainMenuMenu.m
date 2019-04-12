//
//  MainMenuMenu.m
//  EpiInfo
//
//  Created by John Copeland on 4/20/17.
//

#import "MainMenuMenu.h"
#import "EpiInfoViewController.h"
#import "PrivacyAndDisclaimerPresenter.h"
#include <sys/sysctl.h>

@implementation MainMenuMenu
@synthesize eivc = _eivc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *bannerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [bannerBack setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self addSubview:bannerBack];
        
        float bannerY = -4.0;
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithUTF8String:machine];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"]))
            bannerY = 8.0;
        UINavigationBar *banner = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, bannerY, frame.size.width, 32)];
        [banner setBackgroundColor:[UIColor clearColor]];
        [banner setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [banner setShadowImage:[UIImage new]];
        [self addSubview:banner];
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Information"];
        [banner setItems:[NSArray arrayWithObject:item]];
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(goBack)];
        [back setAccessibilityLabel:@"Back to Main Menu"];
        [back setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [item setRightBarButtonItem:back];
        
        UIView *gravView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, 180)];
        [gravView setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self addSubview:gravView];
        
        UIButton *privacyPolicyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [privacyPolicyButton setTag:0];
        [privacyPolicyButton addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [privacyPolicyButton setBackgroundColor:[UIColor whiteColor]];
        [privacyPolicyButton setTitle:@"Privacy Policy" forState:UIControlStateNormal];
        [privacyPolicyButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [privacyPolicyButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [privacyPolicyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [privacyPolicyButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [privacyPolicyButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gravView addSubview:privacyPolicyButton];
        
        UIButton *disclaimerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, privacyPolicyButton.frame.origin.y + privacyPolicyButton.frame.size.height + 1, frame.size.width, privacyPolicyButton.frame.size.height)];
        [disclaimerButton setTag:1];
        [disclaimerButton addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [disclaimerButton setBackgroundColor:[UIColor whiteColor]];
        [disclaimerButton setTitle:@"Disclaimer" forState:UIControlStateNormal];
        [disclaimerButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [disclaimerButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [disclaimerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [disclaimerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [disclaimerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gravView addSubview:disclaimerButton];
        
        UIButton *activityLogButton = [[UIButton alloc] initWithFrame:CGRectMake(0, disclaimerButton.frame.origin.y + disclaimerButton.frame.size.height + 1, frame.size.width, disclaimerButton.frame.size.height)];
        [activityLogButton setTag:2];
        [activityLogButton addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [activityLogButton setBackgroundColor:[UIColor whiteColor]];
        [activityLogButton setTitle:@"Activity Log" forState:UIControlStateNormal];
        [activityLogButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [activityLogButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [activityLogButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [activityLogButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [activityLogButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gravView addSubview:activityLogButton];
        
        UIButton *errorLogButton = [[UIButton alloc] initWithFrame:CGRectMake(0, activityLogButton.frame.origin.y + activityLogButton.frame.size.height + 1, frame.size.width, activityLogButton.frame.size.height)];
        [errorLogButton setTag:3];
        [errorLogButton addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [errorLogButton setBackgroundColor:[UIColor whiteColor]];
        [errorLogButton setTitle:@"Error Log" forState:UIControlStateNormal];
        [errorLogButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [errorLogButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [errorLogButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [errorLogButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [errorLogButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gravView addSubview:errorLogButton];
        
        UILabel *versionInfo = [[UILabel alloc] initWithFrame:CGRectMake(4, frame.size.height - 30, frame.size.width - 4, 30)];
        [versionInfo setTextAlignment:NSTextAlignmentLeft];
        [versionInfo setText:[NSString stringWithFormat:@"Epi Info v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
        [versionInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [versionInfo setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [self addSubview:versionInfo];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [privacyPolicyButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [disclaimerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [activityLogButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [errorLogButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [versionInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        }
    }
    return  self;
}

- (void)showContent:(UIButton *)sender
{
    PrivacyAndDisclaimerPresenter *padp = [[PrivacyAndDisclaimerPresenter alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) andTag:sender.tag];
    [self addSubview:padp];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [padp setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)goBack
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [[(EpiInfoViewController *)self.eivc mainMenuMenu] setEnabled:YES];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
