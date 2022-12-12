//
//  APVersionView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/12.
//

#import "APVersionView.h"

@implementation APVersionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat lineH = H_SCALE(35);//行高
    CGFloat labelFontSize = 16;
    UIColor *labelColor = ColorHex(0x434343);
    
    _baseview = [UIView new];
    _baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(_baseview, 10);
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
//    [_baseview addGestureRecognizer:singleTap];
    [self addSubview:_baseview];
    [_baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
//        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(120));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(450), H_SCALE(300)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [_baseview addSubview:namelab];
    namelab.text = @"版本号";
    namelab.textAlignment =  NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:20];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseview.mas_top).offset(Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    [_baseview addSubview:fenzuLab];
    fenzuLab.textAlignment =  NSTextAlignmentCenter;

    fenzuLab.text = @"当前版本号V1.1";
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseview);
        make.centerY.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(300), lineH));
    }];
    /************************************分割线****************************************************/
//    UIImageView* line = [[UIImageView alloc] init];
//    line.backgroundColor = ColorHex(0x8E8E92);
//    [_baseview addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(_baseview);
//        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(0);
//        make.size.mas_equalTo(CGSizeMake(W_SCALE(300), lineH));
//    }];

    UIButton *cancelbtn = [UIButton new];
    [_baseview addSubview:cancelbtn];
    cancelbtn.backgroundColor = ColorHex(0x3F6EF2);

    ViewBorderRadius(cancelbtn, 5, 0.8, [UIColor grayColor]);
    [cancelbtn setTitle:@"确定" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:ColorHex(0x1D2242) forState:UIControlStateNormal];
    cancelbtn.tag = 1;
    [cancelbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(100), H_SCALE(40)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.centerX.mas_equalTo(_baseview);
    }];
    
}

#pragma  mark button delegate

-(void)newDevBtnClick:(UIButton *)btn
{
    
    [self removeFromSuperview];
}

@end
