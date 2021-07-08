//
//  CXAssetsType.h
//  Pods
//
//  Created by wshaolin on 2019/1/18.
//

#ifndef CXAssetsType_h
#define CXAssetsType_h

#import <CXFoundation/CXFoundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, CXAssetsType){ // Assets type
    CXAssetsAll = 0, // Photo and Video
    CXAssetsPhoto = PHAssetMediaTypeImage,  // Photo
    CXAssetsVideo = PHAssetMediaTypeVideo   // Video
};

#endif /* CXAssetsType_h */
