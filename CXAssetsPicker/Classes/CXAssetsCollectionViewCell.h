//
//  CXAssetsCollectionViewCell.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import <UIKit/UIKit.h>
#import "PHAsset+CXExtensions.h"

@class CXAssetsCollectionViewCell;

@protocol CXAssetsCollectionViewCellDelegate <NSObject>

@optional
- (BOOL)assetsCollectionViewCellShouldSelectAsset:(CXAssetsCollectionViewCell *)cell;
- (void)assetsCollectionViewCellDidSelectAsset:(CXAssetsCollectionViewCell *)cell;

@end

@interface CXAssetsCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CGSize assetSize;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, weak) id<CXAssetsCollectionViewCellDelegate> delegate;

@property (nonatomic, assign) BOOL allowsSelection;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
