//
//  CXAssetsImageManager.h
//  Pods
//
//  Created by wshaolin on 2019/2/14.
//

#import <Photos/Photos.h>

@class CXAssetsElementImage;

@interface CXAssetsImageManager : NSObject

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                              targetSize:(CGSize)targetSize
                             contentMode:(PHImageContentMode)contentMode
                                 options:(PHImageRequestOptions *)options
                              completion:(void (^)(PHAsset *asset, UIImage *image, NSDictionary<NSString *, id> *info))completion;

+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset
                                     options:(PHImageRequestOptions *)options
                                  completion:(void(^)(PHAsset *asset, CXAssetsElementImage *image))completion;

+ (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset
                                      options:(PHVideoRequestOptions *)options
                                   completion:(void (^)(PHAsset *asset, AVPlayerItem *playerItem, NSDictionary<NSString *, id> *info))completion;

+ (PHImageRequestID)requestExportSessionForVideo:(PHAsset *)asset
                                         options:(PHVideoRequestOptions *)options
                                    exportPreset:(NSString *)exportPreset
                                      completion:(void (^)(PHAsset *asset, AVAssetExportSession *exportSession, NSDictionary<NSString *, id> *info))completion;

+ (void)requestImageDataForAssets:(NSArray<PHAsset *> *)assets
                       completion:(void(^)(NSArray<CXAssetsElementImage *> *images))completion;

+ (void)requestImageDataForAssets:(NSArray<PHAsset *> *)assets
                          options:(PHImageRequestOptions *)options
                       completion:(void(^)(NSArray<CXAssetsElementImage *> *images))completion;

+ (void)requestImageDataForAssets:(NSArray<PHAsset *> *)assets
                          options:(PHImageRequestOptions *)options
       enumerateObjectsUsingBlock:(void(^)(CXAssetsElementImage *image, NSUInteger idx))block;

+ (void)cancelImageRequest:(PHImageRequestID)requestID;

@end

@interface CXAssetsElementImage : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy)  NSString *dataUTI;
@property (nonatomic, assign) UIImageOrientation orientation;
@property (nonatomic, strong) NSDictionary<NSString *, id> *info;
@property (nonatomic, assign) NSUInteger tag;

@end
