//
//  SADetailCell.m
//  NetAsistant
//
//  Created by Zzy on 3/7/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "SADetailCell.h"
#import "SADateUtils.h"
#import "SADetail.h"
#import "SAConvertUtils.h"

@interface SADetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;

@end

@implementation SADetailCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configWithDetail:(SADetail *)detail
{
    self.dateLabel.text = [SADateUtils stringWithDate:detail.date];
    self.flowLabel.text = [SAConvertUtils bytesToString:detail.flowValue.longLongValue];
}

- (void)prepareForReuse
{
    self.dateLabel.text = @"";
    self.flowLabel.text = @"";
}

@end
