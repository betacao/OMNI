//
//  OMAddRoomDeviceViewController.h
//  OMNI
//
//  Created by changxicao on 16/6/6.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseTableViewCell.h"

@interface OMAddRoomDeviceViewController : OMBaseViewController

@end

@interface OMAddRoomDeviceTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@end