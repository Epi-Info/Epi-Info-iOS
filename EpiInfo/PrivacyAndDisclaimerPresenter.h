//
//  PrivacyAndDisclaimerPresenter.h
//  EpiInfo
//
//  Created by John Copeland on 4/21/17.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PrivacyAndDisclaimerPresenter : UIView <MFMailComposeViewControllerDelegate>
{
    UIScrollView *contentHolder;
    
    NSLayoutManager *useOfCookiesLayoutManager;
    NSTextContainer *useOfCookiesTextContainer;
    NSTextStorage *useOfCookiesTextStorage;
    NSRange useOfCookiesHyperlinkRange;
    
    NSLayoutManager *usingMobileApplicationsBullet0LayoutManager;
    NSTextContainer *usingMobileApplicationsBullet0TextContainer;
    NSTextStorage *usingMobileApplicationsBullet0TextStorage;
    NSRange usingMobileApplicationsBullet0HyperlinkRange;
    
    NSLayoutManager *usingMobileApplicationsBullet1LayoutManager;
    NSTextContainer *usingMobileApplicationsBullet1TextContainer;
    NSTextStorage *usingMobileApplicationsBullet1TextStorage;
    NSRange usingMobileApplicationsBullet1HyperlinkRange0;
    NSRange usingMobileApplicationsBullet1HyperlinkRange1;
    
    UILabel *content;
}
-(id)initWithFrame:(CGRect)frame andTag:(NSInteger)tag;
@end
