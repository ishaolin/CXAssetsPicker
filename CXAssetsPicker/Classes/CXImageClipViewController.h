//
//  CXImageClipViewController.h
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import <UIKit/UIKit.h>

@class CXImageClipViewController;

@protocol CXImageClipViewControllerDelegate <NSObject>

@optional
- (void)imageClipViewControllerDidCancel:(CXImageClipViewController *)viewController;
- (void)imageClipViewController:(CXImageClipViewController *)viewController
        didFinishedEditingImage:(UIImage *)image;

@end

@interface CXImageClipViewController : UIViewController

@property (nonatomic, weak) id<CXImageClipViewControllerDelegate> delegate;
@property (nonatomic, assign, readonly) UIImagePickerControllerSourceType sourceType;

- (instancetype)initWithImage:(UIImage *)image
                  aspectRatio:(CGFloat)aspectRatio
                   sourceType:(UIImagePickerControllerSourceType)sourceType;

@end

typedef NS_ENUM(NSInteger, CXImageClipToolBarItemType){
    CXImageClipToolBarItemCancel   = 0,
    CXImageClipToolBarItemRecovery = 1,
    CXImageClipToolBarItemComplete = 2
};

@class CXImageClipToolBar;

@protocol CXImageClipToolBarDelegate <NSObject>

@optional
- (void)imageClipToolBar:(CXImageClipToolBar *)toolBar
     handleActionForItem:(CXImageClipToolBarItemType)itemType;

@end

@interface CXImageClipToolBar : UIView

@property (nonatomic, weak) id<CXImageClipToolBarDelegate> delegate;

- (void)setItemEnabled:(BOOL)enabled forType:(CXImageClipToolBarItemType)type;

@end
