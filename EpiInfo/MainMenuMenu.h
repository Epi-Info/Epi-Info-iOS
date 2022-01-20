//
//  MainMenuMenu.h
//  EpiInfo
//
//  Created by John Copeland on 4/20/17.
//

#import <UIKit/UIKit.h>
#import "EpiInfoViewController.h"

@interface MainMenuMenu : UIView
@property UIViewController *eivc;
@property UIButton *customKeysOptionButton;
-(void)setEncryptionKeysButtonTitle:(UIButton *)sender;
@end
