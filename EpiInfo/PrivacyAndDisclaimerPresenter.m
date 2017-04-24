//
//  PrivacyAndDisclaimerPresenter.m
//  EpiInfo
//
//  Created by John Copeland on 4/21/17.
//  Copyright © 2017 John Copeland. All rights reserved.
//

#import "PrivacyAndDisclaimerPresenter.h"

@implementation PrivacyAndDisclaimerPresenter
- (id)initWithFrame:(CGRect)frame andTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *bannerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [bannerBack setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [self addSubview:bannerBack];
        
        UINavigationBar *banner = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 4, frame.size.width, 32)];
        [banner setBackgroundColor:[UIColor clearColor]];
        [banner setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [banner setShadowImage:[UIImage new]];
        [self addSubview:banner];
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Privacy Policy"];
        if (tag == 1)
            [item setTitle:@"Disclaimer"];
        [banner setItems:[NSArray arrayWithObject:item]];
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        [back setTitle:[NSString stringWithFormat:@"%@ Back", @"\U00002039"]];
        [back setAccessibilityLabel:@"Back to Information Menu"];
        [back setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [item setLeftBarButtonItem:back];
        
        contentHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, frame.size.height - 32)];
        [contentHolder setBackgroundColor:[UIColor clearColor]];
//        [contentHolder setMinimumZoomScale:1.0];
//        [contentHolder setMaximumZoomScale:3.0];
        [self addSubview:contentHolder];
        
        UILabel *content = [[UILabel alloc] init];
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
                [informationYouGiveUs setText:@"Information You Give Us"];
                [contentHolder addSubview:informationYouGiveUs];
                contentSizeHeight += informationYouGiveUs.frame.size.height;
                
                UILabel *informationYouGiveUsBody = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, contentHolder.frame.size.width - 16.0, 300)];
                [informationYouGiveUsBody setNumberOfLines:0];
                [informationYouGiveUsBody setLineBreakMode:NSLineBreakByWordWrapping];
                [informationYouGiveUsBody setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [informationYouGiveUsBody setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [informationYouGiveUsBody setTextAlignment:NSTextAlignmentLeft];
                [informationYouGiveUsBody setText:@"CDC does not collect any personal information when you use CDC’s digital media from your computer or mobile device unless you choose to provide that information. The CDC privacy policy is as follows:"];
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
                [contentHolder addSubview:visitsToCDCDotGov];
                contentSizeHeight += visitsToCDCDotGov.frame.size.height;
                
                UILabel *visitsToCDCDotGovIntro = [[UILabel alloc] initWithFrame:CGRectMake(8, visitsToCDCDotGov.frame.origin.y + visitsToCDCDotGov.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [visitsToCDCDotGovIntro setNumberOfLines:0];
                [visitsToCDCDotGovIntro setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovIntro setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovIntro setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovIntro setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovIntro setText:@"While using the CDC’s digital media, certain information will be gathered and stored about your usage of the digital media. This information does not identify you personally. We collect and store only the following information:\n"];
                [visitsToCDCDotGovIntro sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovIntro];
                contentSizeHeight += visitsToCDCDotGovIntro.frame.size.height;
                
                UILabel *visitsToCDCDotGovBullet0 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovIntro.frame.origin.y + visitsToCDCDotGovIntro.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet0 setNumberOfLines:0];
                [visitsToCDCDotGovBullet0 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet0 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet0 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet0 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet0 setText:@"The Internet domain name (for example, “xcompany.com” if a private Internet access account is used, or “schoolname.edu” if connecting from a university's domain) and IP address (an IP address is a number that is automatically assigned to a device when surfing the web);"];
                [visitsToCDCDotGovBullet0 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet0];
                contentSizeHeight += visitsToCDCDotGovBullet0.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletA = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet0.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletA setNumberOfLines:0];
                [visitsToCDCDotGovBulletA setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBulletA setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletA setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletA setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletA setText:@"\u2022"];
                [visitsToCDCDotGovBulletA sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletA];
               
                UILabel *visitsToCDCDotGovBullet1 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet0.frame.origin.y + visitsToCDCDotGovBullet0.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet1 setNumberOfLines:0];
                [visitsToCDCDotGovBullet1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet1 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet1 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet1 setText:@"Information about your computer or mobile device (e.g., type and version of web browser, operating system, screen resolution, and connection speed);"];
                [visitsToCDCDotGovBullet1 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet1];
                contentSizeHeight += visitsToCDCDotGovBullet1.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletB = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet1.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletB setNumberOfLines:0];
                [visitsToCDCDotGovBulletB setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletB setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletB setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletB setText:@"\u2022"];
                [visitsToCDCDotGovBulletB sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletB];
                
                UILabel *visitsToCDCDotGovBullet2 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet1.frame.origin.y + visitsToCDCDotGovBullet1.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet2 setNumberOfLines:0];
                [visitsToCDCDotGovBullet2 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet2 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet2 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet2 setText:@"The number of times CDC’s digital media was accessed."];
                [visitsToCDCDotGovBullet2 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet2];
                contentSizeHeight += visitsToCDCDotGovBullet2.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletC = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet2.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletC setNumberOfLines:0];
                [visitsToCDCDotGovBulletC setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletC setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletC setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletC setText:@"\u2022"];
                [visitsToCDCDotGovBulletC sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletC];
                
                UILabel *visitsToCDCDotGovBullet3 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet2.frame.origin.y + visitsToCDCDotGovBullet2.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet3 setNumberOfLines:0];
                [visitsToCDCDotGovBullet3 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet3 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet3 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet3 setText:@"The pages or screens accessed or visited on CDC’s digital media"];
                [visitsToCDCDotGovBullet3 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet3];
                contentSizeHeight += visitsToCDCDotGovBullet3.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletD = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet3.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletD setNumberOfLines:0];
                [visitsToCDCDotGovBulletD setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletD setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletD setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletD setText:@"\u2022"];
                [visitsToCDCDotGovBulletD sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletD];
               
                UILabel *visitsToCDCDotGovBullet4 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet3.frame.origin.y + visitsToCDCDotGovBullet3.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet4 setNumberOfLines:0];
                [visitsToCDCDotGovBullet4 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet4 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet4 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet4 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet4 setText:@"The visit date and time;"];
                [visitsToCDCDotGovBullet4 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet4];
                contentSizeHeight += visitsToCDCDotGovBullet4.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletE = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet4.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletE setNumberOfLines:0];
                [visitsToCDCDotGovBulletE setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletE setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletE setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletE setText:@"\u2022"];
                [visitsToCDCDotGovBulletE sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletE];
                
                UILabel *visitsToCDCDotGovBullet5 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet4.frame.origin.y + visitsToCDCDotGovBullet4.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet5 setNumberOfLines:0];
                [visitsToCDCDotGovBullet5 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet5 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet5 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet5 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet5 setText:@"If www.cdc.gov is designated as a home page (in the event your mobile device allows this functionality); and"];
                [visitsToCDCDotGovBullet5 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet5];
                contentSizeHeight += visitsToCDCDotGovBullet5.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletF = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet5.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletF setNumberOfLines:0];
                [visitsToCDCDotGovBulletF setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletF setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletF setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletF setText:@"\u2022"];
                [visitsToCDCDotGovBulletF sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletF];
                
                UILabel *visitsToCDCDotGovBullet6 = [[UILabel alloc] initWithFrame:CGRectMake(50, visitsToCDCDotGovBullet5.frame.origin.y + visitsToCDCDotGovBullet5.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
                [visitsToCDCDotGovBullet6 setNumberOfLines:0];
                [visitsToCDCDotGovBullet6 setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovBullet6 setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovBullet6 setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBullet6 setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBullet6 setText:@"The internet address or URL of the website visited immediately prior to visiting CDC’s digital media, if you connect to CDC.gov via a link from another web page."];
                [visitsToCDCDotGovBullet6 sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBullet6];
                contentSizeHeight += visitsToCDCDotGovBullet6.frame.size.height;
                
                UILabel *visitsToCDCDotGovBulletG = [[UILabel alloc] initWithFrame:CGRectMake(38, visitsToCDCDotGovBullet6.frame.origin.y - 4, 10, 10)];
                [visitsToCDCDotGovBulletG setNumberOfLines:0];
                [visitsToCDCDotGovBulletG setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [visitsToCDCDotGovBulletG setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovBulletG setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovBulletG setText:@"\u2022"];
                [visitsToCDCDotGovBulletG sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovBulletG];
                
                UILabel *visitsToCDCDotGovEnd = [[UILabel alloc] initWithFrame:CGRectMake(8, visitsToCDCDotGovBullet6.frame.origin.y + visitsToCDCDotGovBullet6.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [visitsToCDCDotGovEnd setNumberOfLines:0];
                [visitsToCDCDotGovEnd setLineBreakMode:NSLineBreakByWordWrapping];
                [visitsToCDCDotGovEnd setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [visitsToCDCDotGovEnd setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [visitsToCDCDotGovEnd setTextAlignment:NSTextAlignmentLeft];
                [visitsToCDCDotGovEnd setText:@"\nCollection and analysis of this information in the aggregate will help us enhance performance of our digital media, improve informational materials available through digital media, and improve overall customer service"];
                [visitsToCDCDotGovEnd sizeToFit];
                [contentHolder addSubview:visitsToCDCDotGovEnd];
                contentSizeHeight += visitsToCDCDotGovEnd.frame.size.height;
                
                UILabel *useOfCookies = [[UILabel alloc] initWithFrame:CGRectMake(8, visitsToCDCDotGovEnd.frame.origin.y + visitsToCDCDotGovEnd.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [useOfCookies setNumberOfLines:0];
                [useOfCookies setLineBreakMode:NSLineBreakByWordWrapping];
                [useOfCookies setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [useOfCookies setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [useOfCookies setTextAlignment:NSTextAlignmentLeft];
                [useOfCookies setText:@"Use of Cookies"];
                [contentHolder addSubview:useOfCookies];
                contentSizeHeight += useOfCookies.frame.size.height;
                
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
                [contentHolder addSubview:useOfCookiesBody];
                contentSizeHeight += useOfCookiesBody.frame.size.height;
                
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
                
                UILabel *usingMobileApplications = [[UILabel alloc] initWithFrame:CGRectMake(8, useOfCookiesBody.frame.origin.y + useOfCookiesBody.frame.size.height, contentHolder.frame.size.width - 16.0, 40)];
                [usingMobileApplications setNumberOfLines:0];
                [usingMobileApplications setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplications setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [usingMobileApplications setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplications setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplications setText:@"Using CDC’s Mobile Applications"];
                [contentHolder addSubview:usingMobileApplications];
                contentSizeHeight += usingMobileApplications.frame.size.height;
                
                UILabel *usingMobileApplicationsIntro = [[UILabel alloc] initWithFrame:CGRectMake(8, usingMobileApplications.frame.origin.y + usingMobileApplications.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [usingMobileApplicationsIntro setNumberOfLines:0];
                [usingMobileApplicationsIntro setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsIntro setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [usingMobileApplicationsIntro setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsIntro setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsIntro setText:@"When you use CDC’s Mobile Applications (Apps), certain information will be gathered and stored about your usage of the App. This information does not identify you personally. We collect and store information as follows:\n"];
                [usingMobileApplicationsIntro sizeToFit];
                [contentHolder addSubview:usingMobileApplicationsIntro];
                contentSizeHeight += usingMobileApplicationsIntro.frame.size.height;
                
                NSMutableAttributedString *usingMobileApplicationsBullet0String = [[NSMutableAttributedString alloc] initWithString:@"CDC receives aggregate data about the use of our Apps, such as the number of times the applications have been opened or the interactions or actions completed in the application. This is gathered via a third party provider (please refer to the tools list). We also receive aggregate data from the platforms that distribute our Apps (currently the iTunes Store, Google Play Store, and the Windows Store), such as the number of people who download the App and mobile set-up information (e.g., device model, App version, country, language, and mobile carrier). Please consult the privacy policies of these third parties for further information." attributes:nil];
                usingMobileApplicationsBullet0HyperlinkRange = [[usingMobileApplicationsBullet0String string] rangeOfString:@"please refer to the tools list"];
                NSDictionary *bullet0LinkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
                [usingMobileApplicationsBullet0String setAttributes:bullet0LinkAttributes range:usingMobileApplicationsBullet0HyperlinkRange];
                UILabel *usingMobileApplicationsBullet0 = [[UILabel alloc] initWithFrame:CGRectMake(50, usingMobileApplicationsIntro.frame.origin.y + usingMobileApplicationsIntro.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
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
                [contentHolder addSubview:usingMobileApplicationsBulletA];
                
                NSMutableAttributedString *usingMobileApplicationsBullet1String = [[NSMutableAttributedString alloc] initWithString:@"You may sign up to receive “push notification” messages via a third party provider (please refer to the tools list). To make sure messages reach the correct devices, our third party provider relies on a device token unique to your mobile device. A device token is a unique identifier issued to the app by the operating system of the mobile device. While we may be able to access a list of the tokens, the App and tokens do not reveal your identity, unique device ID, or contact information to us. The third party provider may collect the following: the time of an event, how a User came to our site, what search engine and search keywords users may have used to get to our site, information about the device our user is on such as their Operating System, and browser, as well as the city, region and country location of users. This location information enables CDC to send public health push notification messages that are relevant to certain geographic locations. If, at any time, you wish to stop receiving push notifications, simply adjust your phone settings or remove the App." attributes:nil];
                usingMobileApplicationsBullet1HyperlinkRange0 = [[usingMobileApplicationsBullet1String string] rangeOfString:@"please refer to the tools list"];
                usingMobileApplicationsBullet1HyperlinkRange1 = [[usingMobileApplicationsBullet1String string] rangeOfString:@"device token"];
                NSDictionary *bullet1LinkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
                [usingMobileApplicationsBullet1String setAttributes:bullet1LinkAttributes range:usingMobileApplicationsBullet1HyperlinkRange0];
                [usingMobileApplicationsBullet1String setAttributes:bullet1LinkAttributes range:usingMobileApplicationsBullet1HyperlinkRange1];
                UILabel *usingMobileApplicationsBullet1 = [[UILabel alloc] initWithFrame:CGRectMake(50, usingMobileApplicationsBullet0.frame.origin.y + usingMobileApplicationsBullet0.frame.size.height, contentHolder.frame.size.width - 72.0, 300)];
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
                
                UILabel *usingMobileApplicationsBulletB = [[UILabel alloc] initWithFrame:CGRectMake(38, usingMobileApplicationsBullet1.frame.origin.y - 4, 10, 10)];
                [usingMobileApplicationsBulletB setNumberOfLines:0];
                [usingMobileApplicationsBulletB setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsBulletB setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
                [usingMobileApplicationsBulletB setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsBulletB setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsBulletB setText:@"\u2022"];
                [usingMobileApplicationsBulletB sizeToFit];
                [contentHolder addSubview:usingMobileApplicationsBulletB];
                
                UILabel *usingMobileApplicationsEnd = [[UILabel alloc] initWithFrame:CGRectMake(8, usingMobileApplicationsBullet1.frame.origin.y + usingMobileApplicationsBullet1.frame.size.height, contentHolder.frame.size.width - 16.0, 300)];
                [usingMobileApplicationsEnd setNumberOfLines:0];
                [usingMobileApplicationsEnd setLineBreakMode:NSLineBreakByWordWrapping];
                [usingMobileApplicationsEnd setFont:[UIFont fontWithName:@"HelveticaNeue" size:paragraphFontSize]];
                [usingMobileApplicationsEnd setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
                [usingMobileApplicationsEnd setTextAlignment:NSTextAlignmentLeft];
                [usingMobileApplicationsEnd setText:@"\nCDC does not disclose, share, sell, or transfer any information about CDC digital media visitors or users unless required for law enforcement or otherwise required by law.\n\nFor site security purposes and to ensure that this service remains available to all users, CDC employs software programs to identify unauthorized attempts to upload or change information, or otherwise cause damage.\n\nCDC’s digital media are maintained by the U.S. Government and is protected by various provisions of Title 18, U.S. Code. Violations of Title 18 are subject to criminal prosecution in Federal court."];
                [usingMobileApplicationsEnd sizeToFit];
                [contentHolder addSubview:usingMobileApplicationsEnd];
                contentSizeHeight += usingMobileApplicationsEnd.frame.size.height;
                
                [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, contentSizeHeight)];
            }
                break;
                
            case 1:
            {
                [content setText:@"\nTHE MATERIALS EMBODIED IN THIS SOFTWARE ARE PROVIDED TO YOU \"AS-IS\" AND WITHOUT WARRANTY OF ANY KIND, EXPRESSED, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE CENTERS FOR DISEASE CONTROL AND PREVENTION (CDC) OR THE UNITED STATES (U.S.) GOVERNMENT BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT, SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION, LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF THIRD PARTIES, WHETHER OR NOT CDC OR THE U.S. GOVERNMENT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.\n\nCDC is not responsible for confidentiality or any information shared by the owner or user of the device that runs the Epi Info™ Mobile Application with other parties. CDC is not responsible for information shared with third parties through loss or theft of the device.\n\nThis application is used for data collection and is not intended to provide medical advice or diagnoses. Any questions regarding personal medical information should be directed to a primary care physician.\n\nUse of trade names, commercial sources or private organizations is for identification only and does not imply endorsement by the U.S. Department of Health and Human Services and/or CDC."];
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
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cdc.gov/other/third-party-pages.html"]];
            }
            else if (NSLocationInRange(indexOfCharacter, usingMobileApplicationsBullet1HyperlinkRange1)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.whitehouse.gov/privacy#device"]];
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
