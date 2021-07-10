//
//  CXAssetsDelegateViewController.m
//  CXAssetsPicker
//
//  Created by wshaolin on 2021/7/8.
//

#import "CXAssetsDelegateViewController.h"
#import "PHAsset+CXExtensions.h"

@interface CXAssetsDelegateViewController () {
    NSMutableArray<PHAsset *> *_selectedAssets;
}

@end

@implementation CXAssetsDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedAssets = [NSMutableArray array];
}

- (NSArray<PHAsset *> *)selectedAssets{
    return _selectedAssets;
}

- (void)pickerCancel:(BOOL)animated{
    if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)]){
        [self.assetsPickerController.delegate assetsPickerControllerDidCancel:self.assetsPickerController];
    }
    
    [self.assetsPickerController dismissViewControllerAnimated:animated completion:NULL];
}

- (void)assetsViewControllerDidCancel:(CXAssetsViewController *)viewController{
    [self pickerCancel:YES];
}

- (void)assetsViewControllerDidCompleted:(CXAssetsViewController *)viewController{
    if(self.assetsPickerController.enableMinimumCount > 0 &&
       _selectedAssets.count < self.assetsPickerController.enableMinimumCount){
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountUnderEnableMinimumCount:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectCountUnderEnableMinimumCount:self.assetsPickerController.enableMinimumCount];
            return;
        }
    }
    
    [_selectedAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cx_originalImage = viewController.isSelectedOriginalImage;
    }];
    
    [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didFinishPickingAssets:[_selectedAssets copy] assetsType:self.assetsPickerController.assetsType];
    
    if(self.assetsPickerController.isFinishedDismissViewController){
        [self.assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)assetsViewController:(CXAssetsViewController *)viewController didSelectAsset:(PHAsset *)asset{
    [_selectedAssets addObject:asset];
    asset.cx_selectedIndex = _selectedAssets.count - 1;
    
    if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
        [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectAsset:asset];
    }
}

- (void)assetsViewController:(CXAssetsViewController *)viewController didDeselectAsset:(PHAsset *)asset{
    [_selectedAssets removeObject:asset];
    if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
        [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didDeselectAsset:asset];
    }
}

- (BOOL)assetsViewController:(CXAssetsViewController *)viewController shouldSelectAsset:(PHAsset *)asset{
    if(self.assetsPickerController.enableMaximumCount == 0 || _selectedAssets.count < self.assetsPickerController.enableMaximumCount){
        return YES;
    }
    
    if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)]){
        [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectCountReachedEnableMaximumCount:self.assetsPickerController.enableMaximumCount];
    }else{
        [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
            config.title = [NSString stringWithFormat:@"你最多只能选择 %@ 张照片", @(self.assetsPickerController.enableMaximumCount)];
            config.viewController = self.assetsPickerController.visibleViewController;
        } completion:nil];
    }
    
    return NO;
}

@end
