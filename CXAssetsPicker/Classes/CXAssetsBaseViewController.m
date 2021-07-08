//
//  CXAssetsBaseViewController.m
//  Pods
//
//  Created by wshaolin on 2019/1/10.
//

#import "CXAssetsBaseViewController.h"

@implementation CXAssetsBaseViewController

- (CXAssetsPickerController *)assetsPickerController{
    if([self.navigationController isKindOfClass:[CXAssetsPickerController class]]){
        return (CXAssetsPickerController *)self.navigationController;
    }
    
    return nil;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.navigationBar.navigationItem.titleView setTitleColor:[UIColor blackColor]];
    [self.navigationBar.navigationItem.titleView setTitleFont:CX_PingFangSC_MediumFont(17.0)];
}

@end
