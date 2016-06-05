//
//  UIView+HUD.m
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "UIView+HUD.h"

@implementation UIView (HUD)

- (void)showLoading
{
    [self performSelectorOnMainThread:@selector(hideHudOnMainThread) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showOnMainThread) withObject:nil waitUntilDone:YES];
}

- (void)showOnMainThread
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.opacity = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
}


- (void)showWithText:(NSString *)text
{
    [self performSelectorOnMainThread:@selector(showTextOnMainThread:) withObject:text waitUntilDone:YES];
}

- (void)showTextOnMainThread:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FontFactor(15.0f);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [label sizeToFit];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = label;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = 0.85f;
    hud.margin = MarginFactor(18.0f);
    [hud hide:YES afterDelay:2.0f];
}

- (void)hideHudOnMainThread
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [((MBProgressHUD *)subView) hide:YES];
        }
    }
}

- (void)hideHud
{
    [self performSelectorOnMainThread:@selector(hideHudOnMainThread) withObject:nil waitUntilDone:YES];
}
@end
