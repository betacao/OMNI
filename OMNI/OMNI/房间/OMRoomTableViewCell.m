//
//  OMRoomTableViewCell.m
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoomTableViewCell.h"

@interface OMRoomTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UIView *spliteView;

@end

@implementation OMRoomTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initView
{
    self.contentView.backgroundColor = [UIColor redColor];
}

- (void)addAutoLayout
{

}

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    self.label.text = roomDevice.roomDeviceName;

}


@end
