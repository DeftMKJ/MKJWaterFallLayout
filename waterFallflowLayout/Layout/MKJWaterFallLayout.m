//
//  MKJWaterFallLayout.m
//  waterFallflowLayout
//
//  Created by 宓珂璟 on 2017/1/28.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "MKJWaterFallLayout.h"

// 每一列的间距
static const CGFloat MKJDefaultColumnMargin = 10;
// 每一行间距
static const CGFloat MKJDefaultRowMargin = 10;
// 整体的上间距，左间距，下间距，右间距
static const UIEdgeInsets MKJDefaultEdgeInsets = {10,10,10,10};
// 默认是多少列
static const NSUInteger MKJDefaultColumnCounts = 2;

@interface MKJWaterFallLayout ()

@property (nonatomic,strong) NSMutableArray *attributeArr; // cell属性的数组
@property (nonatomic,strong) NSMutableArray *columnHeightArr; // 每列的高度数组

@end

@implementation MKJWaterFallLayout

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginForWaterFallLayout:)]) {
        return [self.delegate columnMarginForWaterFallLayout:self];
    }
    else{
        return MKJDefaultColumnMargin;
    }
}

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginForWaterFallLayout:)]) {
        return [self.delegate rowMarginForWaterFallLayout:self];
    }
    else{
        return MKJDefaultRowMargin;
    }
}

- (UIEdgeInsets)insetMargin
{
    if ([self.delegate respondsToSelector:@selector(insetForWaterFallLayout:)]) {
        return [self.delegate insetForWaterFallLayout:self];
    }
    else{
        return MKJDefaultEdgeInsets;;
    }
}

- (CGFloat)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountForWaterFallLayout:)]) {
        return [self.delegate columnCountForWaterFallLayout:self];
    }
    else{
        return MKJDefaultColumnCounts;
    }
}

- (NSMutableArray *)attributeArr
{
    if (_attributeArr == nil) {
        _attributeArr = [[NSMutableArray alloc] init];
    }
    return _attributeArr;
}

- (NSMutableArray *)columnHeightArr
{
    if (_columnHeightArr == nil) {
        _columnHeightArr = [[NSMutableArray alloc] init];
    }
    return _columnHeightArr;
}
// 每次刷新会调用一次
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 每次重新刷新的时候清除之前的所有高度值，默认就是UIEdg给定的top
    [self.columnHeightArr removeAllObjects];
    for (NSInteger i = 0; i < [self columnCount]; i++) {
        [self.columnHeightArr addObject:@([self insetMargin].top)];
    }
    // 每次刷新把对应的att属性清空
    [self.attributeArr removeAllObjects];
    // 初始化一次每个cell对应的attribute属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attributeArr addObject:attribute];
    }
}

// 返回attribute属性数组决定最后的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributeArr;
}

// 返回对应的indexpath下每个cell的属性 cell的出现会一直刷新该方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 初始化布局属性---> 对应的indexpath
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    // 宽度是根据列数和间距固定算出来的
    CGFloat width = (collectionW - [self insetMargin].left - [self insetMargin].right - ([self columnCount] - 1) * [self columnMargin]) / [self columnCount];
    
    // 高度是根据代理的数据源返回比例计算的
    CGFloat height = [self.delegate MKJWaterFallLayout:self heightForItemAtIndexPath:indexPath] * width;
    // X 和 Y值都是在找出最小column之后才能确定，核心就是根据列数，找出最小高度的那一列
    // 先取出第一个默认是最小的
    CGFloat minColumnHeight = [self.columnHeightArr[0] doubleValue];
    // 默认最小的是第0列
    NSUInteger finalCol = 0;
    for (NSInteger i = 1 ; i < [self columnCount]; i++) {
        CGFloat currentColHeight = [self.columnHeightArr[i] doubleValue];
        if (minColumnHeight > currentColHeight) {
            minColumnHeight = currentColHeight;
            finalCol = i;
        }
    }
    
    // x，y值是根据最小高度列算出来的
    CGFloat x = [self insetMargin].left + (width + [self columnMargin]) * finalCol;
    CGFloat y = minColumnHeight;
    // 当你是一个行排布的时候 默认是top值，不需要加间距
    NSInteger count = indexPath.item;
    if ((count / ([self columnCount])) >= 1) {
        y += [self rowMargin];
    }
    att.frame = CGRectMake(x, y, width, height);
    self.columnHeightArr[finalCol] = @(CGRectGetMaxY(att.frame));
    return att;
    
}


// 计算出滚动区域的大小
- (CGSize)collectionViewContentSize
{
    CGFloat maxColumHeight = [self.columnHeightArr[0] doubleValue];
    for (NSInteger i = 1; i < [self columnCount]; i++) {
        CGFloat currentColHeight = [self.columnHeightArr[i] doubleValue];
        if (maxColumHeight < currentColHeight) {
            maxColumHeight = currentColHeight;
        }
    }
    return CGSizeMake(0, maxColumHeight + [self insetMargin].bottom);
    
}

@end
