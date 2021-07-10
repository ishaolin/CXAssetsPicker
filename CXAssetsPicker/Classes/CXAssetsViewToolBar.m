//
//  CXAssetsViewToolBar.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsViewToolBar.h"
#import "CXAssetsToolBarButtonItem.h"
#import <CXUIKit/CXUIKit.h>
#import "CXAssetsPickerDefines.h"

@interface CXAssetsViewToolBar(){
    UIToolbar *_contentView;
    
    CXControlHighlightedButton *_previewItem;
    CXControlHighlightedButton *_completeItem;
    CXControlHighlightedButton *_originalItem;
}

@end

@implementation CXAssetsViewToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _contentView = [[UIToolbar alloc] init];
        [self addSubview:_contentView];
        
        _previewItem = [CXAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _previewItem.barButtonItemTitle = NSLocalizedString(@"预览", nil);
        [_previewItem addTarget:self action:@selector(didClickPreviewBarButtonItem:)];
        _previewItem.enabled = NO;
        
        _completeItem = [CXAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _completeItem.barButtonItemTitle = NSLocalizedString(@"确定", nil);
        [_completeItem addTarget:self action:@selector(didClickCompleteBarButtonItem:)];
        _completeItem.enabled = NO;
        
        _originalItem = [CXControlHighlightedButton buttonWithType:UIButtonTypeCustom];
        _originalItem.barButtonItemTitle = NSLocalizedString(@"原图", nil);
        _originalItem.backgroundColor = [UIColor clearColor];
        _originalItem.enableHighlighted = NO;
        [_originalItem setImage:[CX_ASSETS_PICKER_IMAGE(@"assets_picker_image_selected_0") cx_imageForTintColor:CXHexIColor(0x26AB28)] forState:UIControlStateNormal];
        [_originalItem setImage:CX_ASSETS_PICKER_IMAGE(@"assets_original_image_selected_1") forState:UIControlStateSelected];
        _originalItem.barButtonItemFontSize = 17;
        _originalItem.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0);
        [_originalItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_originalItem addTarget:self action:@selector(didClickOriginalBarButtonItem:)];
        
        [self addSubview:_previewItem];
        [self addSubview:_completeItem];
        [self addSubview:_originalItem];
    }
    
    return self;
}

- (void)setBarButtonItemBackgroundColor:(UIColor *)barButtonItemBackgroundColor{
    if(barButtonItemBackgroundColor != nil){
        _previewItem.backgroundColor = barButtonItemBackgroundColor;
        _completeItem.backgroundColor = barButtonItemBackgroundColor;
    }
}

- (void)setBarButtonItemFontColor:(UIColor *)barButtonItemFontColor{
    if(barButtonItemFontColor != nil){
        [_previewItem setTitleColor:barButtonItemFontColor forState:UIControlStateNormal];
        [_completeItem setTitleColor:barButtonItemFontColor forState:UIControlStateNormal];
    }
}

- (void)setSendBarButtonItemText:(NSString *)sendBarButtonItemText{
    _sendBarButtonItemText = sendBarButtonItemText;
    
    if(sendBarButtonItemText){
        [self setSelectedCount:_selectedCount];
    }
}

- (void)setHiddenPreviewItem:(BOOL)hiddenPreviewItem{
    _hiddenPreviewItem = hiddenPreviewItem;
    _previewItem.hidden = hiddenPreviewItem;
}

- (void)setSelectedOriginalImage:(BOOL)selectedOriginalImage{
    _selectedOriginalImage = selectedOriginalImage;
    _originalItem.selected = _selectedOriginalImage;
}

- (void)setTranslucent:(BOOL)translucent{
    _translucent = translucent;
    _contentView.translucent = _translucent;
    
    if(_translucent){
        _contentView.barTintColor = nil;
    }else{
        _contentView.barTintColor = [UIColor whiteColor];
    }
}

- (void)didClickPreviewBarButtonItem:(CXAssetsToolBarButtonItem *)barButtonItem{
    if([self.delegate respondsToSelector:@selector(assetsViewToolBarDidPreviewed:)]){
        [self.delegate assetsViewToolBarDidPreviewed:self];
    }
}

- (void)didClickCompleteBarButtonItem:(CXAssetsToolBarButtonItem *)barButtonItem{
    if([self.delegate respondsToSelector:@selector(assetsViewToolBarDidCompleted:)]){
        [self.delegate assetsViewToolBarDidCompleted:self];
    }
}

- (void)didClickOriginalBarButtonItem:(CXAssetsToolBarButtonItem *)barButtonItem{
    self.selectedOriginalImage = !self.isSelectedOriginalImage;
    if([self.delegate respondsToSelector:@selector(assetsViewToolBar:didSelectedOriginalImage:)]){
        [self.delegate assetsViewToolBar:self didSelectedOriginalImage:self.isSelectedOriginalImage];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 0;
    frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 49.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom);
    
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    
    CGFloat item_M = 10.0;
    CGFloat previewItem_W = 60.0;
    CGFloat previewItem_H = 30.0;
    CGFloat previewItem_X = item_M;
    CGFloat previewItem_Y = 9.5;
    _previewItem.frame = CGRectMake(previewItem_X, previewItem_Y, previewItem_W, previewItem_H);
    
    CGFloat completeItem_H = previewItem_H;
    CGFloat completeItem_Y = previewItem_Y;
    CGFloat completeItem_W = [CXStringBounding bounding:_completeItem.barButtonItemTitle
                                           rectWithSize:CGSizeMake(previewItem_W * 2, completeItem_H)
                                                   font:_completeItem.titleLabel.font].size.width + item_M * 2;
    if(completeItem_W < previewItem_W){
        completeItem_W = previewItem_W;
    }
    
    CGFloat completeItem_X = self.bounds.size.width - completeItem_W - item_M;
    _completeItem.frame = CGRectMake(completeItem_X, completeItem_Y, completeItem_W, completeItem_H);
    
    CGFloat originalItem_H = previewItem_H;
    CGFloat originalItem_W = 70.0;
    CGFloat originalItem_Y = previewItem_Y;
    CGFloat originalItem_X = (CGRectGetWidth(self.bounds) - originalItem_W) * 0.5;
    _originalItem.frame = CGRectMake(originalItem_X, originalItem_Y, originalItem_W, originalItem_H);
}

- (void)setEnableMaximumCount:(NSInteger)enableMaximumCount{
    _enableMaximumCount = enableMaximumCount;
    
    self.selectedCount = _selectedCount;
}

- (void)setSelectedCount:(NSInteger)selectedCount{
    _selectedCount = selectedCount;
    _completeItem.enabled = _selectedCount > 0;
    _previewItem.enabled = _completeItem.isEnabled;
    
    NSString *barButtonItemTitle = NSLocalizedString(self.sendBarButtonItemText ?: @"确定", nil);
    if(_selectedCount > 0){
        if(self.enableMaximumCount > 0){
            _completeItem.barButtonItemTitle = [NSString stringWithFormat:@"%@(%@/%@)", barButtonItemTitle, @(_selectedCount), @(self.enableMaximumCount)];
        }else{
            _completeItem.barButtonItemTitle = [NSString stringWithFormat:@"%@(%@)", barButtonItemTitle, @(_selectedCount)];
        }
    }else{
        _completeItem.barButtonItemTitle = barButtonItemTitle;
    }
    
    [self setNeedsLayout];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated{
    if(animated){
        void (^animations)(void) = ^{
            self.transform = CGAffineTransformIdentity;
        };
        
        if(hidden){
            animations = ^{
                self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
            };
        }else{
            self.hidden = NO;
        }
        
        [UIView animateWithDuration:0.25 animations:animations completion:^(BOOL finished) {
            self.hidden = hidden;
        }];
    }else{
        self.hidden = hidden;
    }
}

@end
