//
//  CXAssetsViewController.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsBaseViewController.h"
#import <Photos/Photos.h>

@class CXAssetsViewController;

@protocol CXAssetsViewControllerDelegate <NSObject>

@required
@property (nonatomic, strong, readonly) NSArray<PHAsset *> *selectedAssets;

- (void)assetsViewControllerDidCancel:(CXAssetsViewController *)viewController;
- (void)assetsViewControllerDidCompleted:(CXAssetsViewController *)viewController;
- (void)assetsViewController:(CXAssetsViewController *)viewController didSelectAsset:(PHAsset *)asset;
- (void)assetsViewController:(CXAssetsViewController *)viewController didDeselectAsset:(PHAsset *)asset;
- (BOOL)assetsViewController:(CXAssetsViewController *)viewController shouldSelectAsset:(PHAsset *)asset;

@end

@interface CXAssetsViewController : CXAssetsBaseViewController

@property (nonatomic, weak) id<CXAssetsViewControllerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isSelectedOriginalImage;

- (void)setAssetsAlbum:(PHFetchResult<PHAsset *> *)assetsAlbum;

@end
