//
//  CXAssetsGroupViewController.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsBaseViewController.h"

@class PHAsset;

@interface CXAssetsGroupViewController : CXAssetsBaseViewController

@property (nonatomic, strong, readonly) NSArray<PHAsset *> *selectedAssets;

@end
