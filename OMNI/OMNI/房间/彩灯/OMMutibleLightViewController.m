//
//  OMMutibleLightViewController.m
//  
//
//  Created by changxicao on 16/8/2.
//
//

#import "OMMutibleLightViewController.h"
#import "OMEditRoomDeviceViewController.h"
#import "OMAlarmView.h"
#import "OMMutibleSlider.h"

@interface OMMutibleLightViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet OMMutibleSlider *slider;

@end

@implementation OMMutibleLightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
}

- (void)initView
{
    self.title = @"Bicolor Light";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];
    self.slider.roomDevice = self.roomDevice;
    self.slider.tableViewCell = self.tableViewCell;
    [self.view addSubview:[OMAlarmView sharedAlarmView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.slider.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)rightButtonClick:(UIButton *)button
{
    OMEditRoomDeviceViewController *controller = [[OMEditRoomDeviceViewController alloc] init];
    controller.roomDevice = self.roomDevice;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
