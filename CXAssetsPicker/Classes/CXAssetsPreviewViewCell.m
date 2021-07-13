//
//  CXAssetsPreviewViewCell.m
//  Pods
//
//  Created by wshaolin on 2019/1/18.
//

#import "CXAssetsPreviewViewCell.h"

@interface CXAssetsPreviewViewCell () {
    UILabel *_progressLabel;
}

@end

@implementation CXAssetsPreviewViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"CXAssetsPreviewViewCell";
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundView = nil;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _containerView = [[UIView alloc] init];
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = CX_PingFangSC_RegularFont(14.0);
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_containerView];
        [self.contentView addSubview:_progressLabel];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    _progressLabel.text = [NSString stringWithFormat:@"%.f%%", _progress * 100];
}

- (void)setHideProgressBar:(BOOL)hideProgressBar{
    _progressLabel.hidden = hideProgressBar;
}

- (BOOL)isHideProgressBar{
    return _progressLabel.isHidden;
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.bounds;
    frame.size.width -= CX_ASSETS_IMAGE_SPACING;
    _containerView.frame = frame;
    
    if(self.asset.pixelWidth > 0 && CGRectGetWidth(_containerView.bounds) > 0){
        CGFloat height = self.asset.pixelHeight * CGRectGetWidth(_containerView.bounds) / self.asset.pixelWidth;
        
        CGFloat progressLabel_W = 80.0;
        CGFloat progressLabel_H = 30.0;
        CGFloat progressLabel_X = CGRectGetWidth(self.contentView.bounds) - CX_ASSETS_IMAGE_SPACING - progressLabel_W - 10.0;
        CGFloat progressLabel_Y = MIN(height + (CGRectGetHeight(_containerView.bounds) - height) * 0.5, CGRectGetHeight(_containerView.bounds) - (49.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom)) - progressLabel_H;
        _progressLabel.frame = (CGRect){progressLabel_X, progressLabel_Y, progressLabel_W, progressLabel_H};
    }
}

- (void)handleSingleTouchAction:(UITapGestureRecognizer *)tapGestureRecognizer{
    if([self.delegate respondsToSelector:@selector(assetsPreviewViewCellDidSingleTouch:)]){
        [self.delegate assetsPreviewViewCellDidSingleTouch:self];
    }
}

- (void)willDisplay{
    
}

- (void)endDisplaying{
    
}

- (void)dealloc{
    [self endDisplaying];
}

@end
