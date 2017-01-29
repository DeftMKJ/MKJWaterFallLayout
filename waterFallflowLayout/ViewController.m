//
//  ViewController.m
//  waterFallflowLayout
//
//  Created by 宓珂璟 on 2017/1/28.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "ViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MKJWaterFallLayout.h"
#import "MKJCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,MKJWaterFallLayoutDeleagate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *colletionView;
@property (nonatomic,strong) NSMutableArray *dataSource;


@end

static NSString * const productID = @"MKJCollectionViewCell";

@implementation ViewController

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UICollectionView *)colletionView
{
    if (_colletionView == nil) {
        MKJWaterFallLayout *layout = [[MKJWaterFallLayout alloc] init];
        layout.delegate = self;
        UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        collectionV.backgroundColor = [UIColor redColor];
        [collectionV registerNib:[UINib nibWithNibName:productID bundle:nil] forCellWithReuseIdentifier:productID];
        collectionV.delegate = self;
        collectionV.dataSource = self;
        _colletionView = collectionV;
        
    }
    return _colletionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.colletionView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.colletionView.mj_header = header;
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMore)];
    self.colletionView.mj_footer = footer;
    self.colletionView.mj_footer.hidden = YES;
    
    [self.colletionView.mj_header beginRefreshing];
}

- (void)refreshData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *datas = [MKJProductModel mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"mkj" ofType:@"plist"]];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        [self.colletionView reloadData];
        [self.colletionView.mj_header endRefreshing];
    });
}

- (void)reloadMore
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *datas = [MKJProductModel mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"mkj" ofType:@"plist"]];
        [self.dataSource addObjectsFromArray:datas];
        [self.colletionView reloadData];
        [self.colletionView.mj_footer endRefreshing];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.colletionView.mj_footer.hidden = self.dataSource.count == 0;
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MKJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.item];
    return cell;
    
}






#pragma mark - waterfallLayoutDelegate
- (CGFloat)MKJWaterFallLayout:(MKJWaterFallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回宽度和高度比例
    MKJProductModel *product = self.dataSource[indexPath.item];
    return product.h / product.w;
}

// 控制列间距
- (CGFloat)columnMarginForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout
{
    return 10;
}
// 控制行间距
- (CGFloat)rowMarginForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout
{
    return 30;
}
// 控制列数
- (NSUInteger)columnCountForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout
{
//    if (self.dataSource.count > 50) {
//        return 3;
//    }
    return 3;
}
// 控制整体上左下右间距
- (UIEdgeInsets)insetForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
