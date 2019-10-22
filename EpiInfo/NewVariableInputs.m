//
//  NewVariableInputs.m
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.
//

#import "NewVariableInputs.h"

@implementation NewVariableInputs

- (void)setNewVariableType:(NSString *)nvType
{
    newVariableType = nvType;
}

- (void)setFunction:(NSString *)func
{
    [function setText:func];
}
- (void)setAVC:(UIViewController *)uivc
{
    avc = uivc;
}
- (void)setNewVariableName:(NSString *)nvn
{
    newVariableName = nvn;
}
- (void)setListOfNewVariables:(NSMutableArray *)nsma
{
    listOfNewVariables = nsma;
}
- (void)setNewVariableList:(UITableView *)uitv
{
    newVariableList = uitv;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2.0, 4, 4)];
    if (self)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self setFrame:CGRectMake(frame.origin.x + frame.size.width / 4.0, frame.origin.y + frame.size.height / 4.0, 4, 4)];
        }

        [self setBackgroundColor:[UIColor whiteColor]];
        
        function = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [function setBackgroundColor:[UIColor whiteColor]];
        [function setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [function setTextAlignment:NSTextAlignmentCenter];
        [function setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [self addSubview:function];
        
        saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 2, 4)];
        [saveButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [saveButton.layer setCornerRadius:2];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setAccessibilityLabel:@"Save variable inputs"];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [saveButton addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 2, 4)];
        [cancelButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [cancelButton.layer setCornerRadius:2];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setAccessibilityLabel:@"Cancel"];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [function setFrame:CGRectMake(0, 0, frame.size.width, 28)];
    [saveButton setFrame:CGRectMake(4, frame.size.height - 44, 120, 40)];
    [cancelButton setFrame:CGRectMake(frame.size.width - 124, frame.size.height - 44, 120, 40)];
}

- (void)removeSelf:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)fieldResignedFirstResponder:(id)field
{
    // Stub
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
