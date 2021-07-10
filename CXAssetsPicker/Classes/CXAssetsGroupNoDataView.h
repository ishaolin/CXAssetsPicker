//
//  CXAssetsGroupNoDataView.h
//  CXAssetsPicker
//
//  Created by wshaolin on 2021/7/10.
//

#import <UIKit/UIKit.h>

@class CXAssetsGroupNoDataView;

@protocol CXAssetsGroupNoDataViewDelegate <NSObject>

@optional

- (void)assetsGroupNoDataViewDidOpenAuthorization:(CXAssetsGroupNoDataView *)view;

@end

@interface CXAssetsGroupNoDataView : UIView

@property (nonatomic, weak) id<CXAssetsGroupNoDataViewDelegate> delegate;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *buttonFontColor;

- (void)setNoDataTips:(NSString *)tips authorized:(BOOL)authorized;

@end
