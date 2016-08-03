//
//  OMMutibleSlider.h
//  OMNI
//
//  Created by changxicao on 16/8/2.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseView.h"
#import "OMRoomTableViewCell.h"

typedef NS_ENUM(NSInteger, OMDynamicTheme) {
    OMDynamicThemeHappy = 1,
    OMDynamicThemeDinner,
    OMDynamicThemeGardon,
    OMDynamicThemeRomantic,
    OMDynamicThemeRock,
    OMDynamicThemeWinnerNight
};

@interface OMMutibleSlider : OMBaseView

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (weak, nonatomic) OMRoomTableViewCell *tableViewCell;

@end


@interface OMDynamicControlView : OMBaseView

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) OMDynamicTheme theme;

@end

@interface OMStaticControlView : OMBaseView

@property (strong, nonatomic) OMRoomDevice *roomDevice;
@property (strong, nonatomic) UIColor *color;

@end

@interface OMSlider : UISlider

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@end

@interface OMMutibleCircleView : OMBaseView

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) OMRoomDevice *roomDevice;
@property (weak, nonatomic) OMRoomTableViewCell *tableViewCell;

@end