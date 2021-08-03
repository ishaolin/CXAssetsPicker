//
//  CXWebViewImagePickerController.m
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import "CXWebViewImagePickerController.h"
#import <CXFoundation/CXFoundation.h>

@implementation CXWebViewImagePickerController

- (void)handleSelectedImage:(UIImage *)image completion:(void (^)(NSString *))completion{
    if([self.params isKindOfClass:[CXWebViewImagePickerParams class]]){
        CXWebViewImagePickerParams *params = (CXWebViewImagePickerParams *)self.params;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *base64Image = [UIImageJPEGRepresentation(image, params.quality) base64EncodedStringWithOptions:0];
            [CXDispatchHandler asyncOnMainQueue:^{
                !completion ?: completion(base64Image);
            }];
        });
    }else{
        [super handleSelectedImage:image completion:completion];
    }
}

@end

@implementation CXWebViewImagePickerParams

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary{
    CXImagePickerSourceType sourceType = CXImagePickerSourceTypeBothAll;
    NSString *type = [dictionary cx_stringForKey:@"type"];
    if([type isEqualToString:CXWebViewImagePickerTypeCamera]){
        sourceType = CXImagePickerSourceTypeCamera;
    }else if([type isEqualToString:CXWebViewImagePickerTypeAlbum]){
        sourceType = CXImagePickerSourceTypeAlbum;
    }
    
    if(self = [super initWithSourceType:sourceType
                            clipEnabled:[dictionary cx_numberForKey:@"cut"].boolValue
                            aspectRatio:1.0]){
        CGFloat quality = [dictionary cx_numberForKey:@"quality"].floatValue;
        _quality = MIN(MAX(quality, 1.0), 1.0);
        self.base64Output = YES;
    }
    
    return self;
}

+ (BOOL)isValidParams:(NSDictionary<NSString *,id> *)params{
    NSString *type = [params cx_stringForKey:@"type"];
    if(!type){
        return NO;
    }
    
    return ([type isEqualToString:CXWebViewImagePickerTypeCamera] ||
            [type isEqualToString:CXWebViewImagePickerTypeAlbum] ||
            [type isEqualToString:CXWebViewImagePickerTypeBothAll]);
}

@end

NSString * const CXWebViewImagePickerTypeCamera = @"camera";
NSString * const CXWebViewImagePickerTypeAlbum = @"album";
NSString * const CXWebViewImagePickerTypeBothAll = @"both";
