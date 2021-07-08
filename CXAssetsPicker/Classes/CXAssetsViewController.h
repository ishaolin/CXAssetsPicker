//
//  CXAssetsViewController.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsBaseViewController.h"
#import <Photos/Photos.h>

@interface CXAssetsViewController : CXAssetsBaseViewController

@property (nonatomic, strong, readonly) NSArray<PHAsset *> *selectedAssets;

- (void)setAssetsGroup:(PHFetchResult<PHAsset *> *)assetsGroup;

@end
