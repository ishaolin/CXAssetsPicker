//
//  CXImagePickerController.m
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import "CXImagePickerController.h"
#import <Photos/Photos.h>
#import <CXFoundation/CXFoundation.h>
#import "CXImageClipViewController.h"
#import "CXAssetsPickerController.h"
#import "CXAssetsImageManager.h"
#import "PHImageRequestOptions+CXAssetsPicker.h"
#import <objc/runtime.h>

@interface CXImagePickerController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CXAssetsPickerControllerDelegate, CXImageClipViewControllerDelegate>{
    
}

@property (nonatomic, copy) CXImagePickerCompletionBlock completion;

@end

@implementation CXImagePickerController

+ (instancetype)showFromViewController:(UIViewController *)viewController
                                params:(CXImagePickerParams *)params
                            completion:(CXImagePickerCompletionBlock)completion{
    CXImagePickerController *pickerController = [[self alloc] initWithFromViewController:viewController];
    pickerController->_params = params;
    pickerController.completion = completion;
    [pickerController invoke];
    return pickerController;
}

- (void)invoke{
    [super invoke];
    
    switch (_params.sourceType) {
        case CXImagePickerSourceTypeCamera:{
            [self checkCameraAuthorization];
        }
            break;
        case CXImagePickerSourceTypeAlbum:{
            [self checkPhotosAlbumAuthorization];
        }
            break;
        case CXImagePickerSourceTypeBothAll:{
            [CXActionSheetUtils showActionSheetWithConfigBlock:^(CXActionSheetControllerConfigModel *config) {
                config.buttonTitles = @[@"从相册选择", @"使用相机"];
                config.cancelButtonTitle = @"取消";
                config.viewController = self.fromViewController;
            } completion:^(NSInteger buttonIndex) {
                if(buttonIndex == CXActionSheetCancelButtonIndex){
                    !self.cancelActionBlock ?: self.cancelActionBlock(self);
                    [self handleCancelWithSourceType:0];
                }else if(buttonIndex == 0){
                    !self.albumActionBlock ?: self.albumActionBlock(self);
                    [self checkPhotosAlbumAuthorization];
                }else{
                    !self.cameraActionBlock ?: self.cameraActionBlock(self);
                    [self checkCameraAuthorization];
                }
            } cancelBlock:^{
                !self.cancelActionBlock ?: self.cancelActionBlock(self);
                [self handleCancelWithSourceType:0];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)handleFinishImage:(UIImage *)image
             base64String:(NSString *)base64String
                    state:(CXPickerFinishState)state
               sourceType:(UIImagePickerControllerSourceType)sourceType{
    !self.completion ?: self.completion(self, image, base64String, state, sourceType);
    [self finish];
}

- (void)handleSelectedImage:(UIImage *)image completion:(void (^)(NSString *))completion{
    if(image){
        [CXImageUtils imageBase64:@[image] completion:^(NSArray<NSString *> *base64Images) {
            !completion ?: completion(base64Images.firstObject);
        }];
    }else{
        [CXHUD dismiss];
        !completion ?: completion(nil);
    }
}

- (void)handleSelectedImage:(UIImage *)image sourceType:(UIImagePickerControllerSourceType)sourceType{
    if(_params.isBase64Output){
        [CXHUD showHUDAddedTo:nil msg:@"图片处理中..." animated:YES];
        [self handleSelectedImage:image completion:^(NSString *base64Image) {
            [CXHUD dismissForView:nil animated:NO completion:NULL];
            [self handleFinishImage:image
                       base64String:base64Image
                              state:CXPickerFinishStateSucceed
                         sourceType:sourceType];
        }];
    }else{
        [self handleFinishImage:image
                   base64String:nil
                          state:CXPickerFinishStateSucceed
                     sourceType:sourceType];
    }
}

- (void)checkPhotosAlbumAuthorization{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    switch (authorizationStatus) {
        case PHAuthorizationStatusNotDetermined:{
            // 调起相册，会提示用户进行授权，目前还不能监听用户的授权结果
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
            break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:{
            // 用户明确地拒绝授权，或者相册设备无法访问
            [self handleFinishImage:nil
                       base64String:nil
                              state:CXPickerFinishStateUnauthorized
                         sourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
            break;
        case PHAuthorizationStatusAuthorized:{
            // 已经开启授权，调起相册
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
            break;
        default:
            break;
    }
}

- (void)checkCameraAuthorization{
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch(authorizationStatus){
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话框没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                [CXDispatchHandler asyncOnMainQueue:^{
                    if(granted){ // 用户已授权访问相机
                        [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                    }else{
                        // 用户拒绝访问相机
                        [self handleFinishImage:nil
                                   base64String:nil
                                          state:CXPickerFinishStateUnauthorized
                                     sourceType:UIImagePickerControllerSourceTypeCamera];
                    }
                }];
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，调起相机
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:{
            // 用户明确地拒绝授权，或者相机设备无法访问
            [self handleFinishImage:nil
                       base64String:nil
                              state:CXPickerFinishStateUnauthorized
                         sourceType:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        default:
            break;
    }
}

- (void)presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        UIViewController *viewController = nil;
        if(sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = sourceType;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            viewController = imagePickerController;
        }else{
            CXAssetsPickerController *assetsPickerController = [[CXAssetsPickerController alloc] initWithAssetsType:CXAssetsPhoto];
            assetsPickerController.delegate = self;
            assetsPickerController.finishedDismissViewController = NO;
            assetsPickerController.enableMaximumCount = 1;
            assetsPickerController.multiSelectionMode = NO;
            viewController = assetsPickerController;
        }
        
        [self setContentController:viewController];
    }else{
        [self handleFinishImage:nil
                   base64String:nil
                          state:CXPickerFinishStateFailed
                     sourceType:sourceType];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self handleCancelWithSourceType:picker.sourceType];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(!image){
        return;
    }
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        // 保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    }
    
    if(_params.isClipEnabled){
        CXImageClipViewController *imageClipViewController = [[CXImageClipViewController alloc] initWithImage:image aspectRatio:_params.aspectRatio sourceType:picker.sourceType];
        imageClipViewController.delegate = self;
        [picker pushViewController:imageClipViewController animated:YES];
    }else{
        [self handleSelectedImage:image sourceType:picker.sourceType];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)imageClipViewControllerDidCancel:(CXImageClipViewController *)clipViewController{
    if(clipViewController.sourceType == UIImagePickerControllerSourceTypeCamera){
        [self handleCancelWithSourceType:clipViewController.sourceType];
    }
}

- (void)imageClipViewController:(CXImageClipViewController *)clipViewController didFinishedEditingImage:(UIImage *)editedImage{
    [self handleSelectedImage:editedImage sourceType:clipViewController.sourceType];
    [clipViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetsPickerControllerDidCancel:(CXAssetsPickerController *)assetsPickerController{
    [self handleCancelWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)assetsPickerController:(CXAssetsPickerController *)assetsPickerController didFinishPickingAssets:(NSArray<PHAsset *> *)assets assetsType:(CXAssetsType)assetsType{
    PHImageRequestOptions *options = [PHImageRequestOptions cx_optionsForOriginal:YES];
    [CXHUD showHUD];
    [CXAssetsImageManager requestImageDataForAsset:assets.firstObject options:options completion:^(PHAsset *asset, CXAssetsElementImage *image) {
        [CXHUD dismiss];
        if(!image.image){
            return;
        }
        
        if(self->_params.isClipEnabled){
            CXImageClipViewController *viewController = [[CXImageClipViewController alloc] initWithImage:image.image aspectRatio:self->_params.aspectRatio sourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            viewController.delegate = self;
            [assetsPickerController pushViewController:viewController animated:YES];
        }else{
            [self handleSelectedImage:image.image sourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (void)handleCancelWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    [self handleFinishImage:nil
               base64String:nil
                      state:CXPickerFinishStateCancelled
                 sourceType:sourceType];
}

@end

@implementation CXImagePickerParams

- (instancetype)initWithSourceType:(CXImagePickerSourceType)sourceType
                       clipEnabled:(BOOL)clipEnabled
                       aspectRatio:(CGFloat)aspectRatio{
    if(self = [super init]){
        _sourceType = sourceType;
        _clipEnabled = clipEnabled;
        _aspectRatio = aspectRatio;
        _base64Output = NO;
    }
    
    return self;
}

+ (instancetype)params{
    return [[self alloc] initWithSourceType:CXImagePickerSourceTypeBothAll
                                clipEnabled:YES
                                aspectRatio:1.0];
}

@end
