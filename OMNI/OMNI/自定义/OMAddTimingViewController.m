//
//  OMAddTimingViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddTimingViewController.h"
#import "NSArray+Extend.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"

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
    [self.thirdSubView addLeftTitle:@"End"];

    if (!self.timeString) {
        NSDictionary *dictionary = [NSArray calculationNowTime];
        NSString *string = [NSString stringWithFormat:@"%@/%@/%@ %@:%@ %@", [dictionary objectForKey:@"month"], [dictionary objectForKey:@"day"], [dictionary objectForKey:@"year"], [dictionary objectForKey:@"hh"], [dictionary objectForKey:@"mm"], [NSArray ObtainWeek:[dictionary objectForKey:@"day"] andMonth:[dictionary objectForKey:@"month"] andYear:[dictionary objectForKey:@"year"]]];

        [self.secondSubView addRightTitle:string];
        [self.thirdSubView addRightTitle:string];
    }
    
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
    [[recognizer1 rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {

    }];
    [self.firstSubView addGestureRecognizer:recognizer1];

    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] init];

    [[recognizer2 rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        [self view:self.secondSubView showPickerView:YES];
    }];
    [self.secondSubView addGestureRecognizer:recognizer2];

    UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] init];
    [[recognizer3 rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        [self view:self.thirdSubView showPickerView:YES];
    }];
    [self.thirdSubView addGestureRecognizer:recognizer3];

}

- (void)view:(OMAddTimingSubView *)view showPickerView:(BOOL)animated
{
    __block BOOL hasPickerView = NO;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[OMAddTimingPickerContentView class]]) {
            hasPickerView = YES;
            [UIView animateWithDuration:0.25f animations:^{
                obj.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [obj removeFromSuperview];
            }];
        }
    }];

    if (!hasPickerView) {
        OMAddTimingPickerContentView *pickerView = [[OMAddTimingPickerContentView alloc] init];
        pickerView.alpha = 0.0f;
        pickerView.timeString = [NSDate stringFromDate:[view date]];
        pickerView.block = ^(NSString *string){
            [view addRightTitle:string];
            if ([[self.secondSubView date] compare:[self.thirdSubView date]] != NSOrderedAscending) {
                [self.secondSubView setTitleColor:[UIColor redColor]];
                [self.thirdSubView setTitleColor:[UIColor redColor]];
            } else{
                [self.secondSubView setTitleColor:Color(@"537525")];
                [self.thirdSubView setTitleColor:Color(@"537525")];
            }
        };
        [self.view addSubview:pickerView];
        pickerView.sd_layout
        .leftEqualToView(self.topView)
        .rightEqualToView(self.topView)
        .topEqualToView(self.bottomView)
        .offset([view isEqual:self.secondSubView] ? CGRectGetHeight(self.secondSubView.frame) : CGRectGetHeight(self.bottomView.frame));
        [UIView animateWithDuration:0.25f animations:^{
            pickerView.alpha = 1.0f;
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[OMAddTimingPickerContentView class]]) {
            [UIView animateWithDuration:0.25f animations:^{
                obj.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [obj removeFromSuperview];
            }];
        }
    }];
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

- (NSDate *)date
{
    NSInteger index = [self.rightLabel.text rangeOfString:@":"].location + 4;
    NSString *string = [self.rightLabel.text substringToIndex:index];
    return [NSDate convertDateFromString:string];
}

- (void)setTitleColor:(UIColor *)color
{
    self.rightLabel.textColor = color;
}

@end


@interface OMAddTimingPickerContentView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *middleImageView;
@property (strong, nonatomic) OMAddTimingPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *componentArray;

@property (strong, nonatomic) NSArray *monthArray;
@property (strong, nonatomic) NSArray *dayArray;
@property (strong, nonatomic) NSArray *yearArray;
@property (strong, nonatomic) NSArray *hourArray;
@property (strong, nonatomic) NSArray *minArray;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSString *currentYear;
@property (strong, nonatomic) NSString *currentMon;
@property (strong, nonatomic) NSString *currentDay;
@property (strong, nonatomic) NSString *currentHour;
@property (strong, nonatomic) NSString *currentMin;

@property (assign, nonatomic) BOOL needRefresh;

@end

@implementation OMAddTimingPickerContentView

- (void)initView
{
    self.bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"choose_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f) resizingMode:UIImageResizingModeStretch]];
    self.middleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_bg"]];

    self.pickerView = [[OMAddTimingPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;

    [self sd_addSubviews:@[self.bgImageView, self.middleImageView]];
}

- (void)addAutoLayout
{
    self.bgImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.middleImageView.sd_layout
    .leftSpaceToView(self, MarginFactor(5.0f))
    .rightSpaceToView(self, MarginFactor(5.0f))
    .topSpaceToView(self, MarginFactor(20.0f))
    .heightIs(216.0f);

    WEAK(self, weakSelf);
    __block CGRect frame = self.middleImageView.frame;
    self.middleImageView.didFinishAutoLayoutBlock = ^(CGRect rect){
        if (!CGRectEqualToRect(frame, rect)) {
            frame = rect;
            weakSelf.pickerView.frame = rect;
            [weakSelf addSubview:weakSelf.pickerView];
            [weakSelf selectDefault];
        }
    };

    [self setupAutoHeightWithBottomView:self.middleImageView bottomMargin:MarginFactor(10.0f)];
}

- (void)selectDefault
{
    NSInteger index = [self.monthArray indexOfObject:self.currentMon];
    [self.pickerView selectRow:index inComponent:0 animated:NO];

    index = [self.dayArray indexOfObject:self.currentDay];
    [self.pickerView selectRow:index inComponent:1 animated:NO];

    index = [self.yearArray indexOfObject:self.currentYear];
    [self.pickerView selectRow:index inComponent:2 animated:NO];

    index = [self.hourArray indexOfObject:self.currentHour];
    [self.pickerView selectRow:index inComponent:3 animated:NO];

    index = [self.minArray indexOfObject:self.currentMin];
    [self.pickerView selectRow:index inComponent:4 animated:NO];
}

- (void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    NSArray *array = [timeString componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@"/", @" ", @":"]]];

    self.currentMon = [array objectAtIndex:0];
    self.currentDay = [array objectAtIndex:1];
    self.currentYear = [array objectAtIndex:2];
    self.currentHour = [array objectAtIndex:3];
    self.currentMin = [array objectAtIndex:4];

    self.yearArray = [NSArray calculationYear];
    self.monthArray = [NSArray calculationMonth];
    self.hourArray = [NSArray calculationHH];
    self.minArray = [NSArray calculationMM];
    self.dayArray = [NSArray calculationDay:self.currentYear andMonth:self.currentMon];

    self.dataArray = [NSMutableArray arrayWithArray:@[self.monthArray, self.dayArray, self.yearArray, self.hourArray, self.minArray]];

    self.numberOfComponents = self.dataArray.count;

}

- (void)setNumberOfComponents:(NSInteger)numberOfComponents
{
    _numberOfComponents = numberOfComponents;
    if (!self.componentArray) {
        self.componentArray = [NSMutableArray array];
    }
    [self.componentArray removeAllObjects];

    for (NSInteger i = 0; i < numberOfComponents; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_component"]];
        [self.componentArray addObject:imageView];
    }
}

- (void)setCurrentYear:(NSString *)currentYear
{
    _currentYear = currentYear;
    if (self.needRefresh) {
        self.dayArray = [NSArray calculationDay:currentYear andMonth:self.currentMon];
        [self.dataArray replaceObjectAtIndex:1 withObject:self.dayArray];
        [self.pickerView reloadComponent:1];
    }
}

- (void)setCurrentMon:(NSString *)currentMon
{
    _currentMon = currentMon;
    if (self.needRefresh) {
        self.dayArray = [NSArray calculationDay:self.currentYear andMonth:currentMon];
        [self.dataArray replaceObjectAtIndex:1 withObject:self.dayArray];
        [self.pickerView reloadComponent:1];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((NSArray *)[self.dataArray objectAtIndex:component]).count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return ceilf(CGRectGetWidth(self.middleImageView.frame) / self.numberOfComponents) - MarginFactor(5.0f);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    NSString *string = [[self.dataArray objectAtIndex:component] objectAtIndex:row];
    if (component == 0) {
        string = [NSString stringWithFormat:@"%@月",string];
    } else if (component == 1){
        string = [NSString stringWithFormat:@"%@日",string];
    } else if (component == 1){
        string = [NSString stringWithFormat:@"%@年",string];
    }
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FontFactor(15.0f)}];
    label.attributedText = text;
    [label sizeToFit];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.needRefresh = YES;
    NSArray *array = [self.dataArray objectAtIndex:component];
    NSString *string = [array objectAtIndex:row];
    switch (component) {
        case 0:
            self.currentMon = string;
            break;
        case 1:
            self.currentDay = string;
            break;
        case 2:
            self.currentYear = string;
            break;
        case 3:
            self.currentHour = string;
            break;
        case 4:
            self.currentMin = string;
            break;
        default:
            break;
    }
    if (self.block) {
        NSString *string = [NSString stringWithFormat:@"%@/%@/%@ %@:%@ %@", self.currentMon, self.currentDay, self.currentYear, self.currentHour, self.currentMin, [NSArray ObtainWeek:self.currentDay andMonth:self.currentMon andYear:self.currentYear]];
        self.block(string);
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

@end

@interface OMAddTimingPickerView()

@end

@implementation OMAddTimingPickerView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectGetHeight(obj.frame) < 1.0f) {
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
}

@end




