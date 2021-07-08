//
//  PHImageRequestOptions+CXAssetsPicker.m
//  CXAssetsPicker
//
//  Created by wshaolin on 2021/7/6.
//

#import "PHImageRequestOptions+CXAssetsPicker.h"

@implementation PHImageRequestOptions (CXAssetsPicker)

+ (instancetype)cx_options{
    PHImageRequestOptions *options = [[self alloc] init];
    options.version = PHImageRequestOptionsVersionOriginal;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.networkAccessAllowed = YES;
    return options;
}

@end