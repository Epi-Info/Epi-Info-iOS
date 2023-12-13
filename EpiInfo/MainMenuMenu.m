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
@import BoxContentSDK;

@implementation MainMenuMenu
@synthesize eivc = _eivc;
@synthesize customKeysOptionButton = _customKeysOptionButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        NSString *languageInUse = [[NSLocale preferredLanguages] firstObject];
        spanishLanguage = NO;
        if ([languageInUse isEqualToString:@"es"] || ([languageInUse length] > 2 && [[languageInUse substringToIndex:2] isEqualToString:@"es"]))
            spanishLanguage = YES;
        
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
        
        UIView *gravView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, 315)];
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
        
        NSArray *users = [BOXContentClient users];

        UIButton *boxLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, errorLogButton.frame.origin.y + errorLogButton.frame.size.height + 1, frame.size.width, errorLogButton.frame.size.height)];
        [boxLoginButton setTag:4];
        [boxLoginButton addTarget:self action:@selector(boxConnect:) forControlEvents:UIControlEventTouchUpInside];
        [boxLoginButton setBackgroundColor:[UIColor whiteColor]];
        [boxLoginButton setTitle:@"Connect to Box" forState:UIControlStateNormal];
        [boxLoginButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [boxLoginButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [boxLoginButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [boxLoginButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [boxLoginButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [boxLoginButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [boxLoginButton setEnabled:([users count] <= 0)];
        [gravView addSubview:boxLoginButton];
        
        UIButton *boxLogoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, boxLoginButton.frame.origin.y + boxLoginButton.frame.size.height + 1, frame.size.width, boxLoginButton.frame.size.height)];
        [boxLogoutButton setTag:5];
        [boxLogoutButton addTarget:self action:@selector(boxDisconnect:) forControlEvents:UIControlEventTouchUpInside];
        [boxLogoutButton setBackgroundColor:[UIColor whiteColor]];
        [boxLogoutButton setTitle:@"Disconnect from Box" forState:UIControlStateNormal];
        [boxLogoutButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [boxLogoutButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [boxLogoutButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [boxLogoutButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [boxLogoutButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [boxLogoutButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [boxLogoutButton setEnabled:([users count] > 0)];
        [gravView addSubview:boxLogoutButton];
        
        self.customKeysOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, boxLogoutButton.frame.origin.y + boxLogoutButton.frame.size.height + 1, frame.size.width, boxLogoutButton.frame.size.height)];
        [self.customKeysOptionButton setTag:6];
        [self.customKeysOptionButton addTarget:self action:@selector(toggleCustomKeysOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.customKeysOptionButton setBackgroundColor:[UIColor whiteColor]];
        [self.customKeysOptionButton setTitle:@"Give Option for Custom Encryption" forState:UIControlStateNormal];
        [self.customKeysOptionButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.customKeysOptionButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.customKeysOptionButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self.customKeysOptionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.customKeysOptionButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [self.customKeysOptionButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gravView addSubview:self.customKeysOptionButton];

        UILabel *versionInfo = [[UILabel alloc] initWithFrame:CGRectMake(4, frame.size.height - 30, frame.size.width - 4, 30)];
        [versionInfo setTextAlignment:NSTextAlignmentLeft];
        [versionInfo setText:[NSString stringWithFormat:@"Epi Info v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
        [versionInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [versionInfo setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [self addSubview:versionInfo];
        
        if (spanishLanguage)
        {
            [item setTitle:@"Información"];
            [back setAccessibilityLabel:@"Regresar al menú principal"];
            [privacyPolicyButton setTitle:@"Política de privacidad" forState:UIControlStateNormal];
            [disclaimerButton setTitle:@"Renuncia" forState:UIControlStateNormal];
            [activityLogButton setTitle:@"Registro de actividad" forState:UIControlStateNormal];
            [errorLogButton setTitle:@"Registro de errores" forState:UIControlStateNormal];
            [boxLoginButton setTitle:@"Conéctese a Box" forState:UIControlStateNormal];
            [boxLogoutButton setTitle:@"Desconectar de Box" forState:UIControlStateNormal];
            [self.customKeysOptionButton setTitle:@"Dar opción para el cifrado personalizado" forState:UIControlStateNormal];
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [privacyPolicyButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [disclaimerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [activityLogButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [errorLogButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [boxLoginButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [boxLogoutButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
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

- (void)boxConnect:(UIButton *)sender
{
    // This will present the necessary UI for a user to authenticate into Box
    [[BOXContentClient defaultClient] authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
        if (error == nil) {
            NSLog(@"Logged in user: %@", user.login);
            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Box logged in user: %@\n", [NSDate date], user.login]];
            [sender setEnabled:NO];
            [(UIButton *)[[sender superview] viewWithTag:5] setEnabled:YES];
        }
        else {
            NSLog(@"Error logging in to Box: %@", error);
            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: Error logging in to Box: %@\n", [NSDate date], error]];
        }
    }];
}

- (void)toggleCustomKeysOption:(UIButton *)sender
{
    BOOL ck = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"customKeys"] boolValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!ck] forKey:@"customKeys"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setEncryptionKeysButtonTitle:sender];
}
- (void)setEncryptionKeysButtonTitle:(UIButton *)sender
{
    BOOL ck = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"customKeys"] boolValue];
    if (ck)
    {
        [sender setTitle:@"Remove Option for Custom Encryption" forState:UIControlStateNormal];
        if (spanishLanguage)
        {
            [sender setTitle:@"Eliminar la opción de cifrado personalizado" forState:UIControlStateNormal];
        }
    }
    else
    {
        [sender setTitle:@"Give Option for Custom Encryption" forState:UIControlStateNormal];
        if (spanishLanguage)
        {
            [sender setTitle:@"Dar opción para el cifrado personalizado" forState:UIControlStateNormal];
        }
    }
}

- (void)boxDisconnect:(UIButton *)sender
{
    [[BOXContentClient defaultClient] logOut];
    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: Disconnected from Box\n", [NSDate date]]];
    [sender setEnabled:NO];
    [(UIButton *)[[sender superview] viewWithTag:4] setEnabled:YES];
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
