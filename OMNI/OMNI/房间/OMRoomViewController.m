//
//  OMRoomViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/2.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoomViewController.h"
#import "OMRoomCollectionViewCell.h"
#import "OMRoomCollectionViewFlowLayout.h"

@interface OMRoomViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) OMRoomCollectionViewFlowLayout *collectionViewFlowLayout;

@property (assign, nonatomic) NSInteger roomCount;
@property (strong, nonatomic) NSMutableArray *roomArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *currentArray;


@end

@implementation OMRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_add_device_normal"] highlightedImage:[UIImage imageNamed:@"button_add_device_normal_down"]];

    self.collectionViewFlowLayout = [[OMRoomCollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OMRoomCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"OMRoomCollectionViewCell"];

    self.imageView.contentMode = UIViewContentModeScaleToFill;

    self.tableHeaderView.clipsToBounds = YES;
    [self.tableHeaderView addSubview:self.collectionView];

    self.tableView.tableHeaderView = self.tableHeaderView;

    self.roomArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.currentArray = [NSMutableArray array];
}

- (void)addAutoLayout
{
    self.tableHeaderView.sd_layout
    .heightIs(SCREENHEIGHT / 2.0f);

    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)loadData
{
    WEAK(self, weakSelf);
    [OMGlobleManager readRoomsInView:self.view block:^(NSArray *array) {
        weakSelf.roomCount = [[array firstObject] integerValue] + 1;
        for (NSInteger i = 1; i < (array.count + 1) / 2; i++) {
            OMRoom *room = [[OMRoom alloc] init];
            room.roomName = [array objectAtIndex:i * 2];
            room.roomIndex = [[array objectAtIndex:i * 2 - 1] integerValue];
            [weakSelf.roomArray addObject:room];
        }
        //最后创建一个假的
        OMRoom *room = [[OMRoom alloc] init];
        room.roomName = @"";
        room.roomIndex = ceill(array.count / 2);
        [weakSelf.roomArray addObject:room];


        [OMGlobleManager readDevicesInView:weakSelf.view block:^(NSArray *array) {

        }];
    }];

}

- (void)setDevice:(OMDevice *)device
{
    _device = device;
    kAppDelegate.deviceID = device.deviceID;
}

#pragma mark ------tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark ------collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OMRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMRoomCollectionViewCell" forIndexPath:indexPath];
    cell.room = [self.roomArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld行", indexPath.item);
}

//使前后项都能居中显示
- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGSize size = self.collectionViewFlowLayout.itemSize;
    UIEdgeInsets inSet = UIEdgeInsetsMake(0, (collectionView.bounds.size.width - size.width) / 2, 0, (collectionView.bounds.size.width - size.width) / 2);
    return inSet;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    __block CGFloat offsetAdjustment = MAXFLOAT;
    __block NSIndexPath *indexPath = nil;
    CGFloat horizontalCenter = CGRectGetWidth(self.collectionView.bounds) / 2.0f;
    NSArray *array = [self.collectionView visibleCells];
    [array enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *path = [self.collectionView indexPathForCell:cell];
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        CGFloat itemHorizontalCenter = attributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            indexPath = path;
        }
    }];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
