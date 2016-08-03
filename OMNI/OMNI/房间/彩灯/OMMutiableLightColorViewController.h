//
//  OMMutiableLightColorViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseScrollViewController.h"
#import "OMBaseView.h"

#define colorArray @[@"F00000", @"F04000", @"F08000", @"F0C000", @"F0F000", @"00F000", @"00F040", @"00F080", @"00F0C0", @"00F0F0", @"0000FF", @"4000F0", @"8000F0", @"C000F0", @"F000F0"]

typedef void(^OMMutiableLightColorBlock)(NSInteger colorIndex);

@interface OMMutiableLightColorViewController : OMBaseScrollViewController

@property (assign, nonatomic) NSInteger colorIndex;

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (copy, nonatomic) OMMutiableLightColorBlock block;

@end


@interface OMMutiableLightColorView : OMBaseView

@property (strong, nonatomic) UIColor *color;

@property (assign, nonatomic) BOOL selected;

@end