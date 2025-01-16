//
//  PrivacyAndDisclaimerPresenter.m
//  EpiInfo
//
//  Created by John Copeland on 4/21/17.
//

#import "PrivacyAndDisclaimerPresenter.h"
#include <sys/sysctl.h>

@implementation PrivacyAndDisclaimerPresenter
- (id)initWithFrame:(CGRect)frame andTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAccessibilityViewIsModal:YES];
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
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Privacy Policy"];
        if (tag == 1)
            [item setTitle:@"Disclaimer"];
        else if (tag == 2)
            [item setTitle:@"Activity Log"];
        else if (tag == 3)
            [item setTitle:@"Error Log"];
        [banner setItems:[NSArray arrayWithObject:item]];
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        [back setTitle:[NSString stringWithFormat:@"%@ Back", @"\U00002039"]];
        [back setAccessibilityLabel:@"Back to Information Menu"];
        [back setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [item setLeftBarButtonItem:back];
        
        if (tag == 2 || tag == 3)
        {
            UIBarButtonItem *manageLogFile = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(manageLogFile:)];
            [manageLogFile setAccessibilityLabel:@"Reset or email this log"];
            [manageLogFile setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageLogFile setTag:tag];
            [item setRightBarButtonItem:manageLogFile];
        }
        
        contentHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, frame.size.height - 32)];
        [contentHolder setBackgroundColor:[UIColor clearColor]];
//        [contentHolder setMinimumZoomScale:1.0];
//        [contentHolder setMaximumZoomScale:3.0];
        [self addSubview:contentHolder];
        
        content = [[UILabel alloc] init];
        [content setNumberOfLines:0];
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        [content setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [content setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        }
        [content setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [content setFrame:CGRectMake(8, 0, contentHolder.frame.size.width - 16, contentHolder.frame.size.height)];
        [content setTextAlignment:NSTextAlignmentLeft];
        [contentHolder addSubview:content];
        
        switch (tag) {
            case 0:
            {
//                [content setText:@"\nThis app is provided to assist in epidemiologic and other scientific investigations. It collects no information, personal or otherwise, about the user or the user's mobile device.\n\nFuture releases may collect device and usage information such as:\n\n\u2022 Information about your mobile device\n\u25e6 Type and model\n\u25e6 iOS version\n\u2022 The number of times the app was accessed\n\u2022 Screens accessed"];
                [content setText:@"\nThis app is provided to assist in epidemiologic and other scientific investigations. It collects no information, personal or otherwise, about the user or the user's mobile device."];
                [content sizeToFit];
                
                [content removeFromSuperview];
                
                float paragraphFontSize = 12.0;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    paragraphFontSize = 16.0;
                
                float contentSizeHeight = 0.0;
                UILabel *informationYouGiveUs = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, contentHolder.frame.size.width - 16.0, 40)];
                [informationYouGiveUs setNumberOfLines:0];
                [informationYouGiveUs setLineBreakMode:NSLineBreakByWordWrapping];
                [informationYouGiveUs setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [informationYouGiveUs setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [informationYouGiveUs setTextAlignment:NSTextAlignmentLeft];
                [informationYouGiveUs setText:@"Overview"];
                [informationYouGiveUs setAccessibilityTraits:UIAccessibilityTraitHeader];
                [contentHolder addSubview:informationYouGiveUs];
                contentSizeHeight += informationYouGiveUs.frame.size.height;
                
                UILabel *informationYouGiveUsBody = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, contentHolder.frame.size.width - 16.0, 300)];
                [informationYouGiveUsBody setNumberOfLines:0];
                [informationYouGiveUsBody setLineBreakMode:NSLineBreakByWordWrapping];
                [informationYouGiveUsBody setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [informationYouGiveUsBody setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [informationYouGiveUsBody setTextAlignment:NSTextAlignmentLeft];
                [informationYouGiveUsBody setText:@"Epi Info™ Companion mobile application collects data locally or to the cloud, calculates sample sizes, and performs analysis. Data collection forms can be designed using Epi Info™ for Windows and uploaded to or created directly in the mobile application. The mobile application is cloud-aware that allows for the data collected to be uploaded when Internet connectivity is available. Epi Info™ is developed and maintained by the Centers for Disease Control and Prevention, Center for Surveillance, Epidemiology & Laboratory Services (CSELS), Division of Health Informatics & Surveillance (DHIS). Epi Info™ Companion was developed to provide the global community of public health practitioners and researchers the ability to assist with outbreak investigations."];
                [informationYouGiveUsBody sizeToFit];
                [contentHolder addSubview:informationYouGiveUsBody];
                contentSizeHeight += informationYouGiveUsBody.frame.size.height;
                
                UILabel *visitsToCDCDotGov = [[UILabel alloc] initWithFrame:CGRectMake(8, informationYouGiveUsBody.frame.origin.y + informationYouGiveUsBody.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [visitsToCDCDotGov setNumberOfLines:0];
                [visitsToCDCDotGov setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGov setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGov setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGov setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGov setText:@"Visits to CDC.Gov:"];
                //[contentHolder addSubview:visitsToCDCDotGov];
                //contentSizeHeight += visitsToCDCDotGov.frame.size.height;
                
                UILabel *visitsToCDCDotGovIntro = [[UILabel alloc] initWithFrame:CGRectMake(8, visitsToCDCDotGov.frame.origin.y + visitsToCDCDotGov.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [visitsToCDCDotGovIntro setNumberOfLines:0];
                [visitsToCDCDotGovIntro setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovIntro setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovIntro setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovIntro setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovIntro setText:@"While using the CDC’s digital media, certain information will be gathered and stored about your usage of the digital media. This information does not identify you personally. We collect and store only the following information:\n"];
                [visitsToCDCDotGovIntro sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovIntro];
                //contentSizeHeight += visitsToCDCDotGovIntro.frame.size.height;
                
                UILabel *visitsToCDCDotGovBullet0 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovIntro.frame.origin.y + visitsToCDCDotGovIntro.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet0 setNumberOfLines:0];
                [visitsToCDCDotGovBullet0 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet0 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet0 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet0 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet0 setText:@"The Internet domain name (for example, “xcompany.com” if a private Internet access account is used, or “schoolname.edu” if connecting from a university's domain) and IP address (an IP address is a number that is automatically assigned to a device when surfing the web);"];
                [visitsToCDCDotGovBullet0 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet0];
                //contentSizeHeight += visitsToCDCDotGovBullet0.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletA = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet0.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletA setNumberOfLines:0];
                [visitsToCDCDotGovBulletA setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBulletA setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletA setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletA setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletA setText:@"\u2022"];
                [visitsToCDCDotGovBulletA sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletA];
               
                UILabel *visitsToCDCDotGovBullet1 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet0.frame.origin.y + visitsToCDCDotGovBullet0.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet1 setNumberOfLines:0];
                [visitsToCDCDotGovBullet1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet1 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet1 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet1 setText:@"Information about your computer or mobile device (e.g., type and version of web browser, operating system, screen resolution, and connection speed);"];
                [visitsToCDCDotGovBullet1 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet1];
                //contentSizeHeight += visitsToCDCDotGovBullet1.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletB = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet1.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletB setNumberOfLines:0];
                [visitsToCDCDotGovBulletB setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletB setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletB setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletB setText:@"\u2022"];
                [visitsToCDCDotGovBulletB sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletB];
                
                UILabel *visitsToCDCDotGovBullet2 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet1.frame.origin.y + visitsToCDCDotGovBullet1.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet2 setNumberOfLines:0];
                [visitsToCDCDotGovBullet2 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet2 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet2 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet2 setText:@"The number of times CDC’s digital media was accessed."];
                [visitsToCDCDotGovBullet2 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet2];
                //contentSizeHeight += visitsToCDCDotGovBullet2.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletC = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet2.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletC setNumberOfLines:0];
                [visitsToCDCDotGovBulletC setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletC setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletC setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletC setText:@"\u2022"];
                [visitsToCDCDotGovBulletC sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletC];
                
                UILabel *visitsToCDCDotGovBullet3 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet2.frame.origin.y + visitsToCDCDotGovBullet2.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet3 setNumberOfLines:0];
                [visitsToCDCDotGovBullet3 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet3 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet3 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet3 setText:@"The pages or screens accessed or visited on CDC’s digital media"];
                [visitsToCDCDotGovBullet3 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet3];
                //contentSizeHeight += visitsToCDCDotGovBullet3.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletD = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet3.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletD setNumberOfLines:0];
                [visitsToCDCDotGovBulletD setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletD setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletD setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletD setText:@"\u2022"];
                [visitsToCDCDotGovBulletD sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletD];
               
                UILabel *visitsToCDCDotGovBullet4 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet3.frame.origin.y + visitsToCDCDotGovBullet3.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet4 setNumberOfLines:0];
                [visitsToCDCDotGovBullet4 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet4 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet4 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet4 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet4 setText:@"The visit date and time;"];
                [visitsToCDCDotGovBullet4 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet4];
                //contentSizeHeight += visitsToCDCDotGovBullet4.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletE = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet4.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletE setNumberOfLines:0];
                [visitsToCDCDotGovBulletE setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletE setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletE setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletE setText:@"\u2022"];
                [visitsToCDCDotGovBulletE sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletE];
                
                UILabel *visitsToCDCDotGovBullet5 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet4.frame.origin.y + visitsToCDCDotGovBullet4.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet5 setNumberOfLines:0];
                [visitsToCDCDotGovBullet5 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet5 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet5 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet5 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet5 setText:@"If www.cdc.gov is designated as a home page (in the event your mobile device allows this functionality); and"];
                [visitsToCDCDotGovBullet5 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet5];
                //contentSizeHeight += visitsToCDCDotGovBullet5.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletF = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet5.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletF setNumberOfLines:0];
                [visitsToCDCDotGovBulletF setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletF setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletF setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletF setText:@"\u2022"];
                [visitsToCDCDotGovBulletF sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletF];
                
                UILabel *visitsToCDCDotGovBullet6 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet5.frame.origin.y + visitsToCDCDotGovBullet5.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet6 setNumberOfLines:0];
                [visitsToCDCDotGovBullet6 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet6 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet6 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet6 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet6 setText:@"The internet address or URL of the website visited immediately prior to visiting CDC’s digital media, if you connect to CDC.gov via a link from another web page."];
                [visitsToCDCDotGovBullet6 sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBullet6];
                //contentSizeHeight += visitsToCDCDotGovBullet6.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletG = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet6.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletG setNumberOfLines:0];
                [visitsToCDCDotGovBulletG setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletG setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletG setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletG setText:@"\u2022"];
                [visitsToCDCDotGovBulletG sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovBulletG];
                
                UILabel *visitsToCDCDotGovEnd = [[UILabel alloc] initWithFrame:CGRectMake(8, visitsToCDCDotGovBullet6.frame.origin.y + visitsToCDCDotGovBullet6.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [visitsToCDCDotGovEnd setNumberOfLines:0];
                [visitsToCDCDotGovEnd setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovEnd setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovEnd setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovEnd setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovEnd setText:@"\nCollection and analysis of this information in the aggregate will help us enhance performance of our digital media, improve informational materials available through digital media, and improve overall customer service"];
                [visitsToCDCDotGovEnd sizeToFit];
                //[contentHolder addSubview:visitsToCDCDotGovEnd];
                //contentSizeHeight += visitsToCDCDotGovEnd.frame.size.height;
                
                UILabel *useOfCookies = [[UILabel alloc] initWithFrame:CGRectMake(8, visitsToCDCDotGovEnd.frame.origin.y + visitsToCDCDotGovEnd.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [useOfCookies setNumberOfLines:0];
                [useOfCookies setLineBreakMode:NSLineBreakByWordWrapping];
                [useOfCookies setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [useOfCookies setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [useOfCookies setTextAlignment:NSTextAlignmentLeft];
                [useOfCookies setText:@"Use of Cookies"];
                //[contentHolder addSubview:useOfCookies];
                //contentSizeHeight += useOfCookies.frame.size.height;
                
                NSMutableAttributedString *useOfCookiesBodyString = [[NSMutableAttributedString alloc] initWithString:@"CDC also uses web measurements and customization technologies (such as “cookies”). You can choose not to accept cookies from any website, including cdc.gov, by changing your browser settings. Click here to learn more about how we use cookies." attributes:nil];
                useOfCookiesHyperlinkRange = [[useOfCookiesBodyString string] rangeOfString:@"Click here to learn more about how we use cookies"];
                NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
                [useOfCookiesBodyString setAttributes:linkAttributes range:useOfCookiesHyperlinkRange];
                
                UILabel *useOfCookiesBody = [[UILabel alloc] initWithFrame:CGRectMake(8, useOfCookies.frame.origin.y + useOfCookies.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [useOfCookiesBody setNumberOfLines:0];
                [useOfCookiesBody setLineBreakMode:NSLineBreakByWordWrapping];
                [useOfCookiesBody setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [useOfCookiesBody setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [useOfCookiesBody setTextAlignment:NSTextAlignmentLeft];
                [useOfCookiesBody setAttributedText:useOfCookiesBodyString];
                [useOfCookiesBody sizeToFit];
                //[contentHolder addSubview:useOfCookiesBody];
                //contentSizeHeight += useOfCookiesBody.frame.size.height;
                
                [useOfCookiesBody setTag:1001];
                [useOfCookiesBody setUserInteractionEnabled:YES];
                [useOfCookiesBody addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapsInLabelHyperlinks:)]];
                useOfCookiesLayoutManager = [[NSLayoutManager alloc] init];
                useOfCookiesTextContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
                useOfCookiesTextStorage = [[NSTextStorage alloc] initWithAttributedString:useOfCookiesBodyString];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    [useOfCookiesTextStorage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize] range:NSMakeRange(0, [useOfCookiesTextStorage length])];
                [useOfCookiesLayoutManager addTextContainer:useOfCookiesTextContainer];
                [useOfCookiesTextStorage addLayoutManager:useOfCookiesLayoutManager];
                [useOfCookiesTextContainer setLineFragmentPadding:0.0];
                [useOfCookiesTextContainer setLineBreakMode:[useOfCookiesBody lineBreakMode]];
                [useOfCookiesTextContainer setMaximumNumberOfLines:[useOfCookiesBody numberOfLines]];
                [useOfCookiesTextContainer setSize:useOfCookiesBody.frame.size];
                
                UILabel *usingMobileApplications = [[UILabel alloc] initWithFrame:CGRectMake(8, informationYouGiveUsBody.frame.origin.y + informationYouGiveUsBody.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [usingMobileApplications setNumberOfLines:0];
                [usingMobileApplications setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplications setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [usingMobileApplications setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplications setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplications setText:@"Information Collected"];
                [usingMobileApplications setAccessibilityTraits:UIAccessibilityTraitHeader];
                [contentHolder addSubview:usingMobileApplications];
                contentSizeHeight += usingMobileApplications.frame.size.height;
                
                UILabel *usingMobileApplicationsIntro = [[UILabel alloc] initWithFrame:CGRectMake(8, usingMobileApplications.frame.origin.y + usingMobileApplications.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [usingMobileApplicationsIntro setNumberOfLines:0];
                [usingMobileApplicationsIntro setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsIntro setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [usingMobileApplicationsIntro setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsIntro setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsIntro setText:@"CDC does not have access to any of the data that is entered into the mobile application or users of the mobile application's information. All Data collected by the mobile application is either stored locally on the device or sent to a repository via a connection that is established by that user. This mobile application does not access any other mobile application, program, or service on the user’s device. This mobile application does not transmit or share information that is collected by the mobile application to a government server.\n"];
                [usingMobileApplicationsIntro sizeToFit];
                [contentHolder addSubview:usingMobileApplicationsIntro];
                contentSizeHeight += usingMobileApplicationsIntro.frame.size.height;
                
                NSMutableAttributedString *usingMobileApplicationsBullet0String = [[NSMutableAttributedString alloc] initWithString:@"This mobile application does not collect any information to identify you personally. CDC receives aggregate data about the download of the mobile application and mobile set-up information (e.g., device model, mobile application version, country, language, and mobile carrier). This information is gathered via the platforms that distribute the Apps (currently the iTunes Store, Google Play Store, and the Windows Store). Please consult the privacy policies of these third parties for further information.\n(CDC’s List of Third-Party Tools and Sites)\n" attributes:nil];
                usingMobileApplicationsBullet0HyperlinkRange = [[usingMobileApplicationsBullet0String string] rangeOfString:@"CDC’s List of Third-Party Tools and Sites"];
                NSDictionary *bullet0LinkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
                [usingMobileApplicationsBullet0String setAttributes:bullet0LinkAttributes range:usingMobileApplicationsBullet0HyperlinkRange];
                UILabel *usingMobileApplicationsBullet0 = [[UILabel alloc] initWithFrame:CGRectMake(8, usingMobileApplicationsIntro.frame.origin.y + usingMobileApplicationsIntro.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [usingMobileApplicationsBullet0 setNumberOfLines:0];
                [usingMobileApplicationsBullet0 setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsBullet0 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [usingMobileApplicationsBullet0 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsBullet0 setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsBullet0 setAttributedText:usingMobileApplicationsBullet0String];
                [usingMobileApplicationsBullet0 sizeToFit];
                [contentHolder addSubview:usingMobileApplicationsBullet0];
                contentSizeHeight += usingMobileApplicationsBullet0.frame.size.height;
                [usingMobileApplicationsBullet0 setTag:1002];
                [usingMobileApplicationsBullet0 setUserInteractionEnabled:YES];
                [usingMobileApplicationsBullet0 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapsInLabelHyperlinks:)]];
                usingMobileApplicationsBullet0LayoutManager = [[NSLayoutManager alloc] init];
                usingMobileApplicationsBullet0TextContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
                usingMobileApplicationsBullet0TextStorage = [[NSTextStorage alloc] initWithAttributedString:usingMobileApplicationsBullet0String];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    [usingMobileApplicationsBullet0TextStorage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize] range:NSMakeRange(0, [usingMobileApplicationsBullet0TextStorage length])];
                [usingMobileApplicationsBullet0LayoutManager addTextContainer:usingMobileApplicationsBullet0TextContainer];
                [usingMobileApplicationsBullet0TextStorage addLayoutManager:usingMobileApplicationsBullet0LayoutManager];
                [usingMobileApplicationsBullet0TextContainer setLineFragmentPadding:0.0];
                [usingMobileApplicationsBullet0TextContainer setLineBreakMode:[usingMobileApplicationsBullet0 lineBreakMode]];
                [usingMobileApplicationsBullet0TextContainer setMaximumNumberOfLines:[usingMobileApplicationsBullet0 numberOfLines]];
                [usingMobileApplicationsBullet0TextContainer setSize:usingMobileApplicationsBullet0.frame.size];
                
                UILabel *usingMobileApplicationsBulletA = [[UILabel alloc] initWithFrame:CGRectMake(38, usingMobileApplicationsBullet0.frame.origin.y - 4, 10, 10)];
                [usingMobileApplicationsBulletA setNumberOfLines:0];
                [usingMobileApplicationsBulletA setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsBulletA setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [usingMobileApplicationsBulletA setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsBulletA setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsBulletA setText:@"\u2022"];
                [usingMobileApplicationsBulletA sizeToFit];
                //[contentHolder addSubview:usingMobileApplicationsBulletA];
                
                UILabel *usesOfInformation = [[UILabel alloc] initWithFrame:CGRectMake(8, usingMobileApplicationsBullet0.frame.origin.y + usingMobileApplicationsBullet0.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [usesOfInformation setNumberOfLines:0];
                [usesOfInformation setLineBreakMode:NSLineBreakByWordWrapping];
                [usesOfInformation setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [usesOfInformation setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usesOfInformation setTextAlignment:NSTextAlignmentLeft];
                [usesOfInformation setText:@"Uses of Information"];
                [informationYouGiveUs setAccessibilityTraits:UIAccessibilityTraitHeader];
                [contentHolder addSubview:usesOfInformation];
                contentSizeHeight += usesOfInformation.frame.size.height;
                
                UILabel *usesOfInformationText = [[UILabel alloc] initWithFrame:CGRectMake(8, usesOfInformation.frame.origin.y + usesOfInformation.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [usesOfInformationText setNumberOfLines:0];
                [usesOfInformationText setLineBreakMode:NSLineBreakByWordWrapping];
                [usesOfInformationText setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [usesOfInformationText setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usesOfInformationText setTextAlignment:NSTextAlignmentLeft];
                [usesOfInformationText setText:@"CDC does not collect any of the data or user information that is entered into the mobile application. All Data collected by the mobile application is either stored locally on the user's personal device or sent to a repository via a connection that is established by that user and only that has access to that connection.\n"];
                [usesOfInformationText sizeToFit];
                [contentHolder addSubview:usesOfInformationText];
                contentSizeHeight += usesOfInformationText.frame.size.height;
                
                UILabel *informationSharing = [[UILabel alloc] initWithFrame:CGRectMake(8, usesOfInformationText.frame.origin.y + usesOfInformationText.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [informationSharing setNumberOfLines:0];
                [informationSharing setLineBreakMode:NSLineBreakByWordWrapping];
                [informationSharing setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [informationSharing setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [informationSharing setTextAlignment:NSTextAlignmentLeft];
                [informationSharing setText:@"Information Sharing"];
                [informationSharing setAccessibilityTraits:UIAccessibilityTraitHeader];
                [contentHolder addSubview:informationSharing];
                contentSizeHeight += informationSharing.frame.size.height;
                
                UILabel *informationSharingText = [[UILabel alloc] initWithFrame:CGRectMake(8, informationSharing.frame.origin.y + informationSharing.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [informationSharingText setNumberOfLines:0];
                [informationSharingText setLineBreakMode:NSLineBreakByWordWrapping];
                [informationSharingText setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [informationSharingText setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [informationSharingText setTextAlignment:NSTextAlignmentLeft];
                [informationSharingText setText:@"CDC does not disclose, share, sell, or transfer any information about CDC digital media visitors or users unless required for law enforcement or otherwise required by law.\n"];
                [informationSharingText sizeToFit];
                [contentHolder addSubview:informationSharingText];
                contentSizeHeight += informationSharingText.frame.size.height;
                
                UILabel *applicationSecurity = [[UILabel alloc] initWithFrame:CGRectMake(8, informationSharingText.frame.origin.y + informationSharingText.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [applicationSecurity setNumberOfLines:0];
                [applicationSecurity setLineBreakMode:NSLineBreakByWordWrapping];
                [applicationSecurity setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [applicationSecurity setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [applicationSecurity setTextAlignment:NSTextAlignmentLeft];
                [applicationSecurity setText:@"Application Security"];
                [applicationSecurity setAccessibilityTraits:UIAccessibilityTraitHeader];
                [contentHolder addSubview:applicationSecurity];
                contentSizeHeight += applicationSecurity.frame.size.height;
                
                UILabel *applicationSecurityText = [[UILabel alloc] initWithFrame:CGRectMake(8, applicationSecurity.frame.origin.y + applicationSecurity.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [applicationSecurityText setNumberOfLines:0];
                [applicationSecurityText setLineBreakMode:NSLineBreakByWordWrapping];
                [applicationSecurityText setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [applicationSecurityText setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [applicationSecurityText setTextAlignment:NSTextAlignmentLeft];
                [applicationSecurityText setText:@"All data entered into the mobile application is either stored locally on the user's personal device or transmitted via a connection established by the user and only that user has access to that connection.\n\nFor security purposes and to ensure that this service remains available to all users, the CDC employs software programs to identify unauthorized attempts to upload or change the mobile application, or otherwise cause damage.\n\nAll of the CDC’s digital media are maintained by the U.S. Government and are protected by various provisions of Title 18, U.S. Code. Violations of Title 18 are subject to criminal prosecution in Federal court.\n"];
                [applicationSecurityText sizeToFit];
                [contentHolder addSubview:applicationSecurityText];
                contentSizeHeight += applicationSecurityText.frame.size.height;
                
                UILabel *howToAccessOrCorrectYourInformation = [[UILabel alloc] initWithFrame:CGRectMake(8, applicationSecurityText.frame.origin.y + applicationSecurityText.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [howToAccessOrCorrectYourInformation setNumberOfLines:0];
                [howToAccessOrCorrectYourInformation setLineBreakMode:NSLineBreakByWordWrapping];
                [howToAccessOrCorrectYourInformation setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [howToAccessOrCorrectYourInformation setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [howToAccessOrCorrectYourInformation setTextAlignment:NSTextAlignmentLeft];
                [howToAccessOrCorrectYourInformation setText:@"How to Access or Correct Your Information"];
                [contentHolder addSubview:howToAccessOrCorrectYourInformation];
                contentSizeHeight += howToAccessOrCorrectYourInformation.frame.size.height;
                
                NSMutableAttributedString *usingMobileApplicationsBullet1String = [[NSMutableAttributedString alloc] initWithString:@"Users of this mobile application who seek to redress which may include access to records about themselves, ensuring the accuracy of the information collected, and or filing complaints will need to contact the Epi Info™ help desk." attributes:nil];
                usingMobileApplicationsBullet1HyperlinkRange0 = [[usingMobileApplicationsBullet1String string] rangeOfString:@"Epi Info™ help desk"];
                NSDictionary *bullet1LinkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
                [usingMobileApplicationsBullet1String setAttributes:bullet1LinkAttributes range:usingMobileApplicationsBullet1HyperlinkRange0];
                UILabel *usingMobileApplicationsBullet1 = [[UILabel alloc] initWithFrame:CGRectMake(8, howToAccessOrCorrectYourInformation.frame.origin.y + howToAccessOrCorrectYourInformation.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [usingMobileApplicationsBullet1 setNumberOfLines:0];
                [usingMobileApplicationsBullet1 setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsBullet1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [usingMobileApplicationsBullet1 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsBullet1 setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsBullet1 setAttributedText:usingMobileApplicationsBullet1String];
                [usingMobileApplicationsBullet1 sizeToFit];
                [contentHolder addSubview:usingMobileApplicationsBullet1];
                contentSizeHeight += usingMobileApplicationsBullet1.frame.size.height;
                [usingMobileApplicationsBullet1 setTag:1003];
                [usingMobileApplicationsBullet1 setUserInteractionEnabled:YES];
                [usingMobileApplicationsBullet1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapsInLabelHyperlinks:)]];
                usingMobileApplicationsBullet1LayoutManager = [[NSLayoutManager alloc] init];
                usingMobileApplicationsBullet1TextContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
                usingMobileApplicationsBullet1TextStorage = [[NSTextStorage alloc] initWithAttributedString:usingMobileApplicationsBullet1String];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    [usingMobileApplicationsBullet1TextStorage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize] range:NSMakeRange(0, [usingMobileApplicationsBullet1TextStorage length])];
                [usingMobileApplicationsBullet1LayoutManager addTextContainer:usingMobileApplicationsBullet1TextContainer];
                [usingMobileApplicationsBullet1TextStorage addLayoutManager:usingMobileApplicationsBullet1LayoutManager];
                [usingMobileApplicationsBullet1TextContainer setLineFragmentPadding:0.0];
                [usingMobileApplicationsBullet1TextContainer setLineBreakMode:[usingMobileApplicationsBullet0 lineBreakMode]];
                [usingMobileApplicationsBullet1TextContainer setMaximumNumberOfLines:[usingMobileApplicationsBullet0 numberOfLines]];
                [usingMobileApplicationsBullet1TextContainer setSize:usingMobileApplicationsBullet0.frame.size];
                
                UILabel *analyticsTools = [[UILabel alloc] initWithFrame:CGRectMake(8, usingMobileApplicationsBullet1.frame.origin.y + usingMobileApplicationsBullet1.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [analyticsTools setNumberOfLines:0];
                [analyticsTools setLineBreakMode:NSLineBreakByWordWrapping];
                [analyticsTools setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [analyticsTools setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [analyticsTools setTextAlignment:NSTextAlignmentLeft];
                [analyticsTools setText:@"Analytics Tools"];
                [contentHolder addSubview:analyticsTools];
                contentSizeHeight += analyticsTools.frame.size.height;
                
                NSMutableAttributedString *analyticsToolsString = [[NSMutableAttributedString alloc] initWithString:@"This mobile application relies on the platforms that distribute the mobile application (currently the iTunes Store, Google Play Store, and the Windows Store) to provide analytics about the download of the mobile application. Please consult the privacy policies of these third parties for further information.\n(CDC’s List of Third-Party Tools and Sites)\n" attributes:nil];
                analyticsToolsHyperlinkRange = [[analyticsToolsString string] rangeOfString:@"CDC’s List of Third-Party Tools and Sites"];
                NSDictionary *analyticsToolsLinkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0], NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
                [analyticsToolsString setAttributes:analyticsToolsLinkAttributes range:analyticsToolsHyperlinkRange];
                UILabel *analyticsToolsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, analyticsTools.frame.origin.y + analyticsTools.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [analyticsToolsLabel setNumberOfLines:0];
                [analyticsToolsLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [analyticsToolsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [analyticsToolsLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [analyticsToolsLabel setTextAlignment:NSTextAlignmentLeft];
                [analyticsToolsLabel setAttributedText:analyticsToolsString];
                [analyticsToolsLabel sizeToFit];
                [contentHolder addSubview:analyticsToolsLabel];
                contentSizeHeight += analyticsToolsLabel.frame.size.height;
                [analyticsToolsLabel setTag:1042];
                [analyticsToolsLabel setUserInteractionEnabled:YES];
                [analyticsToolsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapsInLabelHyperlinks:)]];
                analyticsToolsLayoutManager = [[NSLayoutManager alloc] init];
                analyticsToolsTextContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
                analyticsToolsTextStorage = [[NSTextStorage alloc] initWithAttributedString:analyticsToolsString];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    [analyticsToolsTextStorage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize] range:NSMakeRange(0, [analyticsToolsTextStorage length])];
                [analyticsToolsLayoutManager addTextContainer:analyticsToolsTextContainer];
                [analyticsToolsTextStorage addLayoutManager:analyticsToolsLayoutManager];
                [analyticsToolsTextContainer setLineFragmentPadding:0.0];
                [analyticsToolsTextContainer setLineBreakMode:[analyticsToolsLabel lineBreakMode]];
                [analyticsToolsTextContainer setMaximumNumberOfLines:[analyticsToolsLabel numberOfLines]];
                [analyticsToolsTextContainer setSize:analyticsToolsLabel.frame.size];
                
                UILabel *privacyPolicyContactInformation = [[UILabel alloc] initWithFrame:CGRectMake(8, analyticsToolsLabel.frame.origin.y + analyticsToolsLabel.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [privacyPolicyContactInformation setNumberOfLines:0];
                [privacyPolicyContactInformation setLineBreakMode:NSLineBreakByWordWrapping];
                [privacyPolicyContactInformation setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [privacyPolicyContactInformation setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [privacyPolicyContactInformation setTextAlignment:NSTextAlignmentLeft];
                [privacyPolicyContactInformation setText:@"Privacy Policy Contact Information"];
                [privacyPolicyContactInformation setAccessibilityTraits:UIAccessibilityTraitHeader];
                [contentHolder addSubview:privacyPolicyContactInformation];
                contentSizeHeight += privacyPolicyContactInformation.frame.size.height;
                
                UILabel *privacyPolicyContactInformationText = [[UILabel alloc] initWithFrame:CGRectMake(8, privacyPolicyContactInformation.frame.origin.y + privacyPolicyContactInformation.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [privacyPolicyContactInformationText setNumberOfLines:0];
                [privacyPolicyContactInformationText setLineBreakMode:NSLineBreakByWordWrapping];
                [privacyPolicyContactInformationText setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [privacyPolicyContactInformationText setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [privacyPolicyContactInformationText setTextAlignment:NSTextAlignmentLeft];
                [privacyPolicyContactInformationText setText:@"If you have questions or concerns related to this CDC Mobile Application Privacy Policy or need further information, please contact the CDC Privacy Office at Privacy@cdc.gov or call 770-488-8660\n"];
                [privacyPolicyContactInformationText sizeToFit];
                [contentHolder addSubview:privacyPolicyContactInformationText];
                contentSizeHeight += privacyPolicyContactInformationText.frame.size.height;
                
                [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, contentSizeHeight)];
            }
                break;
                
            case 1:
            {
                [content setText:@"\nTHE MATERIALS EMBODIED IN THIS SOFTWARE ARE PROVIDED TO YOU \"AS-IS\" AND WITHOUT WARRANTY OF ANY KIND, EXPRESSED, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE CENTERS FOR DISEASE CONTROL AND PREVENTION (CDC) OR THE UNITED STATES (U.S.) GOVERNMENT BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT, SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION, LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF THIRD PARTIES, WHETHER OR NOT CDC OR THE U.S. GOVERNMENT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.\n\nCDC is not responsible for confidentiality or any information shared by the owner or user of the device that runs the Epi Info™ Mobile Application with other parties. CDC is not responsible for information shared with third parties through loss or theft of the device.\n\nThis application is used for data collection and is not intended to provide medical advice or diagnoses. Any questions regarding personal medical information should be directed to a primary care physician.\n\nUse of trade names, commercial sources or private organizations is for identification only and does not imply endorsement by the U.S. Department of Health and Human Services and/or CDC."];
                [content sizeToFit];
            }
                break;
                
            case 2:
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"]])
                {
                    [content setText:@"Activity Log not found."];
                }
                else
                {
                    NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Activity_Log.txt"];
                    [content setText:[NSString stringWithContentsOfFile:activityLogFile encoding:NSUTF8StringEncoding error:nil]];
                }
                [content sizeToFit];
            }
                break;
                
            case 3:
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"]])
                {
                    [content setText:@"Error Log not found."];
                }
                else
                {
                    NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Error_Log.txt"];
                    [content setText:[NSString stringWithContentsOfFile:activityLogFile encoding:NSUTF8StringEncoding error:nil]];
                }
                [content sizeToFit];
            }
                break;
                
            default:
                break;
        }
        
        [contentHolder setContentSize:CGSizeMake(contentHolder.frame.size.width, content.frame.size.height + 4)];
}
    
    return self;
}

- (void)goBack
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)manageLogFile:(id)sender
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Activity Log Management" message:@"What do you want to do with the Activity Log?" preferredStyle:UIAlertControllerStyleAlert];
    if ([sender tag] == 3)
    {
        [alertC setTitle:@"Error Log Management"];
        [alertC setMessage:@"What do you want to do with the Error Log?"];
    }
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"Clear It" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self confirmClearLogFile:[sender tag]];
    }];
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"Email It" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self emailLogFile:[sender tag]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alertC addAction:clearAction];
    [alertC addAction:emailAction];
    [alertC addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}
- (void)confirmClearLogFile:(NSUInteger)senderTag
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to clear the Activity Log?" preferredStyle:UIAlertControllerStyleAlert];
    if (senderTag == 3)
    {
        [alertC setMessage:@"Are you sure you want to clear the Error Log?"];
    }
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self doClearLogFile:senderTag];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alertC addAction:yesAction];
    [alertC addAction:noAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}
- (void)doClearLogFile:(NSUInteger)senderTag
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (senderTag == 3)
    {
        [EpiInfoLogManager resetErrorLog];
        NSString *errorLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Error_Log.txt"];
        [content setText:[NSString stringWithContentsOfFile:errorLogFile encoding:NSUTF8StringEncoding error:nil]];
        [content sizeToFit];
    }
    else if (senderTag == 2)
    {
        [EpiInfoLogManager resetActivityLog];
        NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Activity_Log.txt"];
        [content setText:[NSString stringWithContentsOfFile:activityLogFile encoding:NSUTF8StringEncoding error:nil]];
        [content sizeToFit];
    }
}
- (void)emailLogFile:(NSUInteger)senderTag
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *errorLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Error_Log.txt"];
    NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Activity_Log.txt"];
    

    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];

    if (senderTag == 2)
        [composer addAttachmentData:[NSData dataWithContentsOfFile:activityLogFile] mimeType:@"text/plain" fileName:@"Activity_Log.txt"];
    else if (senderTag == 3)
        [composer addAttachmentData:[NSData dataWithContentsOfFile:errorLogFile] mimeType:@"text/plain" fileName:@"Error_Log.txt"];

    [composer setSubject:@"Epi Info Log"];
    [composer setMessageBody:@"Here is the requested log from the Epi Info iOS app." isHTML:NO];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composer animated:YES completion:^(void){

    }];
    //            free(buffer);
    return;
}

// <MFMailComposeViewControllerDelegate> delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
        {
            //            NSLog(@"Result: sent");
            NSThread *nst = [[NSThread alloc] initWithTarget:self selector:@selector(confirmLogFileEmailed) object:nil];
            [nst start];
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)confirmLogFileEmailed
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Log Sent" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alertC addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

- (void)handleTapsInLabelHyperlinks:(UITapGestureRecognizer *)tapGesture
{
    switch ([[tapGesture view] tag]) {
        case 1001:
        {
            CGPoint locationOfTouchInLabel = [tapGesture locationInView:[tapGesture view]];
            CGSize labelSize = tapGesture.view.bounds.size;
            CGRect textBoundingBox = [useOfCookiesLayoutManager usedRectForTextContainer:useOfCookiesTextContainer];
            CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.0 - textBoundingBox.origin.x,
                                                      (labelSize.height - textBoundingBox.size.height) * 0.0 - textBoundingBox.origin.y);
            CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                                 locationOfTouchInLabel.y - textContainerOffset.y);
            NSInteger indexOfCharacter = [useOfCookiesLayoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                                           inTextContainer:useOfCookiesTextContainer
                                                  fractionOfDistanceBetweenInsertionPoints:nil];
            NSRange linkRange = useOfCookiesHyperlinkRange;
            if (NSLocationInRange(indexOfCharacter, linkRange)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cdc.gov/other/privacy.html#cookies"]];
            }
        }
            break;
            
        case 1002:
        {
            CGPoint locationOfTouchInLabel = [tapGesture locationInView:[tapGesture view]];
            CGSize labelSize = tapGesture.view.bounds.size;
            CGRect textBoundingBox = [usingMobileApplicationsBullet0LayoutManager usedRectForTextContainer:usingMobileApplicationsBullet0TextContainer];
            CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.0 - textBoundingBox.origin.x,
                                                      (labelSize.height - textBoundingBox.size.height) * 0.0 - textBoundingBox.origin.y);
            CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                                 locationOfTouchInLabel.y - textContainerOffset.y);
            NSInteger indexOfCharacter = [usingMobileApplicationsBullet0LayoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                                           inTextContainer:usingMobileApplicationsBullet0TextContainer
                                                  fractionOfDistanceBetweenInsertionPoints:nil];
            NSRange linkRange = usingMobileApplicationsBullet0HyperlinkRange;
            if (NSLocationInRange(indexOfCharacter, linkRange)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cdc.gov/other/third-party-pages.html"]];
            }
        }
            break;
            
        case 1042:
        {
            CGPoint locationOfTouchInLabel = [tapGesture locationInView:[tapGesture view]];
            CGSize labelSize = tapGesture.view.bounds.size;
            CGRect textBoundingBox = [usingMobileApplicationsBullet0LayoutManager usedRectForTextContainer:usingMobileApplicationsBullet0TextContainer];
            CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.0 - textBoundingBox.origin.x,
                                                      (labelSize.height - textBoundingBox.size.height) * 0.0 - textBoundingBox.origin.y);
            CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                                 locationOfTouchInLabel.y - textContainerOffset.y);
            NSInteger indexOfCharacter = [usingMobileApplicationsBullet0LayoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                                           inTextContainer:usingMobileApplicationsBullet0TextContainer
                                                  fractionOfDistanceBetweenInsertionPoints:nil];
            NSRange linkRange = analyticsToolsHyperlinkRange;
            if (NSLocationInRange(indexOfCharacter, linkRange)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cdc.gov/other/third-party-pages.html"]];
            }
        }
            break;
            
        case 1003:
        {
            CGPoint locationOfTouchInLabel = [tapGesture locationInView:[tapGesture view]];
            CGSize labelSize = tapGesture.view.bounds.size;
            CGRect textBoundingBox = [usingMobileApplicationsBullet1LayoutManager usedRectForTextContainer:usingMobileApplicationsBullet1TextContainer];
            CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.0 - textBoundingBox.origin.x,
                                                      (labelSize.height - textBoundingBox.size.height) * 0.0 - textBoundingBox.origin.y);
            CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                                 locationOfTouchInLabel.y - textContainerOffset.y);
            NSInteger indexOfCharacter = [usingMobileApplicationsBullet1LayoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                                                             inTextContainer:usingMobileApplicationsBullet1TextContainer
                                                                    fractionOfDistanceBetweenInsertionPoints:nil];
            if (NSLocationInRange(indexOfCharacter, usingMobileApplicationsBullet1HyperlinkRange0)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cdc.gov/epiinfo/support/helpdesk.html"]];
            }
        }
            break;
            
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
