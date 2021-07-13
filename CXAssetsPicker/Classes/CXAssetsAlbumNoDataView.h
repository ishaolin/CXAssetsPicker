//
//  CXAssetsAlbumNoDataView.h
//  Pods
//
//  Created by wshaolin on 2021/7/10.
//

#import <UIKit/UIKit.h>

@class CXAssetsAlbumNoDataView;

@protocol CXAssetsAlbumNoDataViewDelegate <NSObject>

@optional
- (void)assetsAlbumNoDataViewDidOpenAuthorization:(CXAssetsAlbumNoDataView *)view;

@end

@interface CXAssetsAlbumNoDataView : UIView

@property (nonatomic, weak) id<CXAssetsAlbumNoDataViewDelegate> delegate;

- (void)setNoDataTips:(NSString *)tips authorized:(BOOL)authorized;

@end
