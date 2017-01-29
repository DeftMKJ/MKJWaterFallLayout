//
//  MKJWaterFallLayout.h
//  waterFallflowLayout
//
//  Created by 宓珂璟 on 2017/1/28.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKJWaterFallLayout;

@protocol MKJWaterFallLayoutDeleagate <NSObject>

@required
- (CGFloat)MKJWaterFallLayout:(MKJWaterFallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UIEdgeInsets)insetForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout;
- (CGFloat)columnMarginForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout;
- (CGFloat)rowMarginForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout;
- (NSUInteger)columnCountForWaterFallLayout:(MKJWaterFallLayout *)collectionViewLayout;

@end

@interface MKJWaterFallLayout : UICollectionViewLayout

@property (nonatomic,weak) id<MKJWaterFallLayoutDeleagate>delegate;

@end
