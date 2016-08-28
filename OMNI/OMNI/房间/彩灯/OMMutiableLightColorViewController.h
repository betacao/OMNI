//
//  OMMutiableLightColorViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseScrollViewController.h"
#import "OMBaseView.h"

#define colorArray @[@"F00000", @"00F000", @"0000FF", @"F04000", @"00F040", @"4000F0", @"F08000", @"00F080", @"8000F0", @"F0C000", @"00F0C0", @"C000F0", @"F0F000", @"00F0F0", @"F000F0"]

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