//
//  PHFetchResult+CXAssetsPicker.h
//  Pods
//
//  Created by wshaolin on 2019/2/14.
//

#import "PHAsset+CXAssetsPicker.h"

@interface PHFetchResult (CXAssetsPicker)

@property (nonatomic, assign, readonly) NSUInteger cx_countOfAssets;

@property (nonatomic, assign) CXAssetsType cx_mediaType;
@property (nonatomic, copy) NSString *cx_title;

- (void)cx_requestPosterImage:(CXAssetThumbnailBlock)posterBlock;

- (NSArray<PHAsset *> *)cx_assets;

@end
