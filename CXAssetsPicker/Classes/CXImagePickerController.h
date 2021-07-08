//
//  CXImagePickerController.h
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import <CXUIKit/CXUIKit.h>

typedef NS_ENUM(NSInteger, CXImagePickerSourceType){
    CXImagePickerSourceTypeCamera  = 1,
    CXImagePickerSourceTypeAlbum   = 2,
    CXImagePickerSourceTypeBothAll = 3
};

@class CXImagePickerController, CXImagePickerParams;

typedef void(^CXImagePickerCompletionBlock)(CXPickerController *picker,
                                            UIImage *image,
                                            NSString *base64,
                                            CXPickerFinishState state,
                                            UIImagePickerControllerSourceType sourceType);

@interface CXImagePickerController : CXPickerController

@property (nonatomic, strong, readonly) CXImagePickerParams *params;
@property (nonatomic, copy) CXPickerControllerActionSheetBlock cameraActionBlock;
@property (nonatomic, copy) CXPickerControllerActionSheetBlock albumActionBlock;
@property (nonatomic, copy) CXPickerControllerActionSheetBlock cancelActionBlock;

+ (instancetype)showFromViewController:(UIViewController *)viewController
                                params:(CXImagePickerParams *)params
                            completion:(CXImagePickerCompletionBlock)completion;

- (void)handleSelectedImage:(UIImage *)image completion:(void (^)(NSString *base64Image))completion;

@end

@interface CXImagePickerParams : NSObject

@property (nonatomic, assign, readonly) CXImagePickerSourceType sourceType;
@property (nonatomic, assign, readonly, getter = isClipEnabled) BOOL clipEnabled;
@property (nonatomic, assign, readonly) CGFloat aspectRatio;
@property (nonatomic, assign, getter = isBase64Output) BOOL base64Output; // 是否转换为base64输出，默认YES

- (instancetype)initWithSourceType:(CXImagePickerSourceType)sourceType
                       clipEnabled:(BOOL)clipEnabled
                       aspectRatio:(CGFloat)aspectRatio;

+ (instancetype)params;

@end
