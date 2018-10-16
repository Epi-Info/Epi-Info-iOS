//
//  EpiInfoImageField.h
//  EpiInfo
//
//  Created by John Copeland on 1/17/18.
//

#import "EpiInfoControlProtocol.h"
#import <UIKit/UIKit.h>

@interface EpiInfoImageField : UIButton <UIImagePickerControllerDelegate, UINavigationControllerDelegate, EpiInfoControlProtocol>
{
    UIImagePickerController *uiipc;
    NSString *imageGUID;
    CGSize initialSize;
}
@property NSString *columnName;
-(UIImage *)epiInfoImageValue;
@end
