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
#import "THComponents.h"

@interface THPreviewImageViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

/// Containers
@property (weak, nonatomic) IBOutlet UIView *imageViewContainer;
@property (weak, nonatomic) IBOutlet UIView *filterViewContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/// Content image
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (nonatomic, strong) THImageZoomView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *carBorderImgView;

@property (nonatomic, strong) UIImage *originalImage;

/// Bottom buttons
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

/// Filter collection view
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *filterImages;
@property (nonatomic, strong) NSArray *imageFilterNames;
@property (nonatomic, assign) NSInteger selectedFilterIndex;

/// Layout constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBorderWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBorderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterViewTopConstraint;

@property (nonatomic, assign) CGFloat filterViewTopSpace;

/// SerialQueue for handle task
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation THPreviewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageForPreview = [UIImage imageNamed:@"car"];
    
    [_filterCollectionView registerClass:[THFilterThumbImageCell class]
              forCellWithReuseIdentifier:@"filterReuseId"];
    
    _filterImages = [[NSMutableArray alloc] init];
    _imageFilterNames = @[
        kFilterTypeChrome,
        kFilterTypeFade,
        kFilterTypeInstant,
        kFilterTypeMono,
        kFilterTypeNoir,
        kFilterTypeProcess,
        kFilterTypeTonal,
        kFilterTypeTransfer
    ];
    
    _selectedFilterIndex = -1;
    
    // Create original image for not apply filter case
    _originalImage = [UIImage imageWithData:UIImagePNGRepresentation(_imageForPreview)];
    
    _serialQueue = dispatch_queue_create("FilterQueue", DISPATCH_QUEUE_SERIAL);
    
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
//    _imageForPreview = [_imageForPreview changeImageOrientation:UIImageOrientationLeft];
    
    // Init background color
    self.view.backgroundColor = UIColor.blackColor;
    self.imageViewContainer.backgroundColor = UIColor.darkTextColor;
    self.imageSuperView.backgroundColor = UIColor.darkTextColor;
    self.filterViewContainer.backgroundColor = UIColor.blackColor;
    self.filterCollectionView.backgroundColor = UIColor.blackColor;
    
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
    
    _filterViewTopSpace = [UIScreen mainScreen].bounds.size.height - 100 - 150;
    _filterViewTopConstraint.constant = _filterViewTopSpace;
    
    // Default is hide filter view
    [self hideFilterView];
}

#pragma mark - Utils

- (void)showFilterView {
    _filterViewTopConstraint.constant = _filterViewTopSpace;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)hideFilterView {
    _filterViewTopConstraint.constant = _filterViewTopSpace + 150;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutSubviews];
    }];
}

- (BOOL)isFilterShowing {
    return self.imageViewHeightConstraint.constant == _filterViewTopSpace + 150;
}

/// Apply filter for rendering preview image.
/// @param filterName filterName for apply.
/// @param completion callback when filter task done.
- (void)applyFilterName:(NSString *)filterName
         withCompletion:(void (^)(void))completion {
    WEAKSELF
    dispatch_async(_serialQueue, ^{
        STRONGSELF
        strongSelf.imageForPreview = [strongSelf.originalImage addFilter:filterName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

/// Create all thumb filtered images for showing in Filter View.
- (void)createFilterImagesWithCompletion:(void (^)(void))completion {
    
    // This action is so heavy, so we do this task in background thread.
    WEAKSELF
    dispatch_async(_serialQueue, ^{
        STRONGSELF
        UIImage *thumbOriginalImage = [UIImage imageWithImage:strongSelf.imageForPreview
                                                convertToSize:CGSizeMake(60, 40)];
        
        for (NSString *name in strongSelf.imageFilterNames) {
            UIImage *filteredImage = [thumbOriginalImage addFilter:name];
            [strongSelf.filterImages addObject:filteredImage];
        }
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

- (void)didSelectedAllAnothorCells {
    for (int i = 0; i < _imageFilterNames.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        THFilterThumbImageCell *cell = (THFilterThumbImageCell *)[_filterCollectionView cellForItemAtIndexPath:indexPath];
        if (cell && i != _selectedFilterIndex) {
            [cell setIsSelected:NO];
        }
    }
}

#pragma mark - Finish actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishButtonTapped:(id)sender {
    UIImage *finalImage = [UIImage imageWithCGImage:_imageForPreview.CGImage];
    finalImage = [UIImage imageWithImage:finalImage convertToSize:CGSizeMake(1920, 1080)];
    
    NSLog(@"Final Image> Size = %f - %f", finalImage.size.width, finalImage.size.height);
}

#pragma mark - Edit actionss

- (IBAction)rotateButtonTapped:(id)sender {
    _imageForPreview = [UIImage rotatedImage:_imageForPreview rotation:[UIImage DegreesToRadians:90]];
    _originalImage = [UIImage imageWithCGImage:_imageForPreview.CGImage];
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
    
    NSInteger index = indexPath.row;
    [cell setImage:[_filterImages objectAtIndex:index]];
    [cell setIsSelected:index == _selectedFilterIndex];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 75);
}

- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger oldIndex = _selectedFilterIndex;
    
    // Toggle selected state
    THFilterThumbImageCell *cell = (THFilterThumbImageCell *)[_filterCollectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isSelected]) {
        _selectedFilterIndex = -1;
    } else {
        _selectedFilterIndex = indexPath.item;
    }
    
    [cell setIsSelected:indexPath.item == _selectedFilterIndex];
    
    // Deselected previous selected cell
    if (oldIndex >= 0) {
        THFilterThumbImageCell *oldCell = (THFilterThumbImageCell *)[_filterCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0]];
        [oldCell setIsSelected:NO];
    }
    
    // Apply filter for preview image views
    WEAKSELF
    [self applyFilterName:[_imageFilterNames objectAtIndex:indexPath.item]
           withCompletion:^{
        STRONGSELF
        [strongSelf.imageView setImage:strongSelf.imageForPreview];
    }];
}

@end
