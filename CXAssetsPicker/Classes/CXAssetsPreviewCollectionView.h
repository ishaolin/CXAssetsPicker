//
//  CXAssetsPreviewCollectionView.h
//  Pods
//
//  Created by wshaolin on 15/7/27.
//

#import <UIKit/UIKit.h>

@interface CXAssetsPreviewCollectionView : UICollectionView

+ (instancetype)collectionView;

- (void)registerCellClass:(Class)cellClass;

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath;

@end
