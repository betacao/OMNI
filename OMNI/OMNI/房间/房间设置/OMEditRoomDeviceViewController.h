//
//  OMEditRoomDeviceViewController.h
//  OMNI
//
//  Created by changxicao on 16/6/15.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseScrollViewController.h"
#import "OMBaseTableViewCell.h"

@interface OMEditRoomDeviceViewController : OMBaseScrollViewController

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@end


@interface OMEditRoomDeviceTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) OMRoom *room;

@end