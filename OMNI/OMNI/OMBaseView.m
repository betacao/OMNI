//
//  OMBaseView.m
//  OMNI
//
//  Created by changxicao on 16/6/27.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseView.h"

@implementation OMBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
        [self addReactiveCocoa];
        [self loadData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
    [self addReactiveCocoa];
    [self loadData];
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

- (void)loadData
{
    
}


@end
