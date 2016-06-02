//
//  const.h
//  OMNI
//
//  Created by changxicao on 16/5/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#ifndef const_h
#define const_h

#define WEAK(self, weakSelf) __weak typeof(self) weakSelf = self

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define FontFactor(font)  [UIFont systemFontOfSize:(SCREENWIDTH >= 375.0f ? font : (font - 1.0f))]
#define BoldFontFactor(font)  [UIFont boldSystemFontOfSize:(SCREENWIDTH >= 375.0f ? font : (font - 1.0f))]
#define MarginFactor(x) floorf(SCREENWIDTH / 375.0f * x)

#define Color(color) [UIColor colorWithHexString: color]

#define kStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

#define kNavigationBarHeight CGRectGetHeight(self.navigationController.navigationBar.frame)

#define SCALE [UIScreen mainScreen].scale

#endif /* const_h */
