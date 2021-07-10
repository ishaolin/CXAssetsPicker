//
//  CXAssetsGroupViewController.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsGroupViewController.h"
#import "CXAssetsViewController.h"
#import "CXAssetsGroupTableViewCell.h"
#import "PHFetchResult+CXExtensions.h"
#import "CXAssetsGroupNoDataView.h"

@interface CXAssetsGroupViewController () <UITableViewDataSource, UITableViewDelegate, CXAssetsGroupNoDataViewDelegate> {
    CXTableView *_tableView;
    CXAssetsGroupNoDataView *_noDataView;
    NSMutableArray<PHFetchResult<PHAsset *> *> *_assetsGroups;
}

@end

@implementation CXAssetsGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"相簿", nil);
    self.navigationBar.translucent = YES;
    self.navigationBar.hiddenBottomHorizontalLine = NO;
    self.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) target:self action:@selector(didClickCancelBarButtonItem:)];
    
    _assetsGroups = [NSMutableArray array];
    _tableView = [[CXTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationBar.frame), 0, [UIScreen mainScreen].cx_safeAreaInsets.bottom, 0);
    [self.view addSubview:_tableView];
    
    _noDataView = [[CXAssetsGroupNoDataView alloc] init];
    _noDataView.buttonBackgroundColor = self.assetsPickerController.toolbarItemBackgroundColor;
    _noDataView.buttonFontColor = self.assetsPickerController.toolbarItemFontColor;
    _noDataView.delegate = self;
    _noDataView.hidden = YES;
    CGFloat noDataView_X = 20.0;
    CGFloat noDataView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat noDataView_W = CGRectGetWidth(self.view.bounds) - noDataView_X * 2;
    CGFloat noDataView_H = CGRectGetHeight(self.view.bounds) - noDataView_Y;
    _noDataView.frame = CGRectMake(noDataView_X, noDataView_Y, noDataView_W, noDataView_H);
    [self.view addSubview:_noDataView];
    
    [self setNoDataViewTips];
    [self loadAssetsGroups];
}

- (void)setNoDataViewTips{
    switch (self.assetsPickerController.assetsType) {
        case CXAssetsPhoto:{
            [_noDataView setNoDataTips:NSLocalizedString(@"暂无照片", nil) authorized:YES];
        }
            break;
        case CXAssetsVideo:{
            [_noDataView setNoDataTips:NSLocalizedString(@"暂无视频", nil) authorized:YES];
        }
            break;
        case CXAssetsAll:{
            [_noDataView setNoDataTips:NSLocalizedString(@"暂无内容", nil) authorized:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didClickCancelBarButtonItem:(CXBarButtonItem *)barButtonItem{
    [self pickerCancel:YES];
}

- (void)assetsGroupNoDataViewDidOpenAuthorization:(CXAssetsGroupNoDataView *)view{
    [CXAppUtils openSettingsPageWithCompletion:^(BOOL success) {
        if(!success){
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pickerCancel:NO];
        });
    }];
}

- (void)loadAssetsGroups{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        [CXDispatchHandler asyncOnMainQueue:^{
            if(status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized){
                PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHFetchResult<PHAsset *> *assetsGroup = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
                    if(!assetsGroup){
                        return;
                    }
                    assetsGroup.cx_mediaType = self.assetsPickerController.assetsType;
                    assetsGroup.cx_title = obj.localizedTitle;
                    
                    if(assetsGroup.cx_countOfAssets > 0 || self.assetsPickerController.isShowEmptyGroups){
                        [self->_assetsGroups addObject:assetsGroup];
                    }
                }];
                
                [self->_assetsGroups sortUsingComparator:^NSComparisonResult(PHFetchResult<PHAsset *> * _Nonnull obj1, PHFetchResult<PHAsset *> * _Nonnull obj2) {
                    return [@(obj2.cx_countOfAssets) compare:@(obj1.cx_countOfAssets)];
                }];
                
                if(self->_assetsGroups.firstObject){
                    CXAssetsViewController *VC = [[CXAssetsViewController alloc] init];
                    [VC setAssetsGroup:self->_assetsGroups.firstObject];
                    VC.delegate = self;
                    [self.navigationController pushViewController:VC animated:NO];
                }
            }else{
                NSString *displayName = [NSBundle mainBundle].cx_displayName;
                NSString *tips = [NSString stringWithFormat:@"应用“%@”没有相册访问权限", displayName];
                [_noDataView setNoDataTips:tips authorized:NO];
                self.navigationBar.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"关闭", nil);
            }
            
            [self reloadData];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXAssetsGroupTableViewCell *cell = [CXAssetsGroupTableViewCell cellWithTableView:tableView];
    cell.firstRowInSection = indexPath.row == 0;
    cell.lastRowInSection = (indexPath.row == _assetsGroups.count - 1);
    cell.assetsGroup = _assetsGroups[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXAssetsViewController *VC = [[CXAssetsViewController alloc] init];
    [VC setAssetsGroup:_assetsGroups[indexPath.row]];
    VC.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}

- (void)reloadData{
    _tableView.hidden = CXArrayIsEmpty(_assetsGroups);
    _noDataView.hidden = !_tableView.isHidden;
    [_tableView reloadData];
}

@end
