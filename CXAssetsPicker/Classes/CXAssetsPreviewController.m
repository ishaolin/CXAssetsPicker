//
//  CXAssetsPreviewController.m
//  Pods
//
//  Created by wshaolin on 15/7/13.
//

#import "CXAssetsPreviewController.h"
#import "CXAssetsViewToolBar.h"
#import "CXAssetsToolBarButtonItem.h"
#import "CXAssetsPreviewCollectionView.h"
#import "CXAssetsPickerDefines.h"
#import "CXAssetsPreviewImageCell.h"
#import "CXAssetsPreviewVideoCell.h"

@interface CXAssetsPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CXAssetsPreviewViewCellDelegate, CXAssetsViewToolBarDelegate>{
    CXAssetsPreviewCollectionView *_collectionView;
    CXAssetsViewToolBar *_toolBar;
    CXAssetsToolBarButtonItem *_actionButton;
}

@end

@implementation CXAssetsPreviewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _toolBar = [[CXAssetsViewToolBar alloc] init];
        _toolBar.hiddenPreviewItem = YES;
        _toolBar.delegate = self;
        
        _actionButton = [CXAssetsToolBarButtonItem buttonWithType:UIButtonTypeCustom];
        _actionButton.enableHighlighted = NO;
        _actionButton.barButtonItemFontSize = 13.0;
        _actionButton.backgroundColor = [UIColor clearColor];
        [_actionButton setImage:[CX_ASSETS_PICKER_IMAGE(@"assets_picker_image_selected_0") cx_imageForTintColor:CXHexIColor(0x999999)] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleActionButton:)];
        _actionButton.frame = (CGRect){0, 0, 25.0, 25.0};
        
        _collectionView = [CXAssetsPreviewCollectionView collectionView];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerCellClass:[CXAssetsPreviewVideoCell class]];
        [_collectionView registerCellClass:[CXAssetsPreviewImageCell class]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"预览", nil);
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationBar.translucent = YES;
    self.navigationBar.hiddenBottomHorizontalLine = NO;
    
    CGRect frame = self.view.bounds;
    frame.size.width += CX_ASSETS_IMAGE_SPACING;
    _collectionView.frame = frame;
    [self.view addSubview:_collectionView];
    
    if(self.assetsPickerController.isMultiSelectionMode){
        self.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithCustomView:_actionButton];
        
        UIColor *toolbarItemBackgroundColor = self.assetsPickerController.toolbarItemBackgroundColor;
        UIColor *toolbarItemFontColor = self.assetsPickerController.toolbarItemFontColor;
        [_actionButton setTitleColor:toolbarItemFontColor forState:UIControlStateNormal];
        [_actionButton setImage:[CX_ASSETS_PICKER_IMAGE(@"assets_picker_image_selected_1") cx_imageForTintColor:toolbarItemBackgroundColor] forState:UIControlStateSelected];
        
        _toolBar.translucent = self.navigationBar.isTranslucent;
        _toolBar.enableMaximumCount = self.assetsPickerController.enableMaximumCount;
        _toolBar.barButtonItemBackgroundColor = toolbarItemBackgroundColor;
        _toolBar.barButtonItemFontColor = toolbarItemFontColor;
        _toolBar.sendBarButtonItemText = self.assetsPickerController.toolbarSendItemText;
        CGFloat toolBar_H = CGRectGetHeight(_toolBar.frame);
        CGFloat toolBar_X = 0;
        CGFloat toolBar_W = CGRectGetWidth(self.view.bounds);
        CGFloat toolBar_Y = CGRectGetHeight(self.view.bounds) - toolBar_H;
        _toolBar.frame = (CGRect){toolBar_X, toolBar_Y, toolBar_W, toolBar_H};
        [self.view addSubview:_toolBar];
    }
    
    // 滚动到指定的item
    if(_currentAssetIndex > 0 && _currentAssetIndex < self.assets.count){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentAssetIndex inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath];
        PHAsset *asset = self.assets[_currentAssetIndex];
        [self setUpdateActionButtonSelectedState:asset];
    }
}

- (void)setSeletedCount:(NSInteger)seletedCount{
    _seletedCount = seletedCount;
    _toolBar.selectedCount = seletedCount;
    
    if(_currentAssetIndex < self.assets.count){
        PHAsset *asset = self.assets[_currentAssetIndex];
        [self setUpdateActionButtonSelectedState:asset];
    }
}

- (void)handleActionButton:(CXAssetsToolBarButtonItem *)barButtonItem{
    if(!barButtonItem.isSelected &&
       self.assetsPickerController.enableMaximumCount > 0 &&
       _seletedCount == self.assetsPickerController.enableMaximumCount){
        if([self.assetsPickerController.delegate respondsToSelector:@selector(assetsPickerController:didSelectCountReachedEnableMaximumCount:)]){
            [self.assetsPickerController.delegate assetsPickerController:self.assetsPickerController didSelectCountReachedEnableMaximumCount:self.assetsPickerController.enableMaximumCount];
        }
        return;
    }
    
    if(_currentAssetIndex < self.assets.count){
        barButtonItem.selected = !barButtonItem.isSelected;
        PHAsset *asset = self.assets[_currentAssetIndex];
        asset.cx_selected = barButtonItem.isSelected;
        if([self.delegate respondsToSelector:@selector(assetsPreviewController:didSelectAsset:)]){
            [self.delegate assetsPreviewController:self didSelectAsset:asset];
        }
    }
}

- (void)assetsPreviewViewCellDidSingleTouch:(CXAssetsPreviewViewCell *)cell{
    BOOL hidden = !self.navigationBar.isHidden;
    self.statusBarHidden = hidden;
    [self.navigationBar setHidden:hidden animated:YES];
    [_toolBar setHidden:hidden animated:YES];
}

- (void)assetsViewToolBarDidCompleted:(CXAssetsViewToolBar *)assetsViewToolBar{
    if([self.delegate respondsToSelector:@selector(assetsPreviewControllerDidCompleted:)]){
        [self.delegate assetsPreviewControllerDidCompleted:self];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.assets[indexPath.item];
    CXAssetsPreviewViewCell *cell = nil;
    if(asset.mediaType == PHAssetMediaTypeVideo){
        cell = [CXAssetsPreviewVideoCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    }else{
        cell = [CXAssetsPreviewImageCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    }
    cell.asset = asset;
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if([cell isKindOfClass:[CXAssetsPreviewViewCell class]]){
        [((CXAssetsPreviewViewCell *)cell) endDisplaying];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = CGRectGetWidth(scrollView.frame);
    if(width > 0 && (scrollView.isDragging || scrollView.isDecelerating)){
        _currentAssetIndex = floor((scrollView.contentOffset.x - width * 0.5) / width) + 1;
        if(_currentAssetIndex < self.assets.count){
            PHAsset *asset = self.assets[_currentAssetIndex];
            [self setUpdateActionButtonSelectedState:asset];
        }
    }
}

- (void)setUpdateActionButtonSelectedState:(PHAsset *)asset{
    _actionButton.selected = asset.cx_selected;
    
    if(asset.cx_selected){
        _actionButton.barButtonItemTitle = @(asset.cx_selectedIndex + 1).stringValue;
    }else{
        _actionButton.barButtonItemTitle = nil;
    }
}

@end
