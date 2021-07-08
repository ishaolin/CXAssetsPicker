//
//  CXAssetsPreviewController.h
//  Pods
//
//  Created by wshaolin on 15/7/13.
//

#import "CXAssetsBaseViewController.h"

@class CXAssetsPreviewController;
@class PHAsset;
@class CXAssetsToolBarButtonItem;

@protocol CXAssetsPreviewControllerDelegate <NSObject>

@optional

- (void)assetsPreviewController:(CXAssetsPreviewController *)assetsPreviewController didSelectAsset:(PHAsset *)asset;
- (void)assetsPreviewControllerDidCompleted:(CXAssetsPreviewController *)assetsPreviewController;
- (void)assetsPreviewController:(CXAssetsPreviewController *)assetsPreviewController
       didSelectedOriginalImage:(BOOL)isSelected;

@end

@interface CXAssetsPreviewController : CXAssetsBaseViewController

@property (nonatomic, copy) NSArray<PHAsset *> *assets;
@property (nonatomic, assign) NSUInteger currentAssetIndex;
@property (nonatomic, weak) id<CXAssetsPreviewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, assign, getter = isSelectedOriginalImage) BOOL selectedOriginalImage;

@end
