//
//  OMAddRoomViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddRoomViewController.h"
#import "OMDrawerViewController.h"

@interface OMAddRoomViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign, nonatomic) BOOL thumbnailExist;

@end

@implementation OMAddRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (kAppDelegate.currentRoom.roomName.length > 0) {
        self.title = @"Edite Room";
        [self.button setImage:kAppDelegate.currentRoom.roomThumbnail forState:UIControlStateNormal];
        self.thumbnailExist = YES;
    } else{
        self.title = @"Add Room";
    }


    self.textField.text = kAppDelegate.currentRoom.roomName;

    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)initView
{
    [self.button setImage:[UIImage imageNamed:@"add_room"] forState:UIControlStateNormal];

    UIImage *image = self.textField.background;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.textField.background = image;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;

    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.scrollView]) {
            [self.scrollView addSubview:obj];
        }
    }];
}


- (void)addAutoLayout
{
    self.button.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.scrollView, MarginFactor(44.0f))
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

    self.textField.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(10.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(10.0f))
    .topSpaceToView(self.button, MarginFactor(44.0f))
    .heightIs(MarginFactor(40.0f));
}

- (void)addReactiveCocoa
{
    [[[self.textField rac_textSignal] filter:^BOOL(NSString *value) {
        return value.length > 32;
    }] subscribeNext:^(NSString *x) {
        self.textField.text = [x substringToIndex:32];
    }];

    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.thumbnailExist) {
            UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Delete pickture" destructiveButtonTitle:nil otherButtonTitles:@"Taking picture", @"From the photo album", nil];
            [takeSheet showInView:self.view];
        } else {
            UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Taking picture", @"From the photo album", nil];
            [takeSheet showInView:self.view];
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [self cameraClick];
    } else if (buttonIndex == 1){
        [self photosClick];
    } else if (buttonIndex == 2){
        if (self.thumbnailExist) {
            self.thumbnailExist = NO;
            [self.button setImage:[UIImage imageNamed:@"add_room"] forState:UIControlStateNormal];
        }
    }
}

- (void)cameraClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (void)photosClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.thumbnailExist = YES;
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.button setImage:image forState:UIControlStateNormal];
}

- (void)rightButtonClick:(UIButton *)button
{
    [self.textField resignFirstResponder];
    if (self.textField.text.length == 0) {
        [self.view showWithText:@"please enter room name"];
        return;
    }
    void(^block)(NSArray *array) = ^(NSArray *array) {
        if ([[array firstObject] isEqualToString:@"01"]) {
            [self.view showWithText:@"operation success"];
            for (OMBaseViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OMDrawerViewController class]]) {
                    OMBaseViewController *roomViewController = (OMBaseViewController *)((OMDrawerViewController *)controller).centerViewController;
                    [roomViewController loadData];
                    [self.navigationController performSelector:@selector(popToViewController:animated:) withObjects:@[controller, @(YES)] afterDelay:1.2f];
                }
            }
        }
    };
    if (kAppDelegate.currentRoom.roomName.length > 0) {
        UIImage *image = self.thumbnailExist ? self.button.currentImage : nil;
        [OMGloble writeRoomThumbnail:image forRoom:kAppDelegate.currentRoom];
        [OMGlobleManager editeRoom:@[kAppDelegate.currentRoom.roomNumber, self.textField.text] inView:self.view block:block];
    } else{
        [OMGlobleManager createRoom:self.textField.text inView:self.view block:block];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
