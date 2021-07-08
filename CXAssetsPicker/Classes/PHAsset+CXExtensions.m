//
//  PHAsset+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2019/2/14.
//

#import "PHAsset+CXExtensions.h"
#import <objc/runtime.h>

@implementation PHAsset (CXExtensions)

- (void)setCx_selected:(BOOL)cx_selected{
    objc_setAssociatedObject(self, @selector(cx_selected), @(cx_selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cx_selected{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCx_selectedIndex:(NSUInteger)cx_selectedIndex{
    objc_setAssociatedObject(self, @selector(cx_selectedIndex), @(cx_selectedIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)cx_selectedIndex{
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setCx_originalIndex:(NSUInteger)cx_originalIndex{
    objc_setAssociatedObject(self, @selector(cx_originalIndex), @(cx_originalIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)cx_originalIndex{
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)cx_thumbnailWithSize:(CGSize)size completion:(CXAssetThumbnailBlock)completion{
    [CXAssetsImageManager requestImageForAsset:self targetSize:size contentMode:PHImageContentModeDefault options:nil completion:^(PHAsset *asset, UIImage *image, NSDictionary<NSString *,id> *info) {
        if(asset != self){
            return;
        }
        
        !completion ?: completion(image, info);
    }];
}

@end
