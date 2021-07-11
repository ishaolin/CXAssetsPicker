//
//  CXAssetsPickerAdapter.m
//  CXAssetsPicker
//
//  Created by wshaolin on 2021/7/11.
//

#import "CXAssetsPickerAdapter.h"

static CXAssetsPickerAdapter *_sharedAdapter;

@interface CXAssetsPickerAdapter () {
    UIImage *_assetNormalStateImage;
    UIImage *_assetSelectedStateImage;
    UIImage *_originalImageOptionNormalStateImage;
    UIImage *_originalImageOptionSelectedStateImage;
}

@end

@implementation CXAssetsPickerAdapter

+ (instancetype)sharedAdapter{
    if(!_sharedAdapter){
        _sharedAdapter = [[self alloc] init];
    }
    
    return _sharedAdapter;
}

+ (void)destroyAdapter{
    _sharedAdapter = nil;
}

- (UIImage *)assetNormalStateImage{
    if(!_assetNormalStateImage){
        _assetNormalStateImage = CX_ASSETS_PICKER_IMAGE(@"assets_picker_asset_state_normal");
    }
    
    return _assetNormalStateImage;
}

- (UIImage *)assetSelectedStateImage{
    if(!_assetSelectedStateImage){
        _assetSelectedStateImage = [UIImage cx_imageWithColor:self.toolbarItemBackgroundColor
                                                         size:CGSizeMake(22.0, 22.0)];
        _assetSelectedStateImage = [_assetSelectedStateImage cx_roundImage];
    }
    
    return _assetSelectedStateImage;
}

- (UIImage *)originalImageOptionNormalStateImage{
    if(!_originalImageOptionNormalStateImage){
        _originalImageOptionNormalStateImage = [self.assetNormalStateImage cx_imageForTintColor:self.toolbarItemBackgroundColor];
    }
    
    return _originalImageOptionNormalStateImage;
}

- (UIImage *)originalImageOptionSelectedStateImage{
    if(!_originalImageOptionSelectedStateImage){
        UIImage *image1 = self.originalImageOptionNormalStateImage;
        UIImage *image2 = [UIImage cx_imageWithColor:self.toolbarItemBackgroundColor
                                                size:CGSizeMake(10.0, 10.0)];
        image2 = [image2 cx_roundImage];
        
        CGFloat x = (image1.size.width - image2.size.width) * 0.5;
        CGFloat y = (image1.size.height - image2.size.height) * 0.5;
        _originalImageOptionSelectedStateImage =
        [image1 cx_composeImage:image2 rect:(CGRect){x, y, image2.size}];
    }
    
    return _originalImageOptionSelectedStateImage;
}

@end
