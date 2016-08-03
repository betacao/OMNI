//
//  OMMutibleLightViewController.h
//  
//
//  Created by changxicao on 16/8/2.
//
//

#import "OMBaseViewController.h"
#import "OMRoomTableViewCell.h"

@interface OMMutibleLightViewController : OMBaseViewController

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (weak, nonatomic) OMRoomTableViewCell *tableViewCell;

@end
