//
//  OMListTableViewCell.m
//  OMNI
//
//  Created by changxicao on 16/5/18.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMListTableViewCell.h"

@interface OMListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *configButton;

@end

@implementation OMListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
}

- (void)addAutoLayout
{
    self.IDLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(15.0f))
    .centerYEqualToView(self.contentView)
    .heightIs(self.IDLabel.font.lineHeight);
    [self.IDLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.nameLabel.sd_layout
    .leftEqualToView(self.IDLabel)
    .bottomSpaceToView(self.IDLabel, MarginFactor(10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.stateLabel.sd_layout
    .leftEqualToView(self.IDLabel)
    .topSpaceToView(self.IDLabel, MarginFactor(10.0f))
    .heightIs(self.stateLabel.font.lineHeight);
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.configButton.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .widthIs(self.configButton.currentImage.size.width)
    .heightIs(self.configButton.currentImage.size.height);
}

- (void)setDevice:(OMDevice *)device
{
    _device = device;
    self.nameLabel.text = [@"设备名 ：" stringByAppendingString:device.deviceName];
    self.IDLabel.text = [@"设备ID ：" stringByAppendingString:device.deviceID];
    self.stateLabel.text = [@"状    态 ：" stringByAppendingString:device.deviceState];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
