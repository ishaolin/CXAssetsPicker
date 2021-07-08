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
    CXAssetsViewToolBar *_toolBar;
}

@end

@implementation CXAssetsViewController

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
        _toolBar.selectedCount = self.delegate.selectedAssets.count;
        
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
    
    // 保证_toolBar在_collectionView的上面
    if(_toolBar){
        [self.view addSubview:_toolBar];
    }
}

- (void)didClickCancelBarButtonItem:(CXBarButtonItem *)barButtonItem{
    [self.delegate assetsViewControllerDidCancel:self];
}

- (void)setAssetsGroup:(PHFetchResult<PHAsset *> *)assetsGroup{
    self.title = assetsGroup.cx_title;
    
    _assets = [assetsGroup cx_assets];
    [_collectionView reloadData];
}

- (BOOL)isSelectedOriginalImage{
    return _toolBar ? _toolBar.isSelectedOriginalImage : YES;
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
            PHAsset *asset = _assets[indexPath.item];
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didFinishPickingAssets:@[asset] assetsType:self.assetsPickerController.assetsType];
        }
    }else if(self.assetsPickerController.isEnablePreview){
        [self previewAssets:[_assets copy] withIndex:indexPath.item];
    }
}

- (void)assetsCollectionViewCellDidSelectAsset:(CXAssetsCollectionViewCell *)cell{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    if(!indexPath){
        return;
    }
    
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    [self didSelectOrDeselectAsset:cell.asset indexPaths:indexPaths];
    _toolBar.selectedCount = self.delegate.selectedAssets.count;
    [self reloadItemsAtIndexPaths:[indexPaths copy]];
}

- (BOOL)assetsCollectionViewCellShouldSelectAsset:(CXAssetsCollectionViewCell *)cell{
    return [self.delegate assetsViewController:self shouldSelectAsset:cell.asset];
}

- (void)assetsViewToolBarDidCompleted:(CXAssetsViewToolBar *)assetsViewToolBar{
    [self.delegate assetsViewControllerDidCompleted:self];
}

- (void)assetsViewToolBarDidPreviewed:(CXAssetsViewToolBar *)assetsViewToolBar{
    [self previewAssets:self.delegate.selectedAssets withIndex:0];
}

- (void)assetsPreviewControllerDidCompleted:(CXAssetsPreviewController *)assetsPreviewController{
    [self assetsViewToolBarDidCompleted:_toolBar];
}

- (void)assetsPreviewController:(CXAssetsPreviewController *)assetsPreviewController didSelectedOriginalImage:(BOOL)isSelected{
    _toolBar.selectedOriginalImage = isSelected;
}

- (void)assetsPreviewController:(CXAssetsPreviewController *)assetsPreviewController didSelectAsset:(PHAsset *)asset{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    [_assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj == asset){
            obj.cx_selected = asset.cx_selected;
            [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            *stop = YES;
        }
    }];
    
    [self didSelectOrDeselectAsset:asset indexPaths:indexPaths];
    _toolBar.selectedCount = self.delegate.selectedAssets.count;
    assetsPreviewController.selectedCount = self.delegate.selectedAssets.count;
    [self reloadItemsAtIndexPaths:[indexPaths copy]];
}

- (void)didSelectOrDeselectAsset:(PHAsset *)asset indexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths{
    if(asset.cx_selected){
        [self.delegate assetsViewController:self didSelectAsset:asset];
    }else{
        [self.delegate assetsViewController:self didDeselectAsset:asset];
        [self.delegate.selectedAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.cx_selectedIndex == idx){
                return;
            }
            
            obj.cx_selectedIndex = idx;
            NSUInteger originalIndex = obj.cx_originalIndex;
            if(originalIndex < _assets.count){
                [indexPaths addObject:[NSIndexPath indexPathForItem:originalIndex inSection:0]];
            }
        }];
    }
}

- (void)previewAssets:(NSArray<PHAsset *> *)assets withIndex:(NSUInteger)index{
    CXAssetsPreviewController *VC = [[CXAssetsPreviewController alloc] init];
    VC.assets = assets;
    VC.currentAssetIndex = index;
    VC.delegate = self;
    VC.selectedCount = self.delegate.selectedAssets.count;
    VC.selectedOriginalImage = _toolBar.isSelectedOriginalImage;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if(CXArrayIsEmpty(indexPaths)){
        return;
    }
    
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
}

@end
