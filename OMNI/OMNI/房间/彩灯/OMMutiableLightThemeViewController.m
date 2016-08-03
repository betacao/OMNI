//
//  OMMutiableLightThemeViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMMutiableLightThemeViewController.h"

@interface OMMutiableLightThemeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation OMMutiableLightThemeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    self.title = @"Scene";
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];

    self.dataArray = @[@"happy", @"dinner", @"gardon", @"romantic", @"rock", @"winter night"];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"choose_device_type"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeStretch]];

    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.theme inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(MarginFactor(15.0f), MarginFactor(15.0f), MarginFactor(15.0f), MarginFactor(15.0f)));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(60.0f);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.theme - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMMutiableLightThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMMutiableLightThemeCell"];
    if (!cell) {
        cell = [[OMMutiableLightThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMAddRoomDeviceTableViewCell"];
    }
    cell.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.theme = indexPath.row + 1;
}

- (void)rightButtonClick:(UIButton *)button
{
    [OMGlobleManager changeColorLightTheme:@[self.roomDevice.roomDeviceID, @(self.theme)] inView:self.view block:^(NSArray *array) {
        if ([[array firstObject] isEqualToString:@"01"]) {
            if (self.block) {
                self.block(self.theme);
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

@interface OMMutiableLightThemeCell()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImageView *spliteView;

@end

@implementation OMMutiableLightThemeCell

- (void)initView
{
    self.nameLabel = [[UILabel alloc] init];
    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_type_tick"]];
    self.spliteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_type_line"]];
    [self.contentView sd_addSubviews:@[self.nameLabel, self.selectedImageView, self.spliteView]];

    self.contentView.backgroundColor = self.backgroundColor = Color(@"0");
    self.nameLabel.textColor = Color(@"64a23f");
    self.nameLabel.font = BoldFontFactor(15.0f);
    self.selectedImageView.hidden = YES;
}

- (void)addAutoLayout
{
    self.nameLabel.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, MarginFactor(10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.selectedImageView.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .widthIs(self.selectedImageView.image.size.width)
    .heightIs(self.selectedImageView.image.size.height);

    self.spliteView.sd_layout
    .bottomSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(self.spliteView.image.size.height);
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.nameLabel.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedImageView.hidden = !selected;
}

@end
