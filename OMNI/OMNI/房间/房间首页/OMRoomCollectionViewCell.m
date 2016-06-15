//
//  OMRoomCollectionViewCell.m
//  OMNI
//
//  Created by changxicao on 16/6/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoomCollectionViewCell.h"

@interface OMRoomCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation OMRoomCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initView
{
    self.label.font = FontFactor(14.0f);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor grayColor];
}

- (void)addAutoLayout
{
    self.label.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .heightIs(self.label.font.lineHeight);
    
    self.imageView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightEqualToWidth();
    
}

- (void)setRoom:(OMRoom *)room
{
    _room = room;
    self.label.text = room.roomName;
    if (room.roomName && room.roomName.length > 0) {
        self.imageView.image = [UIImage imageNamed:@"fj"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"add_room"];
    }
}

@end
