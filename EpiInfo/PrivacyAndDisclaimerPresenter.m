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
        
        UIScrollView *contentHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32, frame.size.width, frame.size.height - 32)];
        [contentHolder setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentHolder];
        
        UILabel *content = [[UILabel alloc] init];
        [content setNumberOfLines:0];
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        [content setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [content setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [content setFrame:CGRectMake(8, 0, contentHolder.frame.size.width - 16, contentHolder.frame.size.height)];
        [content setTextAlignment:NSTextAlignmentLeft];
        [contentHolder addSubview:content];
        
        switch (tag) {
            case 0:
            {
                [content setText:@"\nThis app is provided to assist in epidemiologic and other scientific investigations. It collects no information, personal or otherwise, about the user or the user's mobile device.\n\nFuture releases may collect device and usage information such as:\n\n\u2022 Information about your mobile device\n\u25e6 Type and model\n\u25e6 iOS version\n\u2022 The number of times the app was accessed\n\u2022 Screens accessed"];
            }
                break;
                
            case 1:
            {
                [content setText:@"\nTHE MATERIALS EMBODIED IN THIS SOFTWARE ARE PROVIDED TO YOU \"AS-IS\" AND WITHOUT WARRANTY OF ANY KIND, EXPRESSED, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE CENTERS FOR DISEASE CONTROL AND PREVENTION (CDC) OR THE UNITED STATES (U.S.) GOVERNMENT BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT, SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION, LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF THIRD PARTIES, WHETHER OR NOT CDC OR THE U.S. GOVERNMENT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE."];
            }
                break;
                
            default:
                break;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [content setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        }
        
        [content sizeToFit];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
