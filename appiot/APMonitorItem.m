//
//  APMonitorItem.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/15.
//

#import "APMonitorItem.h"

@implementation APMonitorItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    ViewBorderRadius(self, 8, 1, ColorHex(0x636983));
    
    self.iv = [[UIImageView alloc] init];
    self.iv.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:self.iv];
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(35), H_SCALE(35)));
    }];
    
    self.title = [[UILabel alloc] init];
    [self addSubview:self.title];
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.font = [UIFont systemFontOfSize: 16];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iv.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(120), H_SCALE(30)));
    }];
    
    self.detail = [[UILabel alloc] init];
    [self addSubview:self.detail];
    self.detail.textColor = [UIColor whiteColor];
    self.detail.textAlignment = NSTextAlignmentRight;
    self.detail.font = [UIFont systemFontOfSize: 24];
    [self addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(120), H_SCALE(30)));
    }];
}
@end
