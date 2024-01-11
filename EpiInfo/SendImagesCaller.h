//
//  SendImagesCaller.h
//  EpiInfo
//
//  Created by John Copeland on 1/4/24.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendImagesCaller : NSObject <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    BOOL spanishLanguage;
    NSMutableArray *ls;
    NSMutableArray *sentImages;
    NSString *paths0;
    NSString *formName;
    UIViewController *rootViewController;
    int bytelimit;
}
-(void)callSendImages:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
