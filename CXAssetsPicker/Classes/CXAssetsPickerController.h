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

@property (nonatomic, assign, readonly) CXAssetsType assetsType;
@property (nonatomic, strong, readonly) NSArray<PHAsset *> *selectedAssets;

@property (nonatomic, assign) NSUInteger enableMaximumCount;
@property (nonatomic, assign) NSUInteger enableMinimumCount;
@property (nonatomic, assign, getter = isMultiSelectionMode) BOOL multiSelectionMode;
@property (nonatomic, assign, getter = isShowEmptyAlbum) BOOL showEmptyAlbum;
@property (nonatomic, assign, getter = isEnablePreview) BOOL enablePreview;

@property (nonatomic, strong) UIColor *toolbarItemBackgroundColor;
@property (nonatomic, strong) UIColor *toolbarItemFontColor;
@property (nonatomic, copy) NSString *toolbarSendItemText;

- (instancetype)initWithAssetsType:(CXAssetsType)assetsType;

@end

@protocol CXAssetsPickerControllerDelegate <NSObject>

@required
- (void)assetsPickerController:(CXAssetsPickerController *)picker
        didFinishPickingAssets:(NSArray<PHAsset *> *)assets
                    assetsType:(CXAssetsType)assetsType;

@optional
- (void)assetsPickerControllerDidCancel:(CXAssetsPickerController *)picker;
- (void)assetsPickerController:(CXAssetsPickerController *)picker didSelectAsset:(PHAsset *)asset;
- (void)assetsPickerController:(CXAssetsPickerController *)picker didDeselectAsset:(PHAsset *)asset;
- (void)assetsPickerController:(CXAssetsPickerController *)picker didSelectCountReachedEnableMaximumCount:(NSUInteger)enableMaximumCount;
- (void)assetsPickerController:(CXAssetsPickerController *)picker didSelectCountUnderEnableMinimumCount:(NSUInteger)enableMinimumCount;

@end
