//
//  OMAddTimingViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddTimingViewController.h"

@interface OMAddTimingViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet OMAddTimingSubView *firstSubView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet OMAddTimingSubView *secondSubView;
@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet OMAddTimingSubView *thirdSubView;


@end

@implementation OMAddTimingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)initView
{
    self.title = @"Add Timing";

    self.topView.backgroundColor = self.bottomView.backgroundColor = [UIColor clearColor];

    UIImage *image = [[UIImage imageNamed:@"choose_device_type"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
    self.topImageView.image = self.bottomImageView.image = image;

    [self.firstSubView addLeftTitle:@"Repeat"];
    [self.firstSubView addRightTitle:@"Never"];

    [self.secondSubView addLeftTitle:@"Start"];
    [self.secondSubView addRightTitle:@""];

    [self.thirdSubView addLeftTitle:@"End"];
    [self.thirdSubView addRightTitle:@""];

    self.spliteView.backgroundColor = [UIColor lightGrayColor];
}

- (void)addAutoLayout
{
    self.topView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(15.0f))
    .rightSpaceToView(self.view, MarginFactor(15.0f))
    .topSpaceToView(self.view, MarginFactor(15.0f))
    .heightIs(MarginFactor(60.0f));

    self.topImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.firstSubView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.bottomView.sd_layout
    .leftEqualToView(self.topView)
    .rightEqualToView(self.topView)
    .topSpaceToView(self.topView, MarginFactor(30.0f));

    self.bottomImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.secondSubView.sd_layout
    .leftSpaceToView(self.bottomView, 0.0f)
    .rightSpaceToView(self.bottomView, 0.0f)
    .topSpaceToView(self.bottomView, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.spliteView.sd_layout
    .leftEqualToView(self.secondSubView)
    .rightEqualToView(self.secondSubView)
    .topSpaceToView(self.secondSubView, 0.0f)
    .heightIs(1 / SCALE);

    self.thirdSubView.sd_layout
    .leftEqualToView(self.secondSubView)
    .rightEqualToView(self.secondSubView)
    .topSpaceToView(self.spliteView, 0.0f)
    .heightIs(MarginFactor(60.0f));

    [self.bottomView setupAutoHeightWithBottomView:self.thirdSubView bottomMargin:0.0f];
}

- (void)addReactiveCocoa
{
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] init];
    [[recognizer1 rac_gestureSignal] subscribeNext:^(id x) {

    }];
    [self.firstSubView addGestureRecognizer:recognizer1];

    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] init];
    [[recognizer2 rac_gestureSignal] subscribeNext:^(id x) {

    }];
    [self.secondSubView addGestureRecognizer:recognizer2];

    UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] init];
    [[recognizer3 rac_gestureSignal] subscribeNext:^(id x) {

    }];
    [self.thirdSubView addGestureRecognizer:recognizer3];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@interface OMAddTimingSubView()

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation OMAddTimingSubView

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.textColor = Color(@"537525");
    self.leftLabel.font = FontFactor(16.0f);

    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = Color(@"537525");
    self.rightLabel.font = FontFactor(13.0f);

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_arrow"]];

    [self sd_addSubviews:@[self.leftLabel, self.rightLabel, self.imageView]];
}

- (void)addAutoLayout
{
    self.leftLabel.sd_layout
    .leftSpaceToView(self, MarginFactor(15.0f))
    .centerYEqualToView(self)
    .heightIs(self.leftLabel.font.lineHeight);
    [self.leftLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.imageView.sd_layout
    .rightSpaceToView(self, MarginFactor(15.0f))
    .centerYEqualToView(self)
    .widthIs(self.imageView.image.size.width)
    .heightIs(self.imageView.image.size.height);

    self.rightLabel.sd_layout
    .rightSpaceToView(self.imageView, MarginFactor(15.0f))
    .centerYEqualToView(self)
    .heightIs(self.rightLabel.font.lineHeight);
    [self.rightLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
    

}

- (void)addLeftTitle:(NSString *)title
{
    self.leftLabel.text = title;
}

- (void)addRightTitle:(NSString *)title
{
    self.rightLabel.text = title;
}


@end
