//
//  OMMutiableLightThemeViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseTableViewCell.h"
#import "OMMutibleSlider.h"

typedef void(^OMMutiableLightThemeBlock)(OMDynamicTheme theme);
@interface OMMutiableLightThemeViewController : OMBaseViewController

@property (assign, nonatomic) OMDynamicTheme theme;
@property (strong, nonatomic) OMRoomDevice *roomDevice;
@property (copy, nonatomic) OMMutiableLightThemeBlock block;

@end


@interface OMMutiableLightThemeCell : OMBaseTableViewCell

@property (strong, nonatomic) NSString *text;

@end