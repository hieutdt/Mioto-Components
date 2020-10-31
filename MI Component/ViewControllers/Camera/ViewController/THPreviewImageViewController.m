//
//  PreviewImageViewController.m
//  MI Component
//
//  Created by HieuTDT on 10/5/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "THPreviewImageViewController.h"
#import "UIImage+Extensions.h"
#import "THImageZoomView.h"
#import "THFilterThumbImageCell.h"

#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(self) strongSelf = weakSelf;

@interface THPreviewImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// Containers
@property (weak, nonatomic) IBOutlet UIView *imageViewContainer;
@property (weak, nonatomic) IBOutlet UIView *filterViewContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/// Content image
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (nonatomic, strong) THImageZoomView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *carBorderImgView;

/// Bottom buttons
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

/// Filter collection view
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *filterImages;
@property (nonatomic, strong) NSArray *imageFilterNames;

/// Layout constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBorderWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBorderHeight;

@end

@implementation THPreviewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageForPreview = [UIImage imageNamed:@"car"];
    
    _filterCollectionView.delegate = self;
    _filterCollectionView.dataSource = self;
    
    _filterImages = [[NSMutableArray alloc] init];
    _imageFilterNames =  @[
        kFilterTypeChrome,
        kFilterTypeFade,
        kFilterTypeInstant,
        kFilterTypeMono,
        kFilterTypeNoir,
        kFilterTypeProcess,
        kFilterTypeTonal,
        kFilterTypeTransfer
    ];
    
    // Create filter view.
    WEAKSELF
    [self createFilterImagesWithCompletion:^{
        STRONGSELF
        [strongSelf.filterCollectionView reloadData];
    }];
    
    [self configureUI];
}

#pragma mark - Configure UI

- (void)configureUI {
    if (!_imageForPreview) {
        return;
    }
     
    // Fix orientation of image and change to landscape
    _imageForPreview = [_imageForPreview changeImageOrientation:UIImageOrientationLeft];
    
    // Init background color
    self.view.backgroundColor = UIColor.blackColor;
    self.imageViewContainer.backgroundColor = UIColor.darkTextColor;
    self.imageSuperView.backgroundColor = UIColor.darkTextColor;
    self.filterViewContainer.backgroundColor = UIColor.blackColor;
    
    // Calculate constraints
    CGFloat whRatio = 4/3.f;
    _imageViewHeightConstraint.constant = SCREEN_WIDTH / whRatio;
    _carBorderWidth.constant = SCREEN_WIDTH * 0.7;
    _carBorderHeight.constant = _imageViewHeightConstraint.constant * 0.7;
    
    // Car Border Image init
    UIImage *carFrontImage = [[UIImage imageNamed:@"car_front_border"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_carBorderImgView setImage:carFrontImage];
    [_carBorderImgView setTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
    
    // Image View init
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = UIColor.whiteColor;
    _imageView = [[THImageZoomView alloc] initWithFrame:_imageSuperView.bounds
                                                  image:_imageForPreview];
    [_imageSuperView addSubview:_imageView];
    
    // Default is hide filter view
    [self hideFilterView];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Utils

- (void)showFilterView {
    self.filterViewHeightConstraint.constant = 150;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)hideFilterView {
    self.filterViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutSubviews];
    }];
}

- (BOOL)isFilterShowing {
    return self.filterViewHeightConstraint.constant != 0;
}

/// Create all thumb filtered images for showing in Filter View.
- (void)createFilterImagesWithCompletion:(void (^)(void))completion {
    
    // This action is so heavy, so we do this task in background thread.
    dispatch_queue_t serialQueue = dispatch_queue_create("FilterQueue", DISPATCH_QUEUE_SERIAL);
    WEAKSELF
    dispatch_async(serialQueue, ^{
        STRONGSELF
        UIImage *thumbOriginalImage = [UIImage imageWithImage:strongSelf.imageForPreview
                                                convertToSize:CGSizeMake(60, 40)];
        
        for (NSString *name in strongSelf.imageFilterNames) {
            UIImage *filteredImage = [thumbOriginalImage addFilter:name];
            [strongSelf.filterImages addObject:filteredImage];
        }
        
        // Callback
        if (completion) {
            completion();
        }
    });
}

#pragma mark - Finish actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishButtonTapped:(id)sender {
    
}

#pragma mark - Edit actions

- (IBAction)rotateButtonTapped:(id)sender {
    _imageForPreview = [UIImage rotatedImage:_imageForPreview rotation:[UIImage DegreesToRadians:90]];
    [_imageView setImage:_imageForPreview];
}

- (IBAction)stickerButtonTapped:(id)sender {
    
}

- (IBAction)filterButtonTapped:(id)sender {
    if ([self isFilterShowing]) {
        [self hideFilterView];
    } else {
        [self showFilterView];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _imageFilterNames.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THFilterThumbImageCell *cell = [_filterCollectionView
                                    dequeueReusableCellWithReuseIdentifier:@"filterReuseId"
                                    forIndexPath:indexPath];
    if (!cell) {
        cell = [[THFilterThumbImageCell alloc] init];
    }
    
    NSInteger index = [indexPath item];
    [cell setImage:[_filterImages objectAtIndex:index]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 40);
}

@end
