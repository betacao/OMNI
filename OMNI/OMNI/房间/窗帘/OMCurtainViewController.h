//
//  OMCurtainViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/15.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMRoomTableViewCell.h"

@interface OMCurtainViewController : OMBaseViewController

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (weak, nonatomic) OMRoomTableViewCell *tableViewCell;

@end
