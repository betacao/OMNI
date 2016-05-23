//
//  OMBaseTableViewCell.m
//  OMNI
//
//  Created by changxicao on 16/5/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@implementation OMBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
    [self addReactiveCocoa];
}

- (void)initView
{

}

- (void)addAutoLayout
{

}

- (void)addReactiveCocoa
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
