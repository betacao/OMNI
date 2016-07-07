//
//  OMAddTimingViewController.h
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseView.h"

@interface OMAddTimingViewController : OMBaseViewController

@end


@interface OMAddTimingSubView : OMBaseView

- (void)addLeftTitle:(NSString *)title;

- (void)addRightTitle:(NSString *)title;

@end