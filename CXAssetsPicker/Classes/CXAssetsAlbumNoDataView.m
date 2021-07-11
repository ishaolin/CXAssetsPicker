//
//  CXAssetsAlbumNoDataView.m
//  CXAssetsPicker
//
//  Created by wshaolin on 2021/7/10.
//

#import "CXAssetsAlbumNoDataView.h"
#import "CXAssetsToolBarButtonItem.h"
#import "CXAssetsPickerAdapter.h"

@interface CXAssetsAlbumNoDataView (){
    UILabel *_tipsLabel;
    CXAssetsToolBarButtonItem *_authorizeButton;
}

@end

@implementation CXAssetsAlbumNoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor lightGrayColor];
        _tipsLabel.font = CX_PingFangSC_RegularFont(17.0);
        _tipsLabel.numberOfLines = 0;
        
        _authorizeButton = [CXAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _authorizeButton.barButtonItemTitle = NSLocalizedString(@"前往授权", nil);
        _authorizeButton.barButtonItemFontSize = 17;
        _authorizeButton.backgroundColor = [CXAssetsPickerAdapter sharedAdapter].toolbarItemBackgroundColor;
        [_authorizeButton setTitleColor:[CXAssetsPickerAdapter sharedAdapter].toolbarItemFontColor
                               forState:UIControlStateNormal];
        [_authorizeButton addTarget:self action:@selector(didClickAuthorizeButton:)];
        
        [self addSubview:_tipsLabel];
        [self addSubview:_authorizeButton];
    }
    
    return self;
}

- (void)didClickAuthorizeButton:(CXAssetsToolBarButtonItem *)button{
    if([self.delegate respondsToSelector:@selector(assetsAlbumNoDataViewDidOpenAuthorization:)]){
        [self.delegate assetsAlbumNoDataViewDidOpenAuthorization:self];
    }
}

- (void)setNoDataTips:(NSString *)tips authorized:(BOOL)authorized{
    _tipsLabel.text = tips;
    _authorizeButton.hidden = authorized;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat authorizeButton_W = 110.0;
    CGFloat authorizeButton_H = 40.0;
    
    CGFloat tipsLabel_X = 0;
    CGFloat tipsLabel_W = CGRectGetWidth(self.bounds);
    CGFloat tipsLabel_H = [CXStringBounding bounding:_tipsLabel.text
                                        rectWithSize:CGSizeMake(tipsLabel_W, 200.0)
                                                font:_tipsLabel.font].size.height;
    CGFloat tipsLabel_Y = (CGRectGetHeight(self.bounds) - tipsLabel_H - authorizeButton_H) * 0.5 - 100.0;
    _tipsLabel.frame = (CGRect){tipsLabel_X, tipsLabel_Y, tipsLabel_W, tipsLabel_H};
    
    CGFloat authorizeButton_X = (CGRectGetWidth(self.bounds) - authorizeButton_W) * 0.5;
    CGFloat authorizeButton_Y = CGRectGetMaxY(_tipsLabel.frame) + 20.0;
    _authorizeButton.frame = (CGRect){authorizeButton_X, authorizeButton_Y, authorizeButton_W, authorizeButton_H};
}

@end
