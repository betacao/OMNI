//
//  OMAddRoomViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddRoomViewController.h"
#import "OMRoomViewController.h"

@interface OMAddRoomViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation OMAddRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (kAppDelegate.currentRoom.roomName.length > 0) {
        self.title = @"Edite Room";
    } else{
        self.title = @"Add Room";
    }

    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)initView
{
    [self.button setImage:[UIImage imageNamed:@"add_room"] forState:UIControlStateNormal];

    UIImage *image = self.textField.background;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.textField.background = image;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;

    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.scrollView]) {
            [self.scrollView addSubview:obj];
        }
    }];
}


- (void)addAutoLayout
{
    self.button.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.scrollView, MarginFactor(44.0f))
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

    self.textField.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(10.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(10.0f))
    .topSpaceToView(self.button, MarginFactor(44.0f))
    .heightIs(MarginFactor(40.0f));
}

- (void)addReactiveCocoa
{
    [[[self.textField rac_textSignal] filter:^BOOL(NSString *value) {
        return value.length > 32;
    }] subscribeNext:^(NSString *x) {
        self.textField.text = [x substringToIndex:32];
    }];
}

- (void)rightButtonClick:(UIButton *)button
{
    [self.textField resignFirstResponder];
    if (self.textField.text.length == 0) {
        [self.view showWithText:@"请输入房间名称"];
        return;
    }
    [OMGlobleManager createRoom:self.textField.text inView:self.view block:^(NSArray *array) {
        if ([[array firstObject] isEqualToString:@"01"]) {
            [self.view showWithText:@"房间创建成功"];
            for (OMBaseViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OMRoomViewController class]]) {
                    [controller loadData];
                    [self.navigationController performSelector:@selector(popToViewController:animated:) withObjects:@[controller, @(YES)] afterDelay:1.2f];
                }
            }
        } else{
            [self.view showWithText:@"房间创建失败，请重新创建"];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
