//
//  OMMutiableLightColorViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMMutiableLightColorViewController.h"
#import "NSString+Extend.h"

#define kHorizontalMargin MarginFactor(30.0f)
#define kVerticaltalMargin MarginFactor(15.0f)

@interface OMMutiableLightColorViewController ()

@property (strong, nonatomic) NSArray *array1;
@property (strong, nonatomic) NSArray *array2;
@property (strong, nonatomic) NSArray *array3;
@property (strong, nonatomic) NSArray *array4;
@property (strong, nonatomic) NSArray *array5;
@property (strong, nonatomic) NSMutableArray *viewArray;

@end

@implementation OMMutiableLightColorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    self.title = @"Color";
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];

    
    self.array1 = [colorArray subarrayWithRange:NSMakeRange(0, 3)];
    self.array2 = [colorArray subarrayWithRange:NSMakeRange(3, 3)];
    self.array3 = [colorArray subarrayWithRange:NSMakeRange(6, 3)];
    self.array4 = [colorArray subarrayWithRange:NSMakeRange(9, 3)];
    self.array5 = [colorArray subarrayWithRange:NSMakeRange(12, 3)];
    
    self.viewArray = [NSMutableArray array];

    [self addSubView];

    self.colorIndex = self.colorIndex;
}

- (void)addSubView
{
    CGFloat width = ceilf((SCREENWIDTH - 4.0f * kHorizontalMargin) / 3.0f);
    [self.array1 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OMMutiableLightColorView *view = [[OMMutiableLightColorView alloc] init];
        [self.viewArray addObject:view];
        CGRect frame = CGRectMake(kHorizontalMargin * (idx + 1) + idx * width, kVerticaltalMargin, width, width);
        view.frame = frame;
        view.color = Color(obj);
        [self.scrollView addSubview:view];
    }];

    [self.array2 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OMMutiableLightColorView *view = [[OMMutiableLightColorView alloc] init];
        [self.viewArray addObject:view];
        CGRect frame = CGRectMake(kHorizontalMargin * (idx + 1) + idx * width, 2.0f * kVerticaltalMargin + width, width, width);
        view.frame = frame;
        view.color = Color(obj);
        [self.scrollView addSubview:view];
    }];

    [self.array3 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OMMutiableLightColorView *view = [[OMMutiableLightColorView alloc] init];
        [self.viewArray addObject:view];
        CGRect frame = CGRectMake(kHorizontalMargin * (idx + 1) + idx * width, 3.0f * kVerticaltalMargin + 2.0f * width, width, width);
        view.frame = frame;
        view.color = Color(obj);
        [self.scrollView addSubview:view];
    }];

    [self.array4 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OMMutiableLightColorView *view = [[OMMutiableLightColorView alloc] init];
        [self.viewArray addObject:view];
        CGRect frame = CGRectMake(kHorizontalMargin * (idx + 1) + idx * width, 4.0f * kVerticaltalMargin + 3.0f * width, width, width);
        view.frame = frame;
        view.color = Color(obj);
        [self.scrollView addSubview:view];
    }];

    [self.array5 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OMMutiableLightColorView *view = [[OMMutiableLightColorView alloc] init];
        [self.viewArray addObject:view];
        CGRect frame = CGRectMake(kHorizontalMargin * (idx + 1) + idx * width, 5.0f * kVerticaltalMargin + 4.0f * width, width, width);
        view.frame = frame;
        view.color = Color(obj);
        [self.scrollView addSubview:view];
    }];

    OMMutiableLightColorView *view = [[OMMutiableLightColorView alloc] init];
    view.color = [UIColor whiteColor];
    [self.scrollView addSubview:view];

    view.sd_layout
    .leftSpaceToView(self.scrollView, kHorizontalMargin)
    .rightSpaceToView(self.scrollView, kHorizontalMargin)
    .topSpaceToView([self.viewArray lastObject], kVerticaltalMargin)
    .heightIs(width);

    [self.viewArray addObject:view];

    [self.scrollView setupAutoContentSizeWithBottomView:view bottomMargin:kVerticaltalMargin];
}

- (void)addReactiveCocoa
{
    [self.viewArray enumerateObjectsUsingBlock:^(OMMutiableLightColorView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [[recognizer rac_gestureSignal] subscribeNext:^(id x) {
            [self.viewArray enumerateObjectsUsingBlock:^(OMMutiableLightColorView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = NO;
            }];
            self.colorIndex = [self.viewArray indexOfObject:obj];
        }];
        [obj addGestureRecognizer:recognizer];
    }];
}

- (void)setColorIndex:(NSInteger)colorIndex
{
    _colorIndex = colorIndex;
    if (self.isViewLoaded) {
        OMMutiableLightColorView *view = [self.viewArray objectAtIndex:colorIndex];
        view.selected = YES;
    }
}

- (void)rightButtonClick:(UIButton *)button
{
    [OMGlobleManager changeColorLightColor:@[self.roomDevice.roomDeviceID, @(self.colorIndex + 1)] inView:self.view block:^(NSArray *array) {
        if ([[array firstObject] isEqualToString:@"01"]) {
            if (self.block) {
                self.block(self.colorIndex + 1);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end


@interface OMMutiableLightColorView()

@property (strong, nonatomic) UIView *view;

@end

@implementation OMMutiableLightColorView

- (void)initView
{
    self.selected = NO;
    self.view = [[UIView alloc] init];
    [self addSubview:self.view];
}

- (void)addAutoLayout
{
    self.view.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(MarginFactor(5.0f), MarginFactor(5.0f), MarginFactor(5.0f), MarginFactor(5.0f)));
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.view.backgroundColor = color;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
