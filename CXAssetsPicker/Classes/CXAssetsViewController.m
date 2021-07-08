//
//  CXAssetsViewController.m
//  Pods
//
//  Created by wshaolin on 15/7/9.
//

#import "CXAssetsViewController.h"
#import "CXAssetsCollectionViewCell.h"
#import "CXAssetsViewToolBar.h"
#import "CXAssetsPickerCollectionView.h"
#import "CXAssetsPreviewController.h"
#import "PHFetchResult+CXExtensions.h"

@interface CXAssetsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CXAssetsViewToolBarDelegate, CXAssetsPreviewControllerDelegate, CXAssetsCollectionViewCellDelegate>{
    CXAssetsPickerCollectionView *_collectionView;
    NSArray<PHAsset *> *_assets;
    NSMutableArray<PHAsset *> *_selectAssets;
    CXAssetsViewToolBar *_toolBar;
}

@end

@implementation CXAssetsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _assets = [NSMutableArray array];
        _selectAssets = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    self.navigationBar.hiddenBottomHorizontalLine = NO;
    self.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) target:self action:@selector(didClickCancelBarButtonItem:)];
    
    CGFloat toolBar_H = 0;
    UIColor *toolbarItemBackgroundColor = self.assetsPickerController.toolbarItemBackgroundColor;
    UIColor *toolbarItemFontColor = self.assetsPickerController.toolbarItemFontColor;
    if(self.assetsPickerController.isMultiSelectionMode){
        _toolBar = [[CXAssetsViewToolBar alloc] init];
        _toolBar.delegate = self;
        _toolBar.translucent = self.navigationBar.translucent;
        _toolBar.hidden = CXArrayIsEmpty(_assets);
        _toolBar.hiddenPreviewItem = !self.assetsPickerController.isEnablePreview;
        _toolBar.enableMaximumCount = self.assetsPickerController.enableMaximumCount;
        _toolBar.barButtonItemBackgroundColor = toolbarItemBackgroundColor;
        _toolBar.barButtonItemFontColor = toolbarItemFontColor;
        _toolBar.sendBarButtonItemText = self.assetsPickerController.toolbarSendItemText;
        
        toolBar_H = CGRectGetHeight(_toolBar.frame);
        CGFloat toolBar_X = 0;
        CGFloat toolBar_W = CGRectGetWidth(self.view.bounds);
        CGFloat toolBar_Y = CGRectGetHeight(self.view.bounds) - toolBar_H;
        _toolBar.frame = (CGRect){toolBar_X, toolBar_Y, toolBar_W, toolBar_H};
    }
    
    [CXAssetsCollectionViewCell setSelectedAssetBackgroundColor:toolbarItemBackgroundColor];
    [CXAssetsCollectionViewCell setSelectedAssetFontColor:toolbarItemFontColor];
    
    _collectionView = [CXAssetsPickerCollectionView collectionViewWithFrame:self.view.bounds];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerCellClass:[CXAssetsCollectionViewCell class]];
    _collectionView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationBar.frame), 0, MAX(toolBar_H, [UIScreen mainScreen].cx_safeAreaInsets.bottom), 0);
    [self.view addSubview:_collectionView];
    
    if(_toolBar){
        [self.view addSubview:_toolBar];
    }
}

- (void)didClickCancelBarButtonItem:(CXBarButtonItem *)barButtonItem{
    if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)]){
        [self.assetsPickerController.delegate assetsPickerControllerDidCancel:self.assetsPickerController];
    }
    
    [self.assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setAssetsGroup:(PHFetchResult<PHAsset *> *)assetsGroup{
    self.title = assetsGroup.cx_title;
    
    _assets = [assetsGroup cx_assets];
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CXAssetsCollectionViewCell *cell = [CXAssetsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.delegate = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    cell.assetSize = layout.itemSize;
    cell.asset = _assets[indexPath.item];
    cell.allowsSelection = self.assetsPickerController.isMultiSelectionMode;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.assetsPickerController.enableMaximumCount == 1){
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingAssets:assetsType:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didFinishPickingAssets:@[_assets[indexPath.item]] assetsType:self.assetsPickerController.assetsType];
        }
    }else if(self.assetsPickerController.isEnablePreview){
        CXAssetsPreviewController *assetsPreviewController = [[CXAssetsPreviewController alloc] init];
        assetsPreviewController.assets = [_assets copy];
        assetsPreviewController.currentAssetIndex = indexPath.item;
        assetsPreviewController.delegate = self;
        assetsPreviewController.seletedCount = _selectAssets.count;
        [self.navigationController pushViewController:assetsPreviewController animated:YES];
    }
}

- (void)assetsCollectionViewCellDidSelectAsset:(CXAssetsCollectionViewCell *)cell{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    if(!indexPath){
        return;
    }
    
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    PHAsset *asset = _assets[indexPath.item];
    asset.cx_selected = cell.asset.cx_selected;
    if(asset.cx_selected){
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [_selectAssets addObject:asset];
        _toolBar.selectedCount = _selectAssets.count;
        asset.cx_selectedIndex = _selectAssets.count - 1;
        
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectAsset:asset];
        }
    }else{ // 移除选择
        [_selectAssets removeObject:asset];
        [_selectAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.cx_selectedIndex == idx){
                return;
            }
            
            obj.cx_selectedIndex = idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:obj.cx_originalIndex inSection:0];
            [indexPaths addObject:indexPath];
        }];
        _toolBar.selectedCount = _selectAssets.count;
        
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didDeselectAsset:asset];
        }
    }
    
    [_collectionView reloadItemsAtIndexPaths:[indexPaths copy]];
}

- (BOOL)assetsCollectionViewCellShouldSelectAsset:(CXAssetsCollectionViewCell *)cell{
    if(self.assetsPickerController.enableMaximumCount > 0 &&
       _selectAssets.count >= self.assetsPickerController.enableMaximumCount){
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectCountReachedEnableMaximumCount:self.assetsPickerController.enableMaximumCount];
        }
        return NO;
    }
    return YES;
}

- (void)assetsViewToolBarDidCompleted:(CXAssetsViewToolBar *)assetsViewToolBar{
    if(self.assetsPickerController.enableMinimumCount > 0 &&
       _selectAssets.count < self.assetsPickerController.enableMinimumCount){
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountUnderEnableMinimumCount:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectCountUnderEnableMinimumCount:self.assetsPickerController.enableMinimumCount];
        }
    }else{
        [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didFinishPickingAssets:[_selectAssets copy] assetsType:self.assetsPickerController.assetsType];
        
        if(self.assetsPickerController.isFinishDismissViewController){
            [self.assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)assetsViewToolBarDidPreviewed:(CXAssetsViewToolBar *)assetsViewToolBar{
    CXAssetsPreviewController *assetsPreviewController = [[CXAssetsPreviewController alloc] init];
    assetsPreviewController.assets = [_selectAssets copy];
    assetsPreviewController.currentAssetIndex = 0;
    assetsPreviewController.delegate = self;
    assetsPreviewController.seletedCount = _selectAssets.count;
    [self.navigationController pushViewController:assetsPreviewController animated:YES];
}

- (NSArray<PHAsset *> *)selectedAssets{
    return [_selectAssets copy];
}

- (void)assetsPreviewControllerDidCompleted:(CXAssetsPreviewController *)assetsPreviewController{
    [self assetsViewToolBarDidCompleted:_toolBar];
}

- (void)assetsPreviewController:(CXAssetsPreviewController *)assetsPreviewController didSelectAsset:(PHAsset *)asset{
    __block NSIndexPath *indexPath = nil;
    [_assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj == asset){
            obj.cx_selected = asset.cx_selected;
            indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            *stop = YES;
        }
    }];
    
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    if(asset.cx_selected){
        [_selectAssets addObject:asset];
        asset.cx_selectedIndex = _selectAssets.count - 1;
        
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectAsset:asset];
        }
    }else{
        [_selectAssets removeObject:asset];
        [_selectAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.cx_selectedIndex == idx){
                return;
            }
            
            obj.cx_selectedIndex = idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:obj.cx_originalIndex inSection:0];
            [indexPaths addObject:indexPath];
        }];
        
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didDeselectAsset:asset];
        }
    }
    
    _toolBar.selectedCount = _selectAssets.count;
    assetsPreviewController.seletedCount = _selectAssets.count;
    [_collectionView reloadItemsAtIndexPaths:[indexPaths copy]];
}

@end
