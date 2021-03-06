//
//  PodsController.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsPickerController.h"
#import "CXAssetsAlbumViewController.h"
#import <Photos/Photos.h>
#import "CXAssetsPickerAdapter.h"

@implementation CXAssetsPickerController

@dynamic delegate;

- (instancetype)init{
    return [self initWithAssetsType:CXAssetsPhoto];
}

- (instancetype)initWithAssetsType:(CXAssetsType)assetsType{
    if(self = [super initWithRootViewController:[[CXAssetsAlbumViewController alloc] init]]){
        _assetsType = assetsType;
        _showEmptyAlbum = NO;
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
    if([viewController isKindOfClass:[CXAssetsAlbumViewController class]]){
        return [((CXAssetsAlbumViewController *)viewController).selectedAssets copy];
    }
    
    return nil;
}

- (void)dealloc{
    [CXAssetsPickerAdapter destroyAdapter];
}

@end
