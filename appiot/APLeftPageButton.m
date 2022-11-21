//
//  APLeftPageButton.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/15.
//

#import "APLeftPageButton.h"

@implementation APLeftPageButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

//左侧view创建
-(void)createUI
{
//    CGFloat x = 0;
//    CGFloat y = 0;
//    CGFloat w = Page_Btn_W;
//    CGFloat h = Page_Btn_W;
//    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize: 21];
    //标题文本颜色
    [self setTitleColor:ColorHex(0xABBDD5) forState:UIControlStateNormal];
//    //标题文本颜色
//    [self setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateSelected];

    self.line = [[UIImageView alloc] init];
    self.line.backgroundColor = ColorHex(0x3F6EF2);
    self.line.hidden = YES;
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(2);
    }];
}

@end
