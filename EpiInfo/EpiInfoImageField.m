//
//  EpiInfoImageField.m
//  EpiInfo
//
//  Created by John Copeland on 1/17/18.
//

#import "EpiInfoImageField.h"
#import "EnterDataView.h"
#import "DataEntryViewController.h"

@implementation EpiInfoImageField
@synthesize columnName = _columnName;
@synthesize isReadOnly = _isReadOnly;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        initialSize = frame.size;
        uiipc = [[UIImagePickerController alloc] init];
        [uiipc setSourceType:UIImagePickerControllerSourceTypeCamera];
        [uiipc setDelegate:self];
        [self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
        imageGUID = @"";
    }

    return self;
}

- (void)selfPressed:(UIButton *)sender
{
    NSLog(@"Image Button Pressed");
    [((EnterDataView *)[[self superview] superview]).rootViewController presentViewController:uiipc animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [((EnterDataView *)[[self superview] superview]).rootViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    CGSize newSize = CGSizeMake(0.1f * [(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage] size].width, 0.1f * [(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage] size].height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage] drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *smallerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setImage:smallerImage forState:UIControlStateNormal];
    [((EnterDataView *)[[self superview] superview]).rootViewController dismissViewControllerAnimated:YES completion:nil];
    if ([imageGUID length] == 0 || [imageGUID isEqualToString:@"(null)"])
    {
        imageGUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    }
}

- (NSString *)epiInfoControlValue
{
    return imageGUID;
}

- (UIImage *)epiInfoImageValue
{
    return [[self imageView] image];
}

- (void)assignValue:(NSString *)value
{
    imageGUID = [NSString stringWithString:value];
    NSString *myFormName = [(EnterDataView *)[[self superview] superview] nameOfTheForm];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imageFile = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:myFormName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageGUID]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFile] && [value length] > 0)
    {
        [self setImage:[UIImage imageWithContentsOfFile:imageFile] forState:UIControlStateNormal];
    }
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    [self setEnabled:isEnabled];
    [self setUserInteractionEnabled:isEnabled];
    [self setAlpha:0.5 + 0.5 * (int)isEnabled];
    [(EnterDataView *)[[self superview] superview] setElementListArrayIsEnabledForElement:self.columnName andIsEnabled:isEnabled];
}

- (void)selfFocus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1f];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isEnabled])
                [self becomeFirstResponder];
            
            EnterDataView *myEdv = (EnterDataView *)[[self superview] superview];
            
            float yForBottom = [myEdv contentSize].height - [myEdv bounds].size.height;
            if (yForBottom < 0.0)
                yForBottom = 0.0;
            float selfY = self.frame.origin.y - 80.0f;
            
            CGPoint pt = CGPointMake(0.0f, selfY);
            if (selfY > yForBottom)
                pt = CGPointMake(0.0f, yForBottom);
            
            [myEdv setContentOffset:pt animated:YES];
        });
    });
}

- (void)reset
{
    [self setImage:nil forState:UIControlStateNormal];
    [self setIsEnabled:YES];
    imageGUID = @"";
}

- (void)resetDoNotEnable
{
    [self setImage:nil forState:UIControlStateNormal];
    imageGUID = @"";
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (image)
    {
        if (image.size.width > image.size.height)
        {
            float ratio = initialSize.width / image.size.width;
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, initialSize.width, ratio * image.size.height)];
        }
        else
        {
            float ratio = initialSize.height / image.size.height;
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, ratio * image.size.width, initialSize.height)];
        }
    }
    else
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, initialSize.width, initialSize.height)];
    }
    
    [super setImage:image forState:state];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
