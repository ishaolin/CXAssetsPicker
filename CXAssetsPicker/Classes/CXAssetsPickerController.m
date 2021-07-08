//
//  CXAssetsPickerController.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsPickerController.h"
#import "CXAssetsGroupViewController.h"
#import <Photos/Photos.h>

@implementation CXAssetsPickerController

@dynamic delegate;

- (instancetype)init{
    return [self initWithAssetsType:CXAssetsPhoto];
}

- (instancetype)initWithAssetsType:(CXAssetsType)assetsType{
    if(self = [super initWithRootViewController:[[CXAssetsGroupViewController alloc] init]]){
        _assetsType = assetsType;
        _finishDismissViewController = YES;
        _showEmptyGroups = NO;
        _enablePreview = YES;
        _multiSelectionMode = YES;
        
        _toolbarItemBackgroundColor = CXHexIColor(0x26AB28);
        _toolbarItemFontColor = [UIColor whiteColor];
        _toolbarSendItemText = @"确定";
    }
    
    return self;
}

- (NSArray<PHAsset *> *)selectedAssets{
    UIViewController *viewController = self.viewControllers.firstObject;
    if([viewController isKindOfClass:[CXAssetsGroupViewController class]]){
        return ((CXAssetsGroupViewController *)viewController).selectedAssets;
    }
    
    return nil;
}

@end
