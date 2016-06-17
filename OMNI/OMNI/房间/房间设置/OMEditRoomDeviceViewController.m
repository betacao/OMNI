//
//  OMEditRoomDeviceViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/15.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMEditRoomDeviceViewController.h"

@interface OMEditRoomDeviceViewController ()<UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *roomField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *pairButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *panelButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OMEditRoomDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Edit Device";
    self.scrollView.delegate = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)initView
{
    self.imageView.image = self.roomDevice.roomDeviceIcon;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.roomField.text = kAppDelegate.currentRoom.roomName;

    UIView *leftView1 = [[UIView alloc] init];
    UIImageView *leftImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_name"]];
    [leftView1 addSubview:leftImageView1];
    leftImageView1.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView1.sd_layout
    .heightIs(leftImageView1.image.size.height)
    .widthIs(leftImageView1.image.size.width + MarginFactor(20.0f));


    UIView *leftView2 = [[UIView alloc] init];
    UIImageView *leftImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_name"]];
    [leftView2 addSubview:leftImageView2];
    leftImageView2.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView2.sd_layout
    .heightIs(leftImageView2.image.size.height)
    .widthIs(leftImageView2.image.size.width + MarginFactor(20.0f));

    self.nameField.leftView = leftView1;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.roomField.leftView = leftView2;
    self.roomField.leftViewMode = UITextFieldViewModeAlways;

    UIView *rightView1 = [[UIView alloc] init];
    UIImageView *rightImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_arrow"]];
    [rightView1 addSubview:rightImageView1];
    rightImageView1.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    rightView1.sd_layout
    .heightIs(rightImageView1.image.size.height)
    .widthIs(rightImageView1.image.size.width + MarginFactor(20.0f));


    UIView *rightView2 = [[UIView alloc] init];
    UIImageView *rightImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_arrow"]];
    [rightView2 addSubview:rightImageView2];
    rightImageView2.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    rightView2.sd_layout
    .heightIs(rightImageView2.image.size.height)
    .widthIs(rightImageView2.image.size.width + MarginFactor(20.0f));

    self.nameField.rightView = rightView1;
    self.nameField.rightViewMode = UITextFieldViewModeAlways;
    self.roomField.rightView = rightView2;
    self.roomField.rightViewMode = UITextFieldViewModeAlways;

    self.middleView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.deleteButton.titleLabel.font = self.panelButton.titleLabel.font = self.pairButton.titleLabel.font = FontFactor(14.0f);
    
    self.middleImageView.image = [self.middleImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
    self.lineView.backgroundColor = [UIColor blackColor];

    self.tipLabel.font = FontFactor(13.0f);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"choose_device_type"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch]];

    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.scrollView]) {
            [self.scrollView addSubview:obj];
        }
    }];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.scrollView, 0.0f)
    .widthIs(self.imageView.image.size.width)
    .heightRatioToView(self.middleView, 1.0f);

    self.middleView.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(20.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(20.0f))
    .topSpaceToView(self.imageView, 0.0f);

    self.nameField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.middleView, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.lineView.sd_layout
    .leftEqualToView(self.nameField)
    .rightEqualToView(self.nameField)
    .topSpaceToView(self.nameField, 0.0f)
    .heightIs(1 / SCALE);

    self.roomField.sd_layout
    .leftEqualToView(self.nameField)
    .rightEqualToView(self.nameField)
    .topSpaceToView(self.lineView, 0.0f)
    .heightRatioToView(self.nameField, 1.0f);

    [self.middleView setupAutoHeightWithBottomView:self.roomField bottomMargin:0.0f];

    self.deleteButton.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.middleView, MarginFactor(15.0f))
    .widthIs(self.deleteButton.currentBackgroundImage.size.width)
    .heightIs(self.deleteButton.currentBackgroundImage.size.height);

    self.pairButton.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.deleteButton, MarginFactor(10.0f))
    .widthIs(self.pairButton.currentBackgroundImage.size.width)
    .heightIs(self.pairButton.currentBackgroundImage.size.height);

    self.tipLabel.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.pairButton, MarginFactor(10.0f))
    .heightIs(self.tipLabel.font.lineHeight);
    [self.tipLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.panelButton.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.tipLabel, MarginFactor(10.0f))
    .widthIs(self.panelButton.currentBackgroundImage.size.width)
    .heightIs(self.panelButton.currentBackgroundImage.size.height);

    self.middleImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

//    self.tableView.sd_layout
//    .leftEqualToView(self.nameField)
//    .rightEqualToView(self.nameField)
//    .topSpaceToView(self.middleView, MarginFactor(3.0f))
////    .heightIs(MAX(<#A#>, <#B#>));
}

- (void)addReactiveCocoa
{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAppDelegate.roomArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMEditRoomDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMEditRoomDeviceTableViewCell"];
    if (!cell) {
        cell = [[OMEditRoomDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMEditRoomDeviceTableViewCell"];
    }
    cell.room = [kAppDelegate.roomArray objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.roomField]) {
        self.tableView.hidden = !self.tableView.hidden;
        return NO;
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.tableView.hidden = YES;
    [self.nameField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@interface OMEditRoomDeviceTableViewCell()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *spliteView;

@end

@implementation OMEditRoomDeviceTableViewCell

- (void)initView
{
    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(17.0f);
    self.label.textColor = Color(@"8ad853");

    self.spliteView = [[UIView alloc] init];
    self.spliteView.backgroundColor = [UIColor lightGrayColor];
}

- (void)addAutoLayout
{
    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(3.0f))
    .rightSpaceToView(self.contentView, MarginFactor(3.0f))
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    self.label.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.spliteView, 0.0f);
}

- (void)setRoom:(OMRoom *)room
{
    _room = room;

}

@end
