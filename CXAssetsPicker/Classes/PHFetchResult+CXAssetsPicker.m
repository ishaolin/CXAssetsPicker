//
//  PHFetchResult+CXAssetsPicker.m
//  Pods
//
//  Created by wshaolin on 2019/2/14.
//

#import "PHFetchResult+CXAssetsPicker.h"

#import <objc/runtime.h>

@implementation PHFetchResult (CXAssetsPicker)

- (void)setCx_mediaType:(CXAssetsType)cx_mediaType{
    objc_setAssociatedObject(self, @selector(cx_mediaType), @(cx_mediaType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CXAssetsType)cx_mediaType{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setCx_title:(NSString *)cx_title{
    objc_setAssociatedObject(self, @selector(cx_title), cx_title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)cx_title{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSUInteger)cx_countOfAssets{
    switch (self.cx_mediaType) {
        case CXAssetsVideo:
            return [self countOfAssetsWithMediaType:PHAssetMediaTypeVideo];
        case CXAssetsPhoto:
            return [self countOfAssetsWithMediaType:PHAssetMediaTypeImage];
        default:
            return ([self countOfAssetsWithMediaType:PHAssetMediaTypeImage] + [self countOfAssetsWithMediaType:PHAssetMediaTypeVideo]);
    }
}

- (void)cx_requestPosterImage:(CXAssetThumbnailBlock)posterBlock{
    __block PHAsset *asset = nil;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.mediaType == PHAssetMediaTypeImage || obj.mediaType == PHAssetMediaTypeVideo){
            asset = obj;
            *stop = YES;
        }
    }];
    
    if(asset){
        [asset cx_thumbnailWithSize:CGSizeMake(75.0, 75.0) completion:posterBlock];
    }else{
        !posterBlock ?: posterBlock(nil, nil);
    }
}

- (NSArray<PHAsset *> *)cx_assets{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cx_originalIndex = assets.count;
        
        if(self.cx_mediaType == CXAssetsAll){
            if(obj.mediaType == PHAssetMediaTypeImage || obj.mediaType == PHAssetMediaTypeVideo){
                [assets addObject:obj];
            }
        }else if(obj.mediaType == (PHAssetMediaType)self.cx_mediaType){
            [assets addObject:obj];
        }
    }];
    
    return [assets copy];
}

@end
