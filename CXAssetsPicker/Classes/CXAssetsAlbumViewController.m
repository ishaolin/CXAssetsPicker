//
//  CXAssetsAlbumViewController.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsAlbumViewController.h"
#import "CXAssetsViewController.h"
#import "CXAssetsAlbumTableViewCell.h"
#import "PHFetchResult+CXAssetsPicker.h"
#import "CXAssetsAlbumNoDataView.h"
#import "CXAssetsPickerAdapter.h"

@interface CXAssetsAlbumViewController () <UITableViewDataSource, UITableViewDelegate, CXAssetsAlbumNoDataViewDelegate> {
    CXTableView *_tableView;
    CXAssetsAlbumNoDataView *_noDataView;
    NSMutableArray<PHFetchResult<PHAsset *> *> *_assetsAlbums;
    PHAuthorizationStatus _authorizationStatus;
}

@end

@implementation CXAssetsAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CXAssetsPickerAdapter *adapter = [CXAssetsPickerAdapter sharedAdapter];
    adapter.toolbarItemBackgroundColor = self.pickerController.toolbarItemBackgroundColor;
    adapter.toolbarItemFontColor = self.pickerController.toolbarItemFontColor;
    adapter.toolbarSendItemText = self.pickerController.toolbarSendItemText;
    
    self.title = NSLocalizedString(@"相簿", nil);
    self.navigationBar.translucent = YES;
    self.navigationBar.hiddenBottomHorizontalLine = NO;
    self.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) target:self action:@selector(didClickCancelBarButtonItem:)];
    
    _assetsAlbums = [NSMutableArray array];
    _tableView = [[CXTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationBar.frame), 0, [UIScreen mainScreen].cx_safeAreaInsets.bottom, 0);
    [self.view addSubview:_tableView];
    
    _noDataView = [[CXAssetsAlbumNoDataView alloc] init];
    _noDataView.delegate = self;
    _noDataView.hidden = YES;
    CGFloat noDataView_X = 20.0;
    CGFloat noDataView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat noDataView_W = CGRectGetWidth(self.view.bounds) - noDataView_X * 2;
    CGFloat noDataView_H = CGRectGetHeight(self.view.bounds) - noDataView_Y;
    _noDataView.frame = CGRectMake(noDataView_X, noDataView_Y, noDataView_W, noDataView_H);
    [self.view addSubview:_noDataView];
    
    [self setEmptyDataTips];
    [self loadAssetsAlbums];
}

- (void)setEmptyDataTips{
    switch (self.pickerController.assetsType) {
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
    [self cancelPicker:YES];
}

- (void)assetsAlbumNoDataViewDidOpenAuthorization:(CXAssetsAlbumNoDataView *)view{
    [CXAppUtils openSettingsPage];
}

- (void)willEnterForegroundNotification:(NSNotification *)notification{
    [super willEnterForegroundNotification:notification];
    
    if(_authorizationStatus != PHAuthorizationStatusNotDetermined &&
       _authorizationStatus != PHAuthorizationStatusAuthorized){
        [self loadAssetsAlbums];
    }
}

- (void)loadAssetsAlbums{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        _authorizationStatus = status;
        
        [CXDispatchHandler asyncOnMainQueue:^{
            if(status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized){
                [self loadAssetsAlbumWithTypes:@[@(PHAssetCollectionTypeSmartAlbum), @(PHAssetCollectionTypeAlbum)]];
                [self pushAssetsViewController:self->_assetsAlbums.firstObject animated:NO];
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

- (void)loadAssetsAlbumWithTypes:(NSArray<NSNumber *> *)collectionTypes{
    [collectionTypes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollectionType collectionType = (PHAssetCollectionType)obj.integerValue;
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:collectionType subtype:PHAssetCollectionSubtypeAny options:nil];
        [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHFetchResult<PHAsset *> *assetsAlbum = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
            if(!assetsAlbum){
                return;
            }
            assetsAlbum.cx_mediaType = self.pickerController.assetsType;
            assetsAlbum.cx_title = obj.localizedTitle;
            
            if(assetsAlbum.cx_countOfAssets > 0 || self.pickerController.isShowEmptyAlbum){
                [self->_assetsAlbums addObject:assetsAlbum];
            }
        }];
        
        if(collectionType == PHAssetCollectionTypeSmartAlbum){
            [self->_assetsAlbums sortUsingComparator:^NSComparisonResult(PHFetchResult<PHAsset *> * _Nonnull obj1, PHFetchResult<PHAsset *> * _Nonnull obj2) {
                return [@(obj2.cx_countOfAssets) compare:@(obj1.cx_countOfAssets)];
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetsAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXAssetsAlbumTableViewCell *cell = [CXAssetsAlbumTableViewCell cellWithTableView:tableView];
    cell.firstRowInSection = indexPath.row == 0;
    cell.lastRowInSection = (indexPath.row == _assetsAlbums.count - 1);
    cell.assetsAlbum = _assetsAlbums[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushAssetsViewController:_assetsAlbums[indexPath.row] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}

- (void)pushAssetsViewController:(PHFetchResult<PHAsset *> *)assetsAlbum animated:(BOOL)animated{
    if(!assetsAlbum){
        return;
    }
    
    CXAssetsViewController *viewController = [[CXAssetsViewController alloc] init];
    [viewController setAssetsAlbum:assetsAlbum];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)reloadData{
    _tableView.hidden = CXArrayIsEmpty(_assetsAlbums);
    _noDataView.hidden = !_tableView.isHidden;
    [_tableView reloadData];
}

@end
