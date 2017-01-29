//
//  MKJCollectionViewCell.m
//  waterFallflowLayout
//
//  Created by 宓珂璟 on 2017/1/28.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "MKJCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface MKJCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation MKJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MKJProductModel *)model
{
    _model = model;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"header_cry_icon"]];
    self.priceLabel.text = model.price;
}

@end
