//
//  CXAssetsViewToolBar.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import <UIKit/UIKit.h>

@class CXAssetsViewToolBar;

@protocol CXAssetsViewToolBarDelegate <NSObject>

@optional
- (void)assetsViewToolBarDidCompleted:(CXAssetsViewToolBar *)toolBar;
- (void)assetsViewToolBarDidPreviewed:(CXAssetsViewToolBar *)toolBar;
- (void)assetsViewToolBar:(CXAssetsViewToolBar *)toolBar didSelectedOriginalImage:(BOOL)isSelected;;

@end

@interface CXAssetsViewToolBar : UIView

@property (nonatomic, weak) id<CXAssetsViewToolBarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, assign) NSInteger enableMaximumCount;
@property (nonatomic, assign, getter = isHiddenPreviewItem) BOOL hiddenPreviewItem;
@property (nonatomic, assign, getter = isSelectedOriginalImage) BOOL selectedOriginalImage;
@property (nonatomic, assign, getter = isTranslucent) BOOL translucent;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
