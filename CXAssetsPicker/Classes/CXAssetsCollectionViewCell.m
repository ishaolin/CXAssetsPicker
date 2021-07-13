//
//  CXAssetsCollectionViewCell.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsCollectionViewCell.h"
#import "CXAssetsToolBarButtonItem.h"
#import "CXAssetsPickerDefines.h"
#import "PHAsset+CXAssetsPicker.h"
#import "CXAssetsPickerAdapter.h"

static UIColor *_selectedAssetBackgroundColor = nil;
static UIColor *_selectedAssetFontColor = nil;

@interface CXAssetsCollectionViewCell(){
    UIImageView *_displayImageView;
    UIImageView *_videoImageView;
    UIView *_selectedMask;
    CXAssetsToolBarButtonItem *_selectButton;
    UILabel *_videoDurationLabel;
}

@end

@implementation CXAssetsCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CXAssetsCollectionViewCell";
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _displayImageView = [[UIImageView alloc] init];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _selectedMask = [[UIView alloc] init];
        _selectedMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _selectedMask.hidden = YES;
        
        _selectButton = [CXAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _selectButton.enableHighlighted = NO;
        _selectButton.barButtonItemFontSize = 12.0;
        _selectButton.backgroundColor = [UIColor clearColor];
        [_selectButton setImage:[CXAssetsPickerAdapter sharedAdapter].assetNormalStateImage
                       forState:UIControlStateNormal];
        [_selectButton setImage:[CXAssetsPickerAdapter sharedAdapter].assetSelectedStateImage
                       forState:UIControlStateSelected];
        [_selectButton setTitleColor:[CXAssetsPickerAdapter sharedAdapter].toolbarItemFontColor
                            forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(handleActionForSelectButton:)];
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = CX_ASSETS_PICKER_IMAGE(@"assets_picker_list_video");
        _videoImageView.contentMode = UIViewContentModeCenter;
        _videoImageView.hidden = YES;
        
        _videoDurationLabel = [[UILabel alloc] init];
        _videoDurationLabel.textAlignment = NSTextAlignmentRight;
        _videoDurationLabel.textColor = [UIColor whiteColor];
        _videoDurationLabel.font = CX_PingFangSC_RegularFont(11.0);
        
        [self.contentView addSubview:_displayImageView];
        [self.contentView addSubview:_selectedMask];
        [self.contentView addSubview:_selectButton];
        [self.contentView addSubview:_videoImageView];
        [self.contentView addSubview:_videoDurationLabel];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setAllowsSelection:(BOOL)allowsSelection{
    _allowsSelection = allowsSelection;
    _selectButton.hidden = !_allowsSelection;
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    _selectedMask.hidden = !_asset.cx_selected;
    _videoImageView.hidden = _asset.mediaType != PHAssetMediaTypeVideo;
    _videoDurationLabel.hidden = _videoImageView.isHidden;
    _videoDurationLabel.text = [NSDate cx_mediaTimeString:(NSInteger)_asset.duration];
    
    _selectButton.selected = _asset.cx_selected;
    if(_asset.cx_selected){
        _selectButton.barButtonItemTitle = @(_asset.cx_selectedIndex + 1).stringValue;
    }else{
        _selectButton.barButtonItemTitle = nil;
    }
    
    [asset cx_thumbnailWithSize:self.assetSize completion:^(UIImage *image, NSDictionary<NSString *,id> *info) {
        self->_displayImageView.image = image;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _displayImageView.frame = self.bounds;
    _selectedMask.frame = self.bounds;
    
    CGFloat selectButton_W = 25.0;
    CGFloat selectButton_H = selectButton_W;
    CGFloat selectButton_Y = 5.0;
    CGFloat selectButton_X = self.bounds.size.width - selectButton_W - selectButton_Y;
    _selectButton.frame = CGRectMake(selectButton_X, selectButton_Y, selectButton_W, selectButton_H);
    
    CGFloat video_M = 5.0;
    CGFloat videoImageView_W = 16.0;
    CGFloat videoImageView_H = 9.0;
    CGFloat videoImageView_X = video_M;
    CGFloat videoImageView_Y = self.bounds.size.height - videoImageView_H - video_M;
    _videoImageView.frame = CGRectMake(videoImageView_X, videoImageView_Y, videoImageView_W, videoImageView_H);
    
    CGFloat videoDurationLabel_X = CGRectGetMaxX(_videoImageView.frame) + video_M;
    CGFloat videoDurationLabel_H = 20.0;
    CGFloat videoDurationLabel_W = self.bounds.size.width - videoDurationLabel_X - video_M;
    CGFloat videoDurationLabel_Y = self.bounds.size.height - videoDurationLabel_H;
    _videoDurationLabel.frame = CGRectMake(videoDurationLabel_X, videoDurationLabel_Y, videoDurationLabel_W, videoDurationLabel_H);
}

- (void)handleActionForSelectButton:(UIButton *)selectButton{
    if(!selectButton.isSelected && [self.delegate respondsToSelector:@selector(assetsCollectionViewCellShouldSelectAsset:)]){
        if(![self.delegate assetsCollectionViewCellShouldSelectAsset:self]){
            return;
        }
    }
    
    _asset.cx_selected = !_asset.cx_selected;
    if([self.delegate respondsToSelector:@selector(assetsCollectionViewCellDidSelectAsset:)]){
        [self.delegate assetsCollectionViewCellDidSelectAsset:self];
    }
}

@end
