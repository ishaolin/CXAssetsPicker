//
//  CXAssetsPickerController.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import <CXUIKit/CXUIKit.h>
#import "CXAssetsType.h"

@protocol CXAssetsPickerControllerDelegate;

@interface CXAssetsPickerController : CXNavigationController

@property (nonatomic, weak) id<UINavigationControllerDelegate, CXAssetsPickerControllerDelegate> delegate;

@property (nonatomic, assign, readonly) CXAssetsType assetsType; // Default CXAssetsPhoto
@property (nonatomic, strong, readonly) NSArray<PHAsset *> *selectedAssets; // selected asset

@property (nonatomic, assign) NSUInteger enableMaximumCount; // Default 0，0 is not limited.
@property (nonatomic, assign) NSUInteger enableMinimumCount; // Default 0，0 is not limited.
@property (nonatomic, assign, getter = isMultiSelectionMode) BOOL multiSelectionMode; // Default YES

@property (nonatomic, assign, getter = isShowEmptyGroups) BOOL showEmptyGroups; // Default NO
@property (nonatomic, assign, getter = isFinishedDismissViewController) BOOL finishedDismissViewController; // Default YES.
@property (nonatomic, assign, getter = isEnablePreview) BOOL enablePreview;

@property (nonatomic, strong) UIColor *toolbarItemBackgroundColor; // Assets view bottom toolbar barButtonItem background color.
@property (nonatomic, strong) UIColor *toolbarItemFontColor; // Assets view bottom toolbar barButtonItem font color.
@property (nonatomic, copy) NSString *toolbarSendItemText; // Assets view bottom toolbar send barButtonItem text. Default '确定'

- (instancetype)initWithAssetsType:(CXAssetsType)assetsType;

@end

@protocol CXAssetsPickerControllerDelegate <NSObject>

@required

- (void)assetsPickerController:(CXAssetsPickerController *)assetsPickerController didFinishPickingAssets:(NSArray<PHAsset *> *)assets assetsType:(CXAssetsType)assetsType;

@optional

- (void)assetsPickerControllerDidCancel:(CXAssetsPickerController *)assetsPickerController;

- (void)assetsPickerController:(CXAssetsPickerController *)assetsPickerController didSelectAsset:(PHAsset *)asset;

- (void)assetsPickerController:(CXAssetsPickerController *)assetsPickerController didDeselectAsset:(PHAsset *)asset;

- (void)assetsPickerController:(CXAssetsPickerController *)assetsPickerController didSelectCountReachedEnableMaximumCount:(NSUInteger)enableMaximumCount;

- (void)assetsPickerController:(CXAssetsPickerController *)assetsPickerController didSelectCountUnderEnableMinimumCount:(NSUInteger)enableMinimumCount;

@end
