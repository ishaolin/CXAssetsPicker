//
//  PHImageRequestOptions+CXAssetsPicker.h
//  Pods
//
//  Created by wshaolin on 2021/7/6.
//

#import <Photos/Photos.h>

@interface PHImageRequestOptions (CXAssetsPicker)

+ (instancetype)cx_optionsForOriginal:(BOOL)original;

@end
