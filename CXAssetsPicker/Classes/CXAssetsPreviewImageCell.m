//
//  CXAssetsPreviewImageCell.m
//  Pods
//
//  Created by wshaolin on 2019/1/18.
//

#import "CXAssetsPreviewImageCell.h"
#import "PHImageRequestOptions+CXAssetsPicker.h"

@interface CXAssetsPreviewImageCell () <CXZoomingViewDelegate> {
    CXZoomingView *_imageView;
}

@end

@implementation CXAssetsPreviewImageCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"CXAssetsPreviewImageCell";
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _imageView = [[CXZoomingView alloc] init];
        _imageView.delegate = self;
        
        [self.containerView addSubview:_imageView];
    }
    
    return self;
}

- (void)setAsset:(PHAsset *)asset{
    [super setAsset:asset];
    
    CGFloat scale = MAX([UIScreen mainScreen].scale, 1.0);
    [asset cx_thumbnailWithSize:CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale) completion:^(UIImage *image, NSDictionary<NSString *,id> *info) {
        if(image){
            [self->_imageView setImage:image];
        }
        
        if([info[PHImageResultIsDegradedKey] boolValue] || [info[PHImageResultIsInCloudKey] boolValue]){
            PHImageRequestOptions *options = [PHImageRequestOptions cx_options];
            self.hideProgressBar = NO;
            
            options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                [CXDispatchHandler asyncOnMainQueue:^{
                    self.progress = progress;
                }];
            };
            
            [CXAssetsImageManager requestImageDataForAsset:asset options:options completion:^(PHAsset *asset, CXAssetsElementImage *image) {
                if(self.asset != asset){
                    return;
                }
                
                if(image.image){
                    [self->_imageView setImage:image.image];
                }
                self.hideProgressBar = YES;
            }];
        }else{
            self.hideProgressBar = YES;
        }
    }];
}

- (void)zoomingViewDidSingleTapEvent:(CXZoomingView *)zoomingView{
    [self handleSingleTouchAction:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _imageView.frame = self.containerView.bounds;
}

@end
