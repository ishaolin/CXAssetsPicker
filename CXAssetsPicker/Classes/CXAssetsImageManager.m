//
//  CXAssetsImageManager.m
//  Pods
//
//  Created by wshaolin on 2019/2/14.
//

#import "CXAssetsImageManager.h"
#import <CXFoundation/CXFoundation.h>
#import "PHAsset+CXAssetsPicker.h"
#import "PHImageRequestOptions+CXAssetsPicker.h"

@implementation CXAssetsImageManager

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                              targetSize:(CGSize)targetSize
                             contentMode:(PHImageContentMode)contentMode
                                 options:(PHImageRequestOptions *)options
                              completion:(void (^)(PHAsset *, UIImage *, NSDictionary<NSString *,id> *))completion{
    CGFloat scale = MAX([UIScreen mainScreen].scale, 1.0);
    targetSize.width *= scale;
    targetSize.height *= scale;
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [CXDispatchHandler asyncOnMainQueue:^{
            if([info[PHImageResultIsDegradedKey] boolValue]){
                return;
            }
            
            !completion ?: completion(asset, result, info);
        }];
    }];
}

+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset
                                     options:(PHImageRequestOptions *)options
                                  completion:(void (^)(PHAsset *, CXAssetsElementImage *))completion{
    __block BOOL returned = NO;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        [CXDispatchHandler asyncOnMainQueue:^{
            if(returned){
                return;
            }
            
            CXAssetsElementImage *image = [[CXAssetsElementImage alloc] init];
            image.image = [[UIImage alloc] initWithData:imageData];
            image.imageData = imageData;
            image.dataUTI = dataUTI;
            image.orientation = orientation;
            image.info = info;
            image.tag = asset.cx_selectedIndex;
            !completion ?: completion(asset, image);
            returned = YES;
        }];
    }];
}

+ (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset
                                      options:(PHVideoRequestOptions *)options
                                   completion:(void (^)(PHAsset *, AVPlayerItem *, NSDictionary<NSString *,id> *))completion{
    __block BOOL returned = NO;
    return [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        [CXDispatchHandler asyncOnMainQueue:^{
            if(returned){
                return;
            }
            
            !completion ?: completion(asset, playerItem, info);
            returned = YES;
        }];
    }];
}

+ (PHImageRequestID)requestExportSessionForVideo:(PHAsset *)asset
                                         options:(PHVideoRequestOptions *)options
                                    exportPreset:(NSString *)exportPreset
                                      completion:(void (^)(PHAsset *, AVAssetExportSession *, NSDictionary<NSString *,id> *))completion{
    __block BOOL returned = NO;
    return [[PHImageManager defaultManager] requestExportSessionForVideo:asset options:options exportPreset:exportPreset resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        [CXDispatchHandler asyncOnMainQueue:^{
            if(returned){
                return;
            }
            
            !completion ?: completion(asset, exportSession, info);
            returned = YES;
        }];
    }];
}

+ (void)requestImageDataForAssets:(NSArray<PHAsset *> *)assets
                       completion:(void(^)(NSArray<CXAssetsElementImage *> *images))completion{
    PHImageRequestOptions *options = [PHImageRequestOptions cx_optionsForOriginal:assets.firstObject.cx_originalImage];
    [self requestImageDataForAssets:assets options:options completion:completion];
}

+ (void)requestImageDataForAssets:(NSArray<PHAsset *> *)assets
                          options:(PHImageRequestOptions *)options
                       completion:(void(^)(NSArray<CXAssetsElementImage *> *))completion{
    if(CXArrayIsEmpty(assets) || !completion){
        return;
    }
    
    CXBlockOperationQueue *operationQueue = [[CXBlockOperationQueue alloc] init];
    operationQueue.completion = ^(NSArray<CXBlockOperationHandlerResult *> *results) {
        NSMutableArray<CXAssetsElementImage *> *images = [NSMutableArray array];
        [results enumerateObjectsUsingBlock:^(CXBlockOperationHandlerResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.data){
                [images addObject:(CXAssetsElementImage *)obj.data];
            }
        }];
        
        if(images.count > 1){
            [images sortUsingComparator:^NSComparisonResult(CXAssetsElementImage * _Nonnull obj1, CXAssetsElementImage * _Nonnull obj2) {
                return [@(obj1.tag) compare:@(obj2.tag)];
            }];
        }
        
        completion([images copy]);
    };
    
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [operationQueue addOperationHandler:^(CXBlockOperationResultNotify notify) {
            [self requestImageDataForAsset:obj options:options completion:^(PHAsset *asset, CXAssetsElementImage *image) {
                notify(image);
            }];
        }];
    }];
    
    [operationQueue invoke];
}

+ (void)requestImageDataForAssets:(NSArray<PHAsset *> *)assets
                          options:(PHImageRequestOptions *)options
       enumerateObjectsUsingBlock:(void(^)(CXAssetsElementImage *image, NSUInteger idx))block{
    if(CXArrayIsEmpty(assets) || !block){
        return;
    }
    
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self requestImageDataForAsset:obj options:options completion:^(PHAsset *asset, CXAssetsElementImage *image) {
            block(image, idx);
        }];
    }];
}

+ (void)cancelImageRequest:(PHImageRequestID)requestID{
    [[PHImageManager defaultManager] cancelImageRequest:requestID];
}

@end

@implementation CXAssetsElementImage

@end
