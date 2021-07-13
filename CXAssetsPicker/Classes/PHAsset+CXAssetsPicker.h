//
//  PHAsset+CXAssetsPicker.h
//  Pods
//
//  Created by wshaolin on 2019/2/14.
//

#import "CXAssetsType.h"
#import "CXAssetsImageManager.h"

typedef void(^CXAssetThumbnailBlock)(UIImage *image, NSDictionary<NSString *, id> *info);

@interface PHAsset (CXAssetsPicker)

@property (nonatomic, assign) BOOL cx_selected;
@property (nonatomic, assign) NSUInteger cx_selectedIndex; // 选中的顺序
@property (nonatomic, assign) NSUInteger cx_originalIndex; // 原始（显示）的顺序
@property (nonatomic, assign) BOOL cx_originalImage;

- (void)cx_thumbnailWithCompletion:(CXAssetThumbnailBlock)completion;
- (void)cx_thumbnailWithSize:(CGSize)size completion:(CXAssetThumbnailBlock)completion;

@end
