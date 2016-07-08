//
//  EMInfiniteView.m
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMInfiniteView.h"
#import "EMInfiniteViewCell.h"
@interface EMInfiniteView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong,readwrite) UICollectionView *collectionView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)NSInteger currentIndex;

@end

@implementation EMInfiniteView

- (instancetype)init{
    self=[self initWithFrame:CGRectZero];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)layoutSubviews{
    self.collectionView.frame=self.bounds;
    [self.collectionView reloadData];
}
- (void)onInitContentView{
      [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    WEAKSELF
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(OCUISCALE(20));
    }];
    _currentIndex=0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
- (void)setTotalNumber:(NSInteger)totalNumber{
    _totalNumber=totalNumber;
    self.pageControl.numberOfPages=_totalNumber;
    
}
#pragma mark -private
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier atIndex:(NSInteger)index{
    id cell= [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell;
}
#pragma mark -delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=nil;
    if (_delegate&&[_delegate respondsToSelector:@selector(infiniteView:cellForRowAtIndex:)]) {
        cell= [_delegate infiniteView:self cellForRowAtIndex:self.currentIndex];
    }else{
        cell=[[UICollectionViewCell alloc]  init];
    }
    self.pageControl.currentPage=_currentIndex;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(infiniteView:didSelectRowAtIndex:)]) {
        [_delegate infiniteView:self didSelectRowAtIndex:indexPath.row];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}
#pragma mark - scrollview delegate

///MARK:----/实现无限左右滚动/--------
//--/此代理方法在每一帧图片结束滚动调用/-----
-(void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    NSInteger offsetX = scrollView.contentOffset.x;
    NSInteger viewW = scrollView.bounds.size.width;
    NSInteger offset = offsetX/viewW - 1;
    if (offset != 0)
    {
        _currentIndex = (_currentIndex + offset + self.totalNumber) % self.totalNumber;
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark -getter
-(UICollectionView *)collectionView{
    if (nil==_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _collectionView=mainView;
         _collectionView.pagingEnabled=YES;
    }
    return _collectionView;
}
-(UIPageControl *)pageControl{
    if (nil==_pageControl) {
        _pageControl=[[UIPageControl alloc]  init];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor redColor];
        
    }
    return _pageControl;
}
@end
