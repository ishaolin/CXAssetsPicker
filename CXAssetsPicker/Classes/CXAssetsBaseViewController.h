//
//  CXAssetsBaseViewController.h
//  Pods
//
//  Created by wshaolin on 2019/1/10.
//

#import <CXUIKit/CXUIKit.h>
#import "CXAssetsPickerController.h"

@interface CXAssetsBaseViewController : CXBaseViewController

@property (nonatomic, weak, readonly) CXAssetsPickerController *assetsPickerController;

@end
