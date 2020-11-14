//
//  ViewController.m
//  MI Component
//
//  Created by HieuTDT on 9/6/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "ViewController.h"
#import "THCameraViewController.h"
#import "THPreviewImageViewController.h"

#import "VerticalIconTextButton.h"
#import "BottomSheetManager.h"
#import "SelectItemModel.h"
#import "SelectItemCollection.h"

#import "THComponents.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet SelectItemCollection *collectionView;
@property (weak, nonatomic) IBOutlet THButton *butotn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBlueColor;
    
    NSMutableArray *viewModels = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        SelectItemModel *model = [[SelectItemModel alloc] init];
        [model setTitle:@"Tôn hiếu"];
        [model setNormalImageName:@"4 cho"];
        [model setSelectedImageName:@"4 cho selected"];
        
        [viewModels addObject:model];
    }
    
    [self.collectionView setViewModels:viewModels];
    
    [_butotn setType:THButtonTypePrimary];
    [_butotn setTitle:@"Button"];
    [_butotn setImgName:@""];
    
//    [[THDialogManager shared] showSuccessDialogWithTitle:@"Thành công"
//                                                    desc:@"Chúc mừng mày đã tạo thành công Dialog"
//                                        inViewController:self
//                                              completion:nil];
    
    [[THDialogManager shared] showFailedDialogWithTitle:@"Thất bại"
                                                   desc:@"Bạn đã tạo thất bại Dialog View :))))"
                                       inViewController:self
                                             completion:^{
        [[THDialogManager shared]
         showConfirmDialogWithTitle:@"XÁC NHẬN"
         desc:@"Bạn có chắc chắn với lựa chọn này?"
         leftButtonTitle:@"Quay lại"
         leftButtonAction:^{
            
        }
         rightButtonTitle:@"Đồng ý"
         rightButtonAction:^{
            [[THDialogManager shared] showSuccessDialogWithTitle:@"Thành công"
                                                            desc:@"Chúc mừng bạn đã tạo thành công Dialog :)"
                                                inViewController:self
                                                      completion:nil];
        } inViewController:self];
    }];
}

- (IBAction)showBottomSheet:(id)sender {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor redColor];
    
    [[BottomSheetManager instance] showBottomSheetWithContent:contentView
                                                       height:300
                                                  canExpanded:YES];
}

- (IBAction)showCameraButtonTapped:(id)sender {
//    THCameraViewController *vc = [[THCameraViewController alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    THPreviewImageViewController *vc = [[THPreviewImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:vc animated:YES completion:nil];
}

@end
