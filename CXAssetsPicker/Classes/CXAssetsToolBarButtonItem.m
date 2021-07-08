//
//  CXAssetsToolBarButtonItem.m
//  Pods
//
//  Created by wshaolin on 15/7/10.
//

#import "CXAssetsToolBarButtonItem.h"
#import <CXUIKit/CXUIKit.h>

@implementation CXControlHighlightedButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.barButtonItemFontSize = 15.0;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.enableHighlighted = YES;
    }
    
    return self;
}

- (void)setBarButtonItemFontSize:(NSUInteger)barButtonItemFontSize{
    _barButtonItemFontSize = barButtonItemFontSize;
    self.titleLabel.font = CX_PingFangSC_RegularFont(_barButtonItemFontSize);
}

- (void)setBarButtonItemTitle:(NSString *)barButtonItemTitle{
    _barButtonItemTitle = barButtonItemTitle;
    [self setTitle:_barButtonItemTitle forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.alpha = 0.5;
    }else{
        self.alpha = 1.0;
    }
    
    if(self.isEnableHighlighted){
        [super setHighlighted:highlighted];
    }
}

- (void)setEnabled:(BOOL)enabled{
    if(enabled){
        self.alpha = 1.0;
    }else{
        self.alpha = 0.5;
    }
    
    [super setEnabled:enabled];
}

@end

@interface CXAssetsToolBarButtonItem () {
    CAKeyframeAnimation *_animation;
}

@end

@implementation CXAssetsToolBarButtonItem

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = CXHexIColor(0x26AB28);
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    NSString *animationKey = @"transform_animation_key";
    if(selected){
        if(_animation){
            return;
        }
        
        if([self imageForState:UIControlStateSelected]){
            _animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            NSValue *value0 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)];
            NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            NSArray *values = @[value0, value1, value2];
            _animation.values = values;
            _animation.duration = 0.25;
            [self.layer addAnimation:_animation forKey:animationKey];
        }
    }else{
        _animation = nil;
        [self.layer removeAnimationForKey:animationKey];
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    imageRect.origin.x = (contentRect.size.width - imageRect.size.width) * 0.5;
    imageRect.origin.y = (contentRect.size.height - imageRect.size.height) * 0.5;
    return imageRect;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self cx_roundedCornerRadii:3.0];
}

@end
