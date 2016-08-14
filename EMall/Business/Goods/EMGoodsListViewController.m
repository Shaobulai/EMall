//
//  EMGoodsListViewController.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsListViewController.h"
#import "EMGoodsListCell.h"
#import "EMGoodsModel.h"
#import "EMGoodsDetailViewController.h"
#import "EMGoodsNetService.h"

typedef NS_ENUM(NSInteger,EMGoodsListFromType) {
     EMGoodsListFromTypeCategory=0,//分类过来的
        EMGoodsListFromTypeHome =1,//首页过来的
};

@interface EMGoodsListViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)__block NSMutableArray *dataSourceArray;
@property (nonatomic,assign)NSInteger catID;
@property (nonatomic,assign)EMGoodsListFromType fromType;
@end

@implementation EMGoodsListViewController
- (instancetype)initWithCatID:(NSInteger )catID catName:(NSString *)catName{
    self=[self initWithCatID:catID catName:catName fromType:EMGoodsListFromTypeCategory];
    return self;
}
- (instancetype)initWithHomeType:(NSInteger )typeID typeName:(NSString *)typeName{
    self=[self initWithCatID:typeID catName:typeName fromType:EMGoodsListFromTypeHome];
    return self;
}
- (instancetype)initWithCatID:(NSInteger )catID catName:(NSString *)catName fromType:(EMGoodsListFromType)fromType{
    self=[super init];
    if (self) {
        self.catID=catID;
        if ([NSString isNilOrEmptyForString:catName]) {
            self.navigationItem.title=@"商品列表";
        }else{
            self.navigationItem.title=catName;
        }
        self.fromType=fromType;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataSourceArray.count==0) {
        [self getGoodsListWithCursor:self.cursor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myCollectionView];
    self.automaticallyAdjustsScrollViewInsets=YES;
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self getGoodsListWithCursor:self.cursor];
    WEAKSELF
    [weakSelf.myCollectionView addOCPullDownResreshHandler:^{
        weakSelf.cursor=1;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor];
    }];
    [weakSelf.myCollectionView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor];
    }];
}
- (void)getGoodsListWithCursor:(NSInteger )cursor{
    WEAKSELF
    if (self.dataSourceArray.count==0) {
        [weakSelf.myCollectionView showPageLoadingView];
    }
    NSInteger catID,homtType;
    if (self.fromType==EMGoodsListFromTypeHome) {
        homtType=self.catID;
    }else if(self.fromType==EMGoodsListFromTypeCategory){
        catID=self.catID;
    }
    NSURLSessionTask *task=[EMGoodsNetService getGoodsListWithSearchGoodsID:0 catID:catID searchName:nil aesc:0 sortType:0 homeType:homtType pid:cursor pageSize:20 onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.myCollectionView dismissPageLoadView];
        [weakSelf.myCollectionView stopRefreshAndInfiniteScrolling];
        if (responseResult.cursor>=responseResult.totalPage) {
            [weakSelf.myCollectionView enableInfiniteScrolling:NO];
        }
        if (responseResult.responseCode==OCCodeStateSuccess) {
            if (cursor<2) {
                [weakSelf.dataSourceArray removeAllObjects];
            }
            [weakSelf.dataSourceArray addObjectsFromArray:responseResult.responseData];
            [weakSelf.myCollectionView reloadData];
            if (weakSelf.dataSourceArray.count==0) {
                 [weakSelf.myCollectionView showPageLoadedMessage:@"暂无商品" delegate:nil];
            }
        }else{
            if (weakSelf.dataSourceArray.count==0 ) {
                [weakSelf.myCollectionView showPageLoadedMessage:@"获取数据失败，点击重试" delegate:self];
            }else{
                [weakSelf.myCollectionView showHUDMessage:responseResult.responseMessage];
            }
        }
        weakSelf.cursor=responseResult.cursor;
    }];
    [self addSessionTask:task];
}
-(void)ocPageLoadedViewOnTouced{
    [self getGoodsListWithCursor:self.cursor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=self.dataSourceArray.count;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMGoodsListCell *cell=(EMGoodsListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMGoodsListCell class]) forIndexPath:indexPath];
    cell.goodsModel=[self.dataSourceArray  objectAtIndex:indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EMGoodsModel *goodsModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    EMGoodsDetailViewController *detailController=[[EMGoodsDetailViewController alloc] initWithGoodsID:goodsModel.goodsID];
    detailController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailController animated:YES];
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMGoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass([EMGoodsListCell class])];
    }
    return _myCollectionView;
}
-(NSMutableArray *)dataSourceArray{
    if (nil==_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc]  init];
    }
    return _dataSourceArray;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
