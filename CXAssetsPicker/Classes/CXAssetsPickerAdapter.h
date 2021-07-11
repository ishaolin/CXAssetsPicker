//
//  CXAssetsPickerAdapter.h
//  CXAssetsPicker
//
//  Created by wshaolin on 2021/7/11.
//

#import "CXAssetsPickerDefines.h"

@interface CXAssetsPickerAdapter : NSObject

@property (nonatomic, strong) UIColor *toolbarItemBackgroundColor;
@property (nonatomic, strong) UIColor *toolbarItemFontColor;
@property (nonatomic, copy) NSString *toolbarSendItemText;
@property (nonatomic, assign, getter = isSelectedOriginalImage) BOOL selectedOriginalImage;

@property (nonatomic, strong, readonly) UIImage *assetNormalStateImage;
@property (nonatomic, strong, readonly) UIImage *assetSelectedStateImage;
@property (nonatomic, strong, readonly) UIImage *originalImageOptionNormalStateImage;
@property (nonatomic, strong, readonly) UIImage *originalImageOptionSelectedStateImage;

+ (instancetype)sharedAdapter;

+ (void)destroyAdapter;

@end
