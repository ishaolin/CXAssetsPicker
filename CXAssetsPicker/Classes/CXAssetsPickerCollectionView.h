//
//  CXAssetsPickerCollectionView.h
//  Pods
//
//  Created by wshaolin on 15/7/10.
//

#import <UIKit/UIKit.h>

@interface CXAssetsPickerCollectionView : UICollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame;

- (void)registerCellClass:(Class)cellClass;

@end
