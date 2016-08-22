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
#import "OMSwitchViewController.h"
#import "OMSingleLightViewController.h"
#import "OMDoubleLightViewController.h"
#import "OMMutibleLightViewController.h"
#import "OMFannerViewController.h"
#import "OMCurtainViewController.h"

@interface OMRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet OMRoomCollectionViewFlowLayout *collectionViewFlowLayout;

@property (assign, nonatomic) NSInteger roomCount;

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
}


- (void)addAutoLayout
{
    self.collectionView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(5.0f))
    .rightSpaceToView(self.view, MarginFactor(5.0f))
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
    if (kAppDelegate.currentRoom.roomName.length > 0 && currentDeviceArray.count == 0) {
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
    for (NSMutableDictionary *dictionary in kAppDelegate.roomArray) {
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
    [kAppDelegate.roomArray removeAllObjects];

    [OMGlobleManager readRoomsInView:self.view block:^(NSArray *array) {
        if (array.count >= 1 && [[array firstObject] isEqualToString:@"OFFLINE"]) {
            return;
        }
        weakSelf.roomCount = [[array firstObject] integerValue] + 1;
        for (NSInteger i = 0; i < [[array firstObject] integerValue]; i++) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary addRoomProperty];
            OMRoom *room = [dictionary objectForKey:@"room"];
            room.roomNumber = [array objectAtIndex:i * 2 + 1];
            room.roomName = [array objectAtIndex:i * 2 + 2];

            [kAppDelegate.roomArray addObject:dictionary];
        }
        //最后创建一个假的
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary addRoomProperty];
        OMRoom *room = [dictionary objectForKey:@"room"];
        room.roomName = @"";
        room.roomNumber = [NSString stringWithFormat:@"%ld", (long)weakSelf.roomCount];
        [kAppDelegate.roomArray addObject:dictionary];

        [weakSelf.collectionView reloadData];

        [OMGlobleManager readRoomDevicesInView:weakSelf.view block:^(NSArray *array) {
            NSInteger roomDeviceCount = [[array firstObject] integerValue];
            for (NSInteger i = 0; i < roomDeviceCount; i++) {
                OMRoomDevice *roomDevice = [[OMRoomDevice alloc] init];
                roomDevice.roomDeviceID = [array objectAtIndex:i * 6 + 1];
                roomDevice.roomDeviceName = [array objectAtIndex:i * 6 + 2];
                roomDevice.roomNumber = [array objectAtIndex:i * 6 + 3];
                roomDevice.roomDeviceType = [[array objectAtIndex:i * 6 + 4] integerValue];
                roomDevice.roomDeviceFlag = [array objectAtIndex:i * 6 + 5];
                roomDevice.roomDeviceState = [[array objectAtIndex:i * 6 + 6] isEqualToString:@"1"];

                NSMutableDictionary *dictionary = [weakSelf dictionaryWithRoomNumber:roomDevice.roomNumber];
                NSMutableArray *roomDeviceArray = [dictionary objectForKey:@"roomDeviceArray"];
                [roomDeviceArray addObject:roomDevice];
            }
            kAppDelegate.currentRoom = [[kAppDelegate.roomArray firstObject] objectForKey:@"room"];
            weakSelf.currentDeviceArray = [[kAppDelegate.roomArray firstObject] objectForKey:@"roomDeviceArray"];
        }];
    }];

}

- (void)rightButtonClick:(UIButton *)button
{
    if (kAppDelegate.currentRoom.roomName.length > 0) {
        OMAddRoomDeviceViewController *controller = [[OMAddRoomDeviceViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else{
        OMAddRoomViewController *controller = [[OMAddRoomViewController alloc] init];
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
    cell.controller = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMRoomDevice *roomDevice = [self.currentDeviceArray objectAtIndex:indexPath.row];
    if (roomDevice.roomDeviceType == OMRoomDeviceTypeSwitch) {
        OMSwitchViewController *controller = [[OMSwitchViewController alloc] init];
        controller.roomDevice = roomDevice;
        controller.tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (roomDevice.roomDeviceType == OMRoomDeviceTypeSinglelight) {
        OMSingleLightViewController *controller = [[OMSingleLightViewController alloc] init];
        controller.roomDevice = roomDevice;
        controller.tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (roomDevice.roomDeviceType == OMRoomDeviceTypeDoublelight) {
        OMDoubleLightViewController *controller = [[OMDoubleLightViewController alloc] init];
        controller.roomDevice = roomDevice;
        controller.tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (roomDevice.roomDeviceType == OMRoomDeviceTypeMutablelight) {
        OMMutibleLightViewController *controller = [[OMMutibleLightViewController alloc] init];
        controller.roomDevice = roomDevice;
        controller.tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (roomDevice.roomDeviceType == OMRoomDeviceTypeFan) {
        OMFannerViewController *controller = [[OMFannerViewController alloc] init];
        controller.roomDevice = roomDevice;
        controller.tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (roomDevice.roomDeviceType == OMRoomDeviceTypeCurtain) {
        OMCurtainViewController *controller = [[OMCurtainViewController alloc] init];
        controller.roomDevice = roomDevice;
        controller.tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else{
        OMAddRoomDeviceViewController *controller = [[OMAddRoomDeviceViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark ------collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OMRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMRoomCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dictionary = [kAppDelegate.roomArray objectAtIndex:indexPath.item];
    cell.room = [dictionary objectForKey:@"room"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OMAddRoomViewController *controller = [[OMAddRoomViewController alloc] init];
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

        kAppDelegate.currentRoom = [[kAppDelegate.roomArray objectAtIndex:indexPath.item] objectForKey:@"room"];
        self.currentDeviceArray = [[kAppDelegate.roomArray objectAtIndex:indexPath.item] objectForKey:@"roomDeviceArray"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
