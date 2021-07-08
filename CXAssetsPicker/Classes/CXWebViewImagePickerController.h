//
//  CXWebViewImagePickerController.h
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import "CXImagePickerController.h"

@interface CXWebViewImagePickerController : CXImagePickerController

@end

@interface CXWebViewImagePickerParams : CXImagePickerParams

@property (nonatomic, assign, readonly) CGFloat quality;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

+ (BOOL)isValidParams:(NSDictionary<NSString *, id> *)params;

@end

UIKIT_EXTERN NSString * const CXWebImagePickerTypeCamera;
UIKIT_EXTERN NSString * const CXWebImagePickerTypeAlbum;
UIKIT_EXTERN NSString * const CXWebImagePickerTypeBothAll;
