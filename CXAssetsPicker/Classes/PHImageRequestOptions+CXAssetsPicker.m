//
//  PHImageRequestOptions+CXAssetsPicker.m
//  Pods
//
//  Created by wshaolin on 2021/7/6.
//

#import "PHImageRequestOptions+CXAssetsPicker.h"
#import "PHAsset+CXAssetsPicker.h"

@implementation PHImageRequestOptions (CXAssetsPicker)

+ (instancetype)cx_optionsForOriginal:(BOOL)original{
    PHImageRequestOptions *options = [[self alloc] init];
    if(original){
        options.version = PHImageRequestOptionsVersionOriginal;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
    }
    
    options.networkAccessAllowed = YES;
    return options;
}

@end
