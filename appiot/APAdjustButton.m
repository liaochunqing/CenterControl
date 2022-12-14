//
//  APAdjustButton.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/14.
//

#import "APAdjustButton.h"

@implementation APAdjustButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

//左侧view创建
-(void)createUI
{
    UIButton *button = [[UIButton alloc] init];
//    button.backgroundColor = [UIColor blueColor];
//    ViewRadius(button, 5);
//    [button setTitle:@"自动居中" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button setBackgroundImage:[self imageWithColor:ColorHex(0xffffff)] forState:UIControlStateNormal];
//    [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnMicroClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(H_SCALE(100)/2);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    
    _microImg = [[UIImageView alloc] init];
    _microImg.image = [UIImage imageNamed:@"Group 11709"];
    [button addSubview:_microImg];
    [_microImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button.mas_left).offset(0);
        make.centerY.mas_equalTo(button);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    
    _microLab = [[UILabel alloc] init];
    [button addSubview:_microLab];
    _microLab.text = @"微调";
//    _microLab.textAlignment = NSTextAlignmentCenter;
    _microLab.font = [UIFont systemFontOfSize:14];
    _microLab.textColor = ColorHex(0x0083FF);
    [_microLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_microImg.mas_right).offset(Left_Gap);
        make.centerY.mas_equalTo(button);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(22);
    }];
    
    
    button = [[UIButton alloc] init];
    _macroBtn = button;
//    ViewRadius(button, 5);
//    [button setTitle:@"自动居中" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
//    [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnMacroClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(H_SCALE(100)/2);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    
   
    _macroImg = [[UIImageView alloc] init];
    _macroImg.image = [UIImage imageNamed:@"Ellipse 87"];
    [button addSubview:_macroImg];
    [_macroImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button.mas_left).offset(0);
        make.centerY.mas_equalTo(button);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    
    _macroLab = [[UILabel alloc] init];
    [button addSubview:_macroLab];
    _macroLab.text = @"粗调";
//    _microLab.textAlignment = NSTextAlignmentCenter;
    _macroLab.font = [UIFont systemFontOfSize:14];
    _macroLab.textColor = ColorHex(0x717690);
    [_macroLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_macroImg.mas_right).offset(Left_Gap);
        make.centerY.mas_equalTo(button);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(22);
    }];
}

#pragma button响应函数

-(void)btnMicroClick:(UIButton *)btn
{
    btn.selected = YES;
    _microImg.image = [UIImage imageNamed:@"Group 11709"];
    _microLab.textColor = ColorHex(0x0083FF);
    
    _macroBtn.selected = NO;
    _macroImg.image = [UIImage imageNamed:@"Ellipse 87"];
    _macroLab.textColor = ColorHex(0x717690);
}

-(void)btnMacroClick:(UIButton *)btn
{
    btn.selected = YES;
    _macroImg.image = [UIImage imageNamed:@"Group 11709"];
    _macroLab.textColor = ColorHex(0x0083FF);
    
    _microBtn.selected = NO;
    _microImg.image = [UIImage imageNamed:@"Ellipse 87"];
    _microLab.textColor = ColorHex(0x717690);
}
@end
