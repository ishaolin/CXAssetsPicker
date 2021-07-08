//
//  CXAssetsPickerCollectionView.m
//  Pods
//
//  Created by wshaolin on 15/7/10.
//

#import "CXAssetsPickerCollectionView.h"

@interface CXAssetsPickerCollectionView () {
    BOOL _scrollToBottom;
}

@end

@implementation CXAssetsPickerCollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5.0;
    CGFloat colunm = 4;
    CGFloat size = (frame.size.width - (colunm + 1) * margin) / colunm;
    layout.itemSize = CGSizeMake(size, size);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        _scrollToBottom = YES;
        
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceVertical = YES;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        
        if(@available(iOS 11.0, *)){
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

- (void)registerCellClass:(Class)cellClass{
    if(cellClass){
        [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

- (void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    
    if(_scrollToBottom && contentSize.height > self.frame.size.height){
        CGFloat offsetY = self.contentSize.height - self.frame.size.height + self.contentInset.bottom;
        if(offsetY > 0){
            [self setContentOffset:CGPointMake(0, offsetY) animated:NO];
        }
        
        _scrollToBottom = NO;
    }
}

@end
