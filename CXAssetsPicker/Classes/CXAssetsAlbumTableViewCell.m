//
//  CXAssetsAlbumTableViewCell.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsAlbumTableViewCell.h"
#import <CXUIKit/CXUIKit.h>
#import "PHFetchResult+CXAssetsPicker.h"

@interface CXAssetsAlbumTableViewCell(){
    UIImageView *_displayImageView;
    UILabel *_displayTextLabel;
    
    UIView *_sectionTopLineView;
    UIView *_sectionBottomLineView;
    UIView *_cellDividingLineView;
}

@end

@implementation CXAssetsAlbumTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"CXAssetsAlbumTableViewCell";
    CXAssetsAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [CXHexIColor(0x9B9B9B) colorWithAlphaComponent:0.1];
        
        _displayImageView = [[UIImageView alloc] init];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _displayTextLabel = [[UILabel alloc] init];
        _displayTextLabel.textAlignment = NSTextAlignmentLeft;
        _displayTextLabel.textColor = [UIColor blackColor];
        _displayTextLabel.font = CX_PingFangSC_MediumFont(16.0);
        
        _sectionTopLineView = [[UIView alloc] init];
        _sectionBottomLineView = [[UIView alloc] init];
        _cellDividingLineView = [[UIView alloc] init];
        
        [self.contentView addSubview:_displayImageView];
        [self.contentView addSubview:_displayTextLabel];
        [self.contentView addSubview:_sectionTopLineView];
        [self.contentView addSubview:_sectionBottomLineView];
        [self.contentView addSubview:_cellDividingLineView];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.showDividingLine = YES;
        self.dividingLineColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    
    return self;
}

- (void)setAssetsAlbum:(PHFetchResult<PHAsset *> *)assetsAlbum{
    _assetsAlbum = assetsAlbum;
    
    [_assetsAlbum cx_requestPosterImage:^(UIImage *image, NSDictionary<NSString *,id> *info) {
        self->_displayImageView.image = image;
    }];
    
    NSString *attributedText = [NSString stringWithFormat:@"%@ {(%@)}", _assetsAlbum.cx_title, @([_assetsAlbum cx_countOfAssets])];
    [_displayTextLabel cx_setAttributedText:attributedText
                           highlightedColor:[UIColor grayColor]
                            highlightedFont:CX_PingFangSC_RegularFont(16.0)];
}

- (void)setFirstRowInSection:(BOOL)firstRowInSection{
    _firstRowInSection = firstRowInSection;
    if(self.isShowDividingLine){
        _sectionTopLineView.hidden = !_firstRowInSection;
    }
}

- (void)setLastRowInSection:(BOOL)lastRowInSection{
    _lastRowInSection = lastRowInSection;
    if(self.isShowDividingLine){
        _sectionBottomLineView.hidden = !_lastRowInSection;
        _cellDividingLineView.hidden = _lastRowInSection;
    }
}

- (void)setDividingLineColor:(UIColor *)dividingLineColor{
    _dividingLineColor = dividingLineColor;
    
    _sectionTopLineView.backgroundColor = _dividingLineColor;
    _sectionBottomLineView.backgroundColor = _dividingLineColor;
    _cellDividingLineView.backgroundColor = _dividingLineColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    
    CGFloat displayImageView_X = margin;
    CGFloat displayImageView_Y = margin * 0.5;
    CGFloat displayImageView_H = self.bounds.size.height - displayImageView_Y * 2;
    CGFloat displayImageView_W = displayImageView_H;
    _displayImageView.frame = CGRectMake(displayImageView_X, displayImageView_Y, displayImageView_W, displayImageView_H);
    
    CGFloat displayTextLabel_X = CGRectGetMaxX(_displayImageView.frame) + margin;
    CGFloat displayTextLabel_Y = displayImageView_Y;
    CGFloat displayTextLabel_H = displayImageView_H;
    CGFloat displayTextLabel_W = self.bounds.size.width - displayTextLabel_X - 30.0;
    _displayTextLabel.frame = CGRectMake(displayTextLabel_X, displayTextLabel_Y, displayTextLabel_W, displayTextLabel_H);
    
    CGFloat lineViewHeight = 0.5;
    
    CGRect sectionTopLineViewFrame = self.bounds;
    sectionTopLineViewFrame.size.height = lineViewHeight;
    _sectionTopLineView.frame = sectionTopLineViewFrame;
    
    CGRect sectionBottomLineViewFrame = sectionTopLineViewFrame;
    sectionBottomLineViewFrame.origin.y = self.bounds.size.height - sectionBottomLineViewFrame.size.height;
    _sectionBottomLineView.frame = sectionBottomLineViewFrame;
    
    CGRect cellDividingLineViewFrame = sectionBottomLineViewFrame;
    cellDividingLineViewFrame.origin.x = displayImageView_X;
    cellDividingLineViewFrame.size.width -= cellDividingLineViewFrame.origin.x;
    _cellDividingLineView.frame = cellDividingLineViewFrame;
}

@end
