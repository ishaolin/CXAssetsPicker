//
//  CXImageClipViewController.m
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import "CXImageClipViewController.h"
#import <JPImageresizerView/JPImageresizerView.h>
#import <CXUIKit/CXUIKit.h>

@interface CXImageClipViewController () <CXImageClipToolBarDelegate> {
    JPImageresizerView *_imageView;
    JPImageresizerConfigure *_config;
}

@property (nonatomic, strong, readonly) CXImageClipToolBar *toolBar;

@end

@implementation CXImageClipViewController

- (instancetype)initWithImage:(UIImage *)image
                  aspectRatio:(CGFloat)aspectRatio
                   sourceType:(UIImagePickerControllerSourceType)sourceType{
    if(self = [super init]){
        _sourceType = sourceType;
        
        _config = [JPImageresizerConfigure defaultConfigureWithImage:image make:^(JPImageresizerConfigure *configure) {
            configure.maskAlpha = 0.8;
            configure.strokeColor = CXHexIColor(0xE5E5E5);
            configure.frameType = JPClassicFrameType;
            configure.isClockwiseRotation = YES;
            configure.animationCurve = JPAnimationCurveEaseInOut;
            configure.resizeWHScale = aspectRatio;
        }];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    @weakify(self)
    _config.viewFrame = self.view.bounds;
    _imageView = [JPImageresizerView imageresizerViewWithConfigure:_config imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        @strongify(self)
        [self.toolBar setItemEnabled:isCanRecovery forType:CXImageClipToolBarItemRecovery];
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        @strongify(self)
        [self.toolBar setItemEnabled:!isPrepareToScale forType:CXImageClipToolBarItemComplete];
    }];
    [self.view addSubview:_imageView];
    
    _toolBar = [[CXImageClipToolBar alloc] init];
    _toolBar.delegate = self;
    CGFloat toolBar_X = 0;
    CGFloat toolBar_W = CGRectGetWidth(self.view.bounds);
    CGFloat toolBar_H = 49.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    CGFloat toolBar_Y = CGRectGetHeight(self.view.bounds) - toolBar_H;
    _toolBar.frame = (CGRect){toolBar_X, toolBar_Y, toolBar_W, toolBar_H};
    [self.view addSubview:_toolBar];
}

- (void)imageClipToolBar:(CXImageClipToolBar *)toolBar handleActionForItem:(CXImageClipToolBarItemType)itemType{
    switch (itemType) {
        case CXImageClipToolBarItemCancel:{
            if([self.delegate respondsToSelector:@selector(imageClipViewControllerDidCancel:)]){
                [self.delegate imageClipViewControllerDidCancel:self];
            }
            
            if(_sourceType == UIImagePickerControllerSourceTypeCamera){
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case CXImageClipToolBarItemRecovery:{
            [_imageView recoveryByInitialResizeWHScale:NO];
        }
            break;
        case CXImageClipToolBarItemComplete:{
            if([self.delegate respondsToSelector:@selector(imageClipViewController:didFinishedEditingImage:)]){
                [_imageView cropPictureWithCacheURL:nil errorBlock:^(NSURL * _Nullable cacheURL, JPImageresizerErrorReason reason) {
                    [CXHUD showMsg:@"操作失败"];
                } completeBlock:^(JPImageresizerResult * _Nullable result) {
                    [self.delegate imageClipViewController:self didFinishedEditingImage:result.image];
                }];
            }
        }
            break;
        default:
            break;
    }
}

@end

@interface CXImageClipToolBar () {
    NSMutableArray<UIButton *> *_itemButtons;
    UIView *_lineView;
}

@end

@implementation CXImageClipToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _itemButtons = [NSMutableArray array];
        [@[@"取消", @"还原", @"完成"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            itemButton.titleLabel.font = CX_PingFangSC_RegularFont(16.0);
            [itemButton setTitle:obj forState:UIControlStateNormal];
            [itemButton setTitleColor:CXHexIColor(0xFFFFFF) forState:UIControlStateNormal];
            [itemButton setTitleColor:CXHexIColor(0x999999) forState:UIControlStateHighlighted];
            [itemButton setTitleColor:CXHexIColor(0x494949) forState:UIControlStateDisabled];
            [itemButton addTarget:self action:@selector(handleActionForItemButton:) forControlEvents:UIControlEventTouchUpInside];
            itemButton.tag = idx;
            [self addSubview:itemButton];
            [self->_itemButtons addObject:itemButton];
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXHexIColor(0x2B2B2B);
        [self addSubview:_lineView];
        
        [self setItemEnabled:NO forType:CXImageClipToolBarItemRecovery];
    }
    
    return self;
}

- (void)setItemEnabled:(BOOL)enabled forType:(CXImageClipToolBarItemType)type{
    _itemButtons[type].enabled = enabled;
}

- (void)handleActionForItemButton:(UIButton *)itemButton{
    if([self.delegate respondsToSelector:@selector(imageClipToolBar:handleActionForItem:)]){
        [self.delegate imageClipToolBar:self handleActionForItem:itemButton.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineView_X = 0;
    CGFloat lineView_Y = 0;
    CGFloat lineView_W = CGRectGetWidth(self.bounds);
    CGFloat lineView_H = 0.5;
    _lineView.frame = (CGRect){lineView_X, lineView_Y, lineView_W, lineView_H};
    
    CGFloat itemButton_W = 65.0;
    CGFloat itemButton_H = 32.0;
    CGFloat itemButton_M = (CGRectGetWidth(self.bounds) - itemButton_W * _itemButtons.count) / (_itemButtons.count - 1);
    CGFloat itemButton_Y = CGRectGetMaxY(_lineView.frame) + 10.0;
    [_itemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemButton_X = (itemButton_W + itemButton_M) * idx;
        obj.frame = (CGRect){itemButton_X, itemButton_Y, itemButton_W, itemButton_H};
    }];
}

@end
