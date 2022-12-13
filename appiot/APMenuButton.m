//
//  APMenuButton.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/13.
//

#import "APMenuButton.h"

@implementation APMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

//左侧view创建
-(void)createUI
{
    _lab = [[UILabel alloc] init];
    [self addSubview:_lab];
//    label.text = str;
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.font = [UIFont systemFontOfSize:15];
    _lab.textColor = ColorHex(0x9DA2B5);
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(H_SCALE(22));
        make.centerY.mas_equalTo(self);
    }];
    
    _iv = [[UIImageView alloc] init];
    _iv.backgroundColor = ColorHex(0x3F6EF2);
    _iv.hidden = YES;
    [self addSubview:_iv];
    [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(3);
    }];
}

@end
