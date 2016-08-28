//
//  OMListTableViewCell.m
//  OMNI
//
//  Created by changxicao on 16/5/18.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMListTableViewCell.h"
#import "OMDeviceConfigView.h"

@interface OMListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *elementView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation OMListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = self.elementView.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];

    UIImage *image = [self.backgroundImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.backgroundImageView.image = image;

    self.nameLabel.font = BoldFontFactor(18.0f);
    self.IDLabel.font = FontFactor(14.0f);

    [self.button setEnlargeEdge:20.0f];

}

- (void)addAutoLayout
{
    self.elementView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(30.0f))
    .rightSpaceToView(self.contentView, MarginFactor(30.0f))
    .topSpaceToView(self.contentView, MarginFactor(30.0f))
    .bottomSpaceToView(self.contentView, 0.0f);

    self.backgroundImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.statusImageView.sd_layout
    .centerYEqualToView(self.elementView)
    .leftSpaceToView(self.elementView, MarginFactor(25.0f))
    .widthIs(self.statusImageView.image.size.width)
    .heightIs(self.statusImageView.image.size.height);

    self.nameLabel.sd_layout
    .leftSpaceToView(self.statusImageView, MarginFactor(25.0f))
    .centerYEqualToView(self.elementView)
    .offset(MarginFactor(-10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.IDLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .centerYEqualToView(self.elementView)
    .offset(MarginFactor(10.0f))
    .heightIs(self.IDLabel.font.lineHeight);
    [self.IDLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.button.sd_layout
    .centerYEqualToView(self.elementView)
    .rightSpaceToView(self.elementView, MarginFactor(10.0f))
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

}

- (void)addReactiveCocoa
{
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        kAppDelegate.deviceID = self.device.deviceID;
        OMDeviceConfigView *deviceConfigView = [[OMDeviceConfigView alloc] init];
        OMAlertView *alert = [[OMAlertView alloc] initWithCustomView:deviceConfigView leftButtonTitle:nil rightButtonTitle:nil];
        alert.touchOtherDismiss = YES;
        [alert show];
    }];
}

- (void)setDevice:(OMDevice *)device
{
    _device = device;
    NSString *deviceName = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@.deviceName", self.device.deviceID]];
    if (deviceName && deviceName.length > 0) {
        self.nameLabel.text = deviceName;
    } else{
        self.nameLabel.text = device.deviceName;
    }
    self.IDLabel.text = device.deviceID;
    if ([device.deviceState containsString:@"on"]) {
        self.statusImageView.image = [UIImage imageNamed:@"itemonline"];
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"itemoffline"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
