//
//  CXAssetsDelegateViewController.h
//  Pods
//
//  Created by wshaolin on 2021/7/8.
//

#import "CXAssetsBaseViewController.h"
#import "CXAssetsViewController.h"

@interface CXAssetsDelegateViewController : CXAssetsBaseViewController <CXAssetsViewControllerDelegate>

@property (nonatomic, strong, readonly) NSArray<PHAsset *> *selectedAssets;

- (void)pickerCancel:(BOOL)animated;

@end
