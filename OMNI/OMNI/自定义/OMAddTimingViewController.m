//
//  OMAddTimingViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddTimingViewController.h"
#import "OMAlarmView.h"
#import "NSArray+Extend.h"
#import "NSDate+Extend.h"

@interface OMAddTimingViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet OMAddTimingSubView *firstSubView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet OMAddTimingSubView *secondSubView;
@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet OMAddTimingSubView *thirdSubView;


@property (strong, nonatomic) NSArray *periodArray;

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

    self.periodArray = @[@"Never", @"Every Day", @"Every Week", @"Every Month"];
    self.topView.backgroundColor = self.bottomView.backgroundColor = [UIColor clearColor];

    UIImage *image = [[UIImage imageNamed:@"choose_device_type"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
    self.topImageView.image = self.bottomImageView.image = image;

    [self.firstSubView addLeftTitle:@"Repeat"];
    [self.secondSubView addLeftTitle:@"Start"];
    [self.thirdSubView addLeftTitle:@"End"];

    if (!self.alarm) {
        NSDictionary *dictionary = [NSArray calculationNowTime];
        NSString *string = [NSString stringWithFormat:@"%@/%@/%@ %@:%@ %@", [dictionary objectForKey:@"month"], [dictionary objectForKey:@"day"], [dictionary objectForKey:@"year"], [dictionary objectForKey:@"hh"], [dictionary objectForKey:@"mm"], [NSArray ObtainWeek:[dictionary objectForKey:@"day"] andMonth:[dictionary objectForKey:@"month"] andYear:[dictionary objectForKey:@"year"]]];

        [self.firstSubView addRightTitle:[self.periodArray firstObject]];
        [self.secondSubView addRightTitle:string];
        [self.thirdSubView addRightTitle:string];
    } else {
        OMAlarmPeriodType type = self.alarm.periodType;
        [self.firstSubView addRightTitle:[self.periodArray objectAtIndex:type]];
        NSString *fromTime = [NSDate stringFromDate:self.alarm.fromTime format:@"MM/dd/yyyy HH:mm"];
        NSArray *fromArray = [fromTime componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@" ", @":", @"/"]]];

        NSString *fromWeek = [NSArray ObtainWeek:[fromArray objectAtIndex:1] andMonth:[fromArray objectAtIndex:0] andYear:[fromArray objectAtIndex:2]];

        NSString *toTime = [NSDate stringFromDate:self.alarm.toTime format:@"MM/dd/yyyy HH:mm"];
        NSArray *toArray = [fromTime componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@" ", @":", @"/"]]];
        NSString *toWeek = [NSArray ObtainWeek:[fromArray objectAtIndex:1] andMonth:[toArray objectAtIndex:0] andYear:[toArray objectAtIndex:2]];

        fromTime = [fromTime stringByAppendingFormat:@" %@", fromWeek];
        toTime = [toTime stringByAppendingFormat:@" %@", toWeek];

        [self.secondSubView addRightTitle:fromTime];
        [self.thirdSubView addRightTitle:toTime];
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
    //点击选择周期
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] init];
    [[recognizer1 rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        OMAddTimingPeriodViewController *controller = [[OMAddTimingPeriodViewController alloc] init];
        controller.periodArray = self.periodArray;
        controller.defaultPeriod = [self.firstSubView rightText];
        WEAK(self, weakSelf);
        controller.block = ^(NSString *period){
            [weakSelf.firstSubView addRightTitle:period];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.firstSubView addGestureRecognizer:recognizer1];

    //点击选择开始时间
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] init];

    [[recognizer2 rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        [self view:self.secondSubView showPickerView:YES];
    }];
    [self.secondSubView addGestureRecognizer:recognizer2];

    //点击选择截止时间
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
        pickerView.timeString = [NSDate stringFromDate:[view date] format:nil];
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

- (void)rightButtonClick:(UIButton *)button
{
    NSArray *startArray = [[NSDate stringFromDate:[self.secondSubView date] format:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@"/", @" ", @":"]]];
    NSArray *endArray = [[NSDate stringFromDate:[self.thirdSubView date] format:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@"/", @" ", @":"]]];
    NSInteger index = [[self.secondSubView rightText] rangeOfString:@":"].location + 4;
    NSString *weekDay = [[self.secondSubView rightText] substringFromIndex:index];

    WEAK(self, weakSelf);
    if (!self.alarm) {
        [OMGlobleManager addTimeTask:@[@(self.roomDevice.roomDeviceType), self.roomDevice.roomDeviceID, @([self.periodArray indexOfObject:[self.firstSubView rightText]]), [startArray firstObject], [startArray objectAtIndex:1], [startArray objectAtIndex:2], [startArray objectAtIndex:3], [startArray objectAtIndex:4], [endArray firstObject], [endArray objectAtIndex:1], [endArray objectAtIndex:2], [endArray objectAtIndex:3], [endArray objectAtIndex:4], weekDay] inView:self.view block:^(NSArray *array) {
            if ([[array firstObject] containsString:@"01"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[OMAlarmView sharedAlarmView] loadData];
            }
        }];
    } else{
        [OMGlobleManager editTimeTask:@[@([self.periodArray indexOfObject:[self.firstSubView rightText]]), self.alarm.alarmID, [startArray firstObject], [startArray objectAtIndex:1], [startArray objectAtIndex:2], [startArray objectAtIndex:3], [startArray objectAtIndex:4], [endArray firstObject], [endArray objectAtIndex:1], [endArray objectAtIndex:2], [endArray objectAtIndex:3], [endArray objectAtIndex:4], weekDay] inView:self.view block:^(NSArray *array) {
            if ([[array firstObject] containsString:@"01"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[OMAlarmView sharedAlarmView] loadData];
            }
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

- (NSDate *)date
{
    NSInteger index = [self.rightLabel.text rangeOfString:@":"].location + 4;
    NSString *string = [self.rightLabel.text substringToIndex:index];
    return [NSDate convertDateFromString:string format: @"MM/dd/yyyy HH:mm"];
}

- (void)addLeftTitle:(NSString *)title
{
    self.leftLabel.text = title;
}

- (void)addRightTitle:(NSString *)title
{
    self.rightLabel.text = title;
}

- (NSString *)rightText
{
    return self.rightLabel.text;
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

    self.currentYear = [array objectAtIndex:0];
    self.currentMon = [array objectAtIndex:1];
    self.currentDay = [array objectAtIndex:2];
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




@interface OMAddTimingPeriodViewController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation OMAddTimingPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Timing";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

- (void)initView
{
    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(17.0f);
    self.label.textColor = [UIColor whiteColor];
    self.label.text = @"How often you want to run?";
    self.label.textAlignment = NSTextAlignmentCenter;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIImage *image = [[UIImage imageNamed:@"choose_device_type"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];

    [self.view sd_addSubviews:@[self.label, self.tableView]];
}

- (void)addAutoLayout
{
    self.label.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(64.0f));

    self.tableView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(15.0f))
    .rightSpaceToView(self.view, MarginFactor(15.0f))
    .topSpaceToView(self.label, 0.0f)
    .heightIs(MarginFactor(64.0f) * 4.0f);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.periodArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(64.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMAddTimePeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMAddTimePeriodTableViewCell"];
    if (!cell) {
        cell = [[OMAddTimePeriodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMAddTimePeriodTableViewCell"];
    }
    cell.text = [self.periodArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *text = [self.periodArray objectAtIndex:indexPath.row];
    if ([text isEqualToString:self.defaultPeriod]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block([self.periodArray objectAtIndex:indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end



@interface OMAddTimePeriodTableViewCell()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *spliteView;
@property (strong, nonatomic) UIImageView *selectedImageView;

@end

@implementation OMAddTimePeriodTableViewCell

- (void)initView
{
    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(17.0f);
    self.label.textColor = Color(@"537525");

    self.spliteView = [[UIView alloc] init];
    self.spliteView.backgroundColor = [UIColor lightGrayColor];

    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_type_tick"]];

    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView sd_addSubviews:@[self.label, self.spliteView, self.selectedImageView]];
}

- (void)addAutoLayout
{
    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(10.0f))
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    self.label.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(15.0f))
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .bottomSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f);

    self.selectedImageView.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .widthIs(self.selectedImageView.image.size.width)
    .heightIs(self.selectedImageView.image.size.height);
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedImageView.hidden = !selected;
}

@end




























