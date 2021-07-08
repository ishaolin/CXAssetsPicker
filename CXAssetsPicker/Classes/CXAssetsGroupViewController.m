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

@interface CXAssetsGroupViewController () <UITableViewDataSource, UITableViewDelegate> {
    CXTableView *_tableView;
    NSMutableArray<PHFetchResult<PHAsset *> *> *_assetsGroups;
    UILabel *_noDataLabel;
    UIView *_noDataView;
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
    _tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationBar.frame), 0, [UIScreen mainScreen].cx_safeAreaInsets.bottom, 0);
    [self.view addSubview:_tableView];
    
    _noDataLabel = [[UILabel alloc] init];
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = CX_PingFangSC_RegularFont(18.0);
    _noDataLabel.numberOfLines = 0;
    switch (self.assetsPickerController.assetsType) {
        case CXAssetsPhoto:{
            _noDataLabel.text = NSLocalizedString(@"暂无照片", nil);
        }
            break;
        case CXAssetsVideo:{
            _noDataLabel.text = NSLocalizedString(@"暂无视频", nil);
        }
            break;
        case CXAssetsAll:{
            _noDataLabel.text = NSLocalizedString(@"暂无内容", nil);
        }
            break;
        default:
            break;
    }
    
    CGFloat noDataLabel_X = 20.0;
    CGFloat noDataLabel_H = 200.0;
    CGFloat noDataLabel_W = self.view.bounds.size.width - noDataLabel_X * 2;
    CGFloat noDataLabel_Y = (self.view.bounds.size.height - noDataLabel_H) * 0.5;
    _noDataLabel.frame = CGRectMake(noDataLabel_X, noDataLabel_Y, noDataLabel_W, noDataLabel_H);
    
    _noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    _noDataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _noDataView.backgroundColor = self.view.backgroundColor;
    _noDataView.hidden = YES;
    [_noDataView addSubview:_noDataLabel];
    [self.view addSubview:_noDataView];
    
    [self loadAssetsGroups];
}

- (void)didClickCancelBarButtonItem:(CXBarButtonItem *)barButtonItem{
    [self pickerCancel];
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
                NSString *bundleDisplayName = [NSBundle mainBundle].cx_appName;
                NSString *error = NSLocalizedString(@"您目前拒绝\"%@\"访问相册，请在\"设置\"->\"隐私\"->\"照片\"中找到\"%@\"，打开相册访问权限。", nil);
                self->_noDataLabel.text = [NSString stringWithFormat:error, bundleDisplayName, bundleDisplayName];
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
