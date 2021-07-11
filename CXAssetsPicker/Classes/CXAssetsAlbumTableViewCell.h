//
//  CXAssetsAlbumTableViewCell.h
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface CXAssetsAlbumTableViewCell : UITableViewCell

@property (nonatomic, assign, getter = isShowDividingLine) BOOL showDividingLine;
@property (nonatomic, assign, getter = isFirstRowInSection) BOOL firstRowInSection;
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;

@property (nonatomic, strong) UIColor *dividingLineColor;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assetsAlbum;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
