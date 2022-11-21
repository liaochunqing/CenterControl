//
//  APComandButton.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/15.
//

#import "APComandButton.h"

@implementation APComandButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

//左侧view创建
-(void)createUI
{
    [self setBackgroundImage:[self imageWithColor:ColorHex(0x1D2242)] forState:UIControlStateNormal];
//    [self setBackgroundImage:[self imageWithColor:ColorHex(0x151935)] forState:UIControlStateSelected];
    [self setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];

    
    self.iv = [[UIImageView alloc] init];
    [self addSubview:self.iv];
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(42);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(75), H_SCALE(75)));
    }];
    
    self.lab = [[UILabel alloc] init];
    self.lab.textColor = ColorHex(0x8C8E99);
    self.lab.font = [UIFont systemFontOfSize:30];
    self.lab.textAlignment = NSTextAlignmentCenter;
//    self.lab.font = [UIFont fontWithName:@"PingFang" size:30];

    [self addSubview:self.lab];
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-H_SCALE(38));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(110), H_SCALE(45)));
    }];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
     
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
     
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    return image;
}
@end
