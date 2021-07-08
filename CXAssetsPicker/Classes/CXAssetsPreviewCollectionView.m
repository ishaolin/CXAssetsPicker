//
//  CXAssetsPreviewCollectionView.m
//  Pods
//
//  Created by wshaolin on 15/7/27.
//

#import "CXAssetsPreviewCollectionView.h"

@interface CXAssetsPreviewCollectionView(){
    NSIndexPath *_scrollToIndexPath;
    BOOL _isScrollToIndexPath;
}

@end

@implementation CXAssetsPreviewCollectionView

+ (instancetype)collectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        _isScrollToIndexPath = YES;
    }
    
    return self;
}

- (void)registerCellClass:(Class)cellClass{
    if(cellClass){
        [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath{
    _scrollToIndexPath = indexPath;
}

- (void)setContentSize:(CGSize)contentSize{
    if(CGSizeEqualToSize(contentSize, self.contentSize)){
        return;
    }
    [super setContentSize:contentSize];
    
    if(!_scrollToIndexPath){
        return;
    }
    
    if(_isScrollToIndexPath){
        [self scrollToItemAtIndexPath:_scrollToIndexPath
                     atScrollPosition:UICollectionViewScrollPositionRight
                             animated:NO];
    }
    
    _isScrollToIndexPath = NO;
}

@end
