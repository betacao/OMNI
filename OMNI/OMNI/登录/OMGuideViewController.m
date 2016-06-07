//
//  OMGuideViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/2.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMGuideViewController.h"

@interface OMGuideViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *urlArray;

@end

@implementation OMGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"User guide";
}

- (void)initView
{
    self.titleArray = @[@"About gateway", @"Gateway setting", @"Add a room", @"Add a device", @"Preset mission", @"Pannel pairing"];
    self.urlArray = @[@"http://www.baidu.com", @"http://www.baidu.com", @"http://www.baidu.com", @"http://www.baidu.com", @"http://www.baidu.com", @"http://www.baidu.com"];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(10.0f))
    .rightSpaceToView(self.view, MarginFactor(10.0f))
    .topSpaceToView(self.view, MarginFactor(20.0f))
    .heightIs(self.titleArray.count * MarginFactor(55.0f));

    self.tableView.sd_cornerRadius = @(5);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(55.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMGuideTableViewCell"];
    if (!cell) {
        cell = [[OMGuideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMGuideTableViewCell"];
    }
    cell.object = [self.titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.urlArray objectAtIndex:indexPath.row];
    NSLog(@"%@",string);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

@interface OMGuideTableViewCell()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIImageView *spliteView;

@end

@implementation OMGuideTableViewCell

- (void)initView
{
    self.backgroundColor = self.contentView.backgroundColor = Color(@"0");
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_arrow"]];
    self.nameLabel = [[UILabel alloc] init];
    self.spliteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_type_line"]];
    [self.contentView sd_addSubviews:@[self.arrowImageView, self.nameLabel, self.spliteView]];
    self.nameLabel.font = FontFactor(15.0f);
    self.nameLabel.textColor = [UIColor lightGrayColor];

}

- (void)addAutoLayout
{
    self.nameLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, MarginFactor(10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.arrowImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(10.0f))
    .widthIs(self.arrowImageView.image.size.width)
    .heightIs(self.arrowImageView.image.size.height);

    self.spliteView.sd_layout
    .bottomSpaceToView(self.contentView, 0.0f)
    .leftEqualToView(self.nameLabel)
    .rightEqualToView(self.arrowImageView)
    .heightIs(self.spliteView.image.size.height);
}

- (void)setObject:(NSString *)object
{
    _object = object;
    self.nameLabel.text = object;
}

@end
