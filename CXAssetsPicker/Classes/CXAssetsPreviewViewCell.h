//
//  CXAssetsPreviewViewCell.h
//  Pods
//
//  Created by wshaolin on 2019/1/18.
//

#import "PHAsset+CXExtensions.h"
#import <CXUIKit/CXUIKit.h>

@class CXAssetsPreviewViewCell;

#define CX_ASSETS_IMAGE_SPACING 20.0

@protocol CXAssetsPreviewViewCellDelegate <NSObject>

@optional
- (void)assetsPreviewViewCellDidSingleTouch:(CXAssetsPreviewViewCell *)cell;

@end

@interface CXAssetsPreviewViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, getter = isHideProgressBar) BOOL hideProgressBar;

@property (nonatomic, weak) id<CXAssetsPreviewViewCellDelegate> delegate;
@property (nonatomic, strong) PHAsset *asset;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath;

- (void)handleSingleTouchAction:(UITapGestureRecognizer *)tapGestureRecognizer;

- (void)endDisplaying;

@end
