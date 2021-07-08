//
//  CXAssetsToolBarButtonItem.h
//  Pods
//
//  Created by wshaolin on 15/7/10.
//

#import <UIKit/UIKit.h>

@interface CXControlHighlightedButton : UIButton

@property (nonatomic, assign) NSUInteger barButtonItemFontSize;
@property (nonatomic, copy) NSString *barButtonItemTitle;

@property (nonatomic, assign, getter = isEnableHighlighted) BOOL enableHighlighted;

- (void)addTarget:(id)target action:(SEL)action;

@end

@interface CXAssetsToolBarButtonItem : CXControlHighlightedButton

@end
