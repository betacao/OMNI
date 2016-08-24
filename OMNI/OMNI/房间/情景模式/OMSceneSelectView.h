//
//  OMSceneSelectView.h
//  OMNI
//
//  Created by changxicao on 16/8/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseView.h"
#import "OMBaseTableViewCell.h"

typedef void(^OMSceneSelectViewBlock)(NSInteger index);

@interface OMSceneSelectView : OMBaseView
@property (copy, nonatomic) OMSceneSelectViewBlock block;
@end

@interface OMSceneSelectTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) NSString *string;

@end
