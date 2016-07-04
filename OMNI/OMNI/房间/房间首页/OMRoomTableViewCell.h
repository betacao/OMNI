//
//  OMRoomTableViewCell.h
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@interface OMRoomTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (weak, nonatomic) UIViewController *controller;

@end
