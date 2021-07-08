//
//  CXAssetsPreviewVideoCell.m
//  Pods
//
//  Created by wshaolin on 2019/1/18.
//

#import "CXAssetsPreviewVideoCell.h"
#import "PHImageRequestOptions+CXAssetsPicker.h"

@interface CXAssetsPreviewVideoCell () <CXVideoPlayerDelegate> {
    CXVideoPlayer *_videoPlayer;
}

@end

@implementation CXAssetsPreviewVideoCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"CXAssetsPreviewVideoCell";
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _videoPlayer = [[CXVideoPlayer alloc] init];
        _videoPlayer.delegate = self;
        [self.containerView addSubview:_videoPlayer];
    }
    
    return self;
}

- (void)setAsset:(PHAsset *)asset{
    [super setAsset:asset];
    
    [_videoPlayer hidePlayControl];
    
    CGFloat scale = MAX([UIScreen mainScreen].scale, 1.0);
    [asset cx_thumbnailWithSize:CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale) completion:^(UIImage *image, NSDictionary<NSString *,id> *info) {
        if(image){
            self->_videoPlayer.snapshotView.image = image;
        }
        
        if([info[PHImageResultIsDegradedKey] boolValue] || [info[PHImageResultIsInCloudKey] boolValue]){
            PHImageRequestOptions *options = [PHImageRequestOptions cx_options];
            [CXAssetsImageManager requestImageDataForAsset:asset options:options completion:^(PHAsset *asset, CXAssetsElementImage *image) {
                if(self.asset != asset){
                    return;
                }
                
                if(image.image){
                    self->_videoPlayer.snapshotView.image = image.image;
                }
            }];
        }
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        if([info[PHImageResultIsInCloudKey] boolValue]){
            options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                [CXDispatchHandler asyncOnMainQueue:^{
                    self.progress = progress;
                }];
            };
            self.hideProgressBar = NO;
        }else{
            self.hideProgressBar = YES;
            [self->_videoPlayer showIndicator];
        }
        
        [CXAssetsImageManager requestPlayerItemForVideo:asset options:options completion:^(PHAsset *asset, AVPlayerItem *playerItem, NSDictionary<NSString *,id> *info) {
            if(self.asset != asset){
                return;
            }
            
            [self->_videoPlayer setPlayerItem:playerItem];
            self.hideProgressBar = YES;
            [self->_videoPlayer hideIndicator];
        }];
    }];
}

- (void)endDisplaying{
    [super endDisplaying];
    
    [_videoPlayer pause];
    [_videoPlayer hideIndicator];
}

- (void)videoPlayer:(CXVideoPlayer *)videoPlayer didTapWithPlayStatus:(CXVideoPlayStatus)playStatus playControlStatus:(BOOL)hidden{
    [self handleSingleTouchAction:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _videoPlayer.frame = self.containerView.bounds;
}

@end
