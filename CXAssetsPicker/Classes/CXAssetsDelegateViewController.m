//
//  CXAssetsDelegateViewController.m
//  Pods
//
//  Created by wshaolin on 2021/7/8.
//

#import "CXAssetsDelegateViewController.h"
#import "PHAsset+CXAssetsPicker.h"

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
    if([self.pickerController.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)]){
        [self.pickerController.delegate assetsPickerControllerDidCancel:self.pickerController];
    }
    
    [self.pickerController dismissViewControllerAnimated:animated completion:NULL];
}

- (void)assetsViewControllerDidCancel:(CXAssetsViewController *)viewController{
    [self pickerCancel:YES];
}

- (void)assetsViewControllerDidCompleted:(CXAssetsViewController *)viewController{
    if(self.pickerController.enableMinimumCount > 0 &&
       _selectedAssets.count < self.pickerController.enableMinimumCount){
        if([self.pickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountUnderEnableMinimumCount:)]){
            [self.pickerController.delegate assetsPickerController:self.pickerController didSelectCountUnderEnableMinimumCount:self.pickerController.enableMinimumCount];
            return;
        }
    }
    
    [_selectedAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cx_originalImage = viewController.isSelectedOriginalImage;
    }];
    
    [self.pickerController.delegate assetsPickerController:self.pickerController
                                    didFinishPickingAssets:[_selectedAssets copy]
                                                assetsType:self.pickerController.assetsType];
}

- (void)assetsViewController:(CXAssetsViewController *)viewController didSelectAsset:(PHAsset *)asset{
    [_selectedAssets addObject:asset];
    asset.cx_selectedIndex = _selectedAssets.count - 1;
    
    if([self.pickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
        [self.pickerController.delegate assetsPickerController:self.pickerController didSelectAsset:asset];
    }
}

- (void)assetsViewController:(CXAssetsViewController *)viewController didDeselectAsset:(PHAsset *)asset{
    [_selectedAssets removeObject:asset];
    if([self.pickerController.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
        [self.pickerController.delegate assetsPickerController:self.pickerController didDeselectAsset:asset];
    }
}

- (BOOL)assetsViewController:(CXAssetsViewController *)viewController shouldSelectAsset:(PHAsset *)asset{
    if(self.pickerController.enableMaximumCount == 0 || _selectedAssets.count < self.pickerController.enableMaximumCount){
        return YES;
    }
    
    if([self.pickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)]){
        [self.pickerController.delegate assetsPickerController:self.pickerController didSelectCountReachedEnableMaximumCount:self.pickerController.enableMaximumCount];
    }else{
        [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
            config.title = [NSString stringWithFormat:@"你最多只能选择 %@ 张照片", @(self.pickerController.enableMaximumCount)];
            config.viewController = self.pickerController.visibleViewController;
        } completion:nil];
    }
    
    return NO;
}

@end
