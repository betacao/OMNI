//
//  OMAddRoomDeviceViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/6.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddRoomDeviceViewController.h"
#import "OMEditRoomDeviceViewController.h"

@interface OMAddRoomDeviceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) OMRoomDevice *currentRoomDevice;

@end

@implementation OMAddRoomDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add a new device";

}

- (void)initView
{
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = FontFactor(13.0f);

    self.deviceTypeLabel.textColor = [UIColor whiteColor];
    self.deviceTypeLabel.font = FontFactor(16.0f);

    self.button.titleLabel.font = FontFactor(14.0f);
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.tableView.backgroundColor = self.middleView.backgroundColor = [UIColor clearColor];

    self.imageView.image = [self.imageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch];


    self.dataArray = [NSMutableArray array];
    NSArray *deviceTypeArray = @[@(259), @(260), @(261), @(262), @(263), @(258)];
    NSArray *titleArray = @[@"Light", @"Bicolor Light", @"RGBLight", @"Art fan", @"Intelligent Curtain", @"Smart Switch"];
    for (NSInteger i = 0; i < deviceTypeArray.count; i++) {
        OMRoomDevice *roomDevice = [[OMRoomDevice alloc] init];
        roomDevice.roomDeviceType = [[deviceTypeArray objectAtIndex:i] integerValue];
        roomDevice.roomDeviceName = [titleArray objectAtIndex:i];
        [self.dataArray addObject: roomDevice];
    }
    [self.tableView reloadData];
}

- (void)addAutoLayout
{
    self.tipLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.view, MarginFactor(20.0f))
    .autoHeightRatio(0.0f);

    self.deviceTypeLabel.sd_layout
    .leftEqualToView(self.tipLabel)
    .rightEqualToView(self.tipLabel)
    .topSpaceToView(self.tipLabel, MarginFactor(20.0f))
    .heightIs(self.deviceTypeLabel.font.lineHeight);

    self.button.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, MarginFactor(44.0f))
    .widthIs(self.button.currentBackgroundImage.size.width)
    .heightIs(self.button.currentBackgroundImage.size.height);

    self.middleView.sd_layout
    .leftEqualToView(self.tipLabel)
    .rightEqualToView(self.tipLabel)
    .topSpaceToView(self.deviceTypeLabel, MarginFactor(10.0f))
    .bottomSpaceToView(self.button, MarginFactor(12.0f));

    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)addReactiveCocoa
{
    RACSignal *signal = [RACObserve(self, currentRoomDevice) map:^id(id value) {
        return value;
    }];

    RAC(self.button, enabled) = [signal map:^id(id value) {
        return @(value != nil);
    }];

    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMEditRoomDeviceViewController *controller = [[OMEditRoomDeviceViewController alloc] init];
        controller.roomDevice = self.currentRoomDevice;
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ceilf(CGRectGetHeight(self.middleView.frame) / self.dataArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMAddRoomDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMAddRoomDeviceTableViewCell"];
    if (!cell) {
        cell = [[OMAddRoomDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMAddRoomDeviceTableViewCell"];
    }
    cell.roomDevice = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentRoomDevice = [self.dataArray objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end


@interface OMAddRoomDeviceTableViewCell()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImageView *spliteView;

@end

@implementation OMAddRoomDeviceTableViewCell

- (void)initView
{
    self.iconImageView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_type_tick"]];
    self.spliteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_type_line"]];
    [self.contentView sd_addSubviews:@[self.iconImageView, self.nameLabel, self.selectedImageView, self.spliteView]];

    self.contentView.backgroundColor = self.backgroundColor = Color(@"0");
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = BoldFontFactor(15.0f);
    self.selectedImageView.hidden = YES;
}

- (void)addAutoLayout
{
    self.iconImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, MarginFactor(10.0f));

    self.nameLabel.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.iconImageView, MarginFactor(10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.selectedImageView.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .widthIs(self.selectedImageView.image.size.width)
    .heightIs(self.selectedImageView.image.size.height);

    self.spliteView.sd_layout
    .bottomSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(self.spliteView.image.size.height);
}

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;

    self.nameLabel.text = roomDevice.roomDeviceName;
    self.iconImageView.image = roomDevice.roomDeviceIcon;

    self.iconImageView.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, MarginFactor(20.0f))
    .widthIs(self.iconImageView.image.size.width)
    .heightIs(self.iconImageView.image.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedImageView.hidden = !selected;
}

@end
