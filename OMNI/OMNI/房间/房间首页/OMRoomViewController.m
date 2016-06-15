//
//  OMRoomViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/6.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoomViewController.h"
#import "OMRoomCollectionViewCell.h"
#import "OMRoomCollectionViewFlowLayout.h"
#import "OMRoomTableViewCell.h"
#import "NSMutableDictionary+Room.h"
#import "OMAddRoomDeviceViewController.h"
#import "OMAddRoomViewController.h"

@interface OMRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet OMRoomCollectionViewFlowLayout *collectionViewFlowLayout;

@property (assign, nonatomic) NSInteger roomCount;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) OMRoom *currentRoom;
@property (strong, nonatomic) NSMutableArray *currentDeviceArray;


@end

@implementation OMRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_add_device_normal"] highlightedImage:[UIImage imageNamed:@"button_add_device_normal_down"]];
}

- (void)initView
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OMRoomCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"OMRoomCollectionViewCell"];
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 20.0f, 0.0f) resizingMode:UIImageResizingModeStretch]];

    self.tableView.bounces = NO;

    self.dataArray = [NSMutableArray array];
}


- (void)addAutoLayout
{
    self.collectionView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .heightIs(SCREENHEIGHT / 2.0f);

    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.collectionView, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

- (void)setDevice:(OMDevice *)device
{
    _device = device;
    kAppDelegate.deviceID = device.deviceID;
}

- (void)setCurrentDeviceArray:(NSMutableArray *)currentDeviceArray
{
    if (self.currentRoom.roomName.length > 0 && currentDeviceArray.count == 0) {
        OMRoomDevice *roomDevice = [[OMRoomDevice alloc] init];
        [currentDeviceArray addObject:roomDevice];
    }
    if (currentDeviceArray.count > 0) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_choose_device"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 20.0f, 0.0f) resizingMode:UIImageResizingModeStretch]];
    } else {
        self.tableView.backgroundView = nil;
    }

    _currentDeviceArray = [NSMutableArray arrayWithArray:currentDeviceArray];

    [self.tableView reloadData];
}


- (NSMutableDictionary *)dictionaryWithRoomNumber:(NSString *)roomNumber
{
    for (NSMutableDictionary *dictionary in self.dataArray) {
        OMRoom *room = [dictionary objectForKey:@"room"];
        if ([room.roomNumber isEqualToString:roomNumber]) {
            return dictionary;
        }
    }
    return nil;
}

- (void)loadData
{
    WEAK(self, weakSelf);
    [self.dataArray removeAllObjects];

    [OMGlobleManager readRoomsInView:self.view block:^(NSArray *array) {
        weakSelf.roomCount = [[array firstObject] integerValue] + 1;
        for (NSInteger i = 0; i < [[array firstObject] integerValue]; i++) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary addRoomProperty];
            OMRoom *room = [dictionary objectForKey:@"room"];
            room.roomNumber = [array objectAtIndex:i * 2 + 1];
            room.roomName = [array objectAtIndex:i * 2 + 2];

            [weakSelf.dataArray addObject:dictionary];
        }
        //最后创建一个假的
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary addRoomProperty];
        OMRoom *room = [dictionary objectForKey:@"room"];
        room.roomName = @"";
        room.roomNumber = [NSString stringWithFormat:@"%ld", (long)weakSelf.roomCount];
        [weakSelf.dataArray addObject:dictionary];

        [weakSelf.collectionView reloadData];

        [OMGlobleManager readDevicesInView:weakSelf.view block:^(NSArray *array) {
            NSInteger roomDeviceCount = [[array firstObject] integerValue];
            for (NSInteger i = 0; i < roomDeviceCount; i++) {
                OMRoomDevice *roomDevice = [[OMRoomDevice alloc] init];
                roomDevice.roomDeviceID = [array objectAtIndex:i * 6 + 1];
                roomDevice.roomDeviceName = [array objectAtIndex:i * 6 + 2];
                roomDevice.roomNumber = [array objectAtIndex:i * 6 + 3];
                roomDevice.roomDeviceType = [array objectAtIndex:i * 6 + 4];
                roomDevice.roomDeviceFlag = [array objectAtIndex:i * 6 + 5];
                roomDevice.roomDeviceState = [array objectAtIndex:i * 6 + 6];

                NSMutableDictionary *dictionary = [weakSelf dictionaryWithRoomNumber:roomDevice.roomNumber];
                NSMutableArray *roomDeviceArray = [dictionary objectForKey:@"roomDeviceArray"];
                [roomDeviceArray addObject:roomDevice];
            }
            weakSelf.currentRoom = [[weakSelf.dataArray firstObject] objectForKey:@"room"];
            weakSelf.currentDeviceArray = [[weakSelf.dataArray firstObject] objectForKey:@"roomDeviceArray"];
        }];
    }];

}

- (void)rightButtonClick:(UIButton *)button
{
    if (self.currentRoom.roomName.length > 0) {
        OMAddRoomDeviceViewController *controller = [[OMAddRoomDeviceViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else{
        OMAddRoomViewController *controller = [[OMAddRoomViewController alloc] init];
        controller.room = self.currentRoom;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

#pragma mark ------tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentDeviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(60.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMRoomTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OMRoomTableViewCell" owner:self options:nil] firstObject];
    }
    cell.roomDevice = [self.currentDeviceArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMAddRoomDeviceViewController *controller = [[OMAddRoomDeviceViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark ------collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OMRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMRoomCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.item];
    cell.room = [dictionary objectForKey:@"room"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OMAddRoomViewController *controller = [[OMAddRoomViewController alloc] init];
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.item];
    controller.room = [dictionary objectForKey:@"room"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.collectionView]) {
        __block CGFloat offsetAdjustment = MAXFLOAT;
        __block NSIndexPath *indexPath = nil;
        CGFloat horizontalCenter = CGRectGetWidth(self.collectionView.bounds) / 2.0f + scrollView.contentOffset.x;
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

        self.currentRoom = [[self.dataArray objectAtIndex:indexPath.item] objectForKey:@"room"];
        self.currentDeviceArray = [[self.dataArray objectAtIndex:indexPath.item] objectForKey:@"roomDeviceArray"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
