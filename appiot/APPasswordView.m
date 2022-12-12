//
//  APPasswordView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/12.
//

#import "APPasswordView.h"

@implementation APPasswordView
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
    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelFontSize = 14;
    UIColor *labelColor = ColorHex(0x434343);
    CGFloat textLeft = labelW + 2*Left_Gap;//右侧控件与父控件的左侧距离
    
    CGFloat contentFontSize = 14;
    UIColor *contentColor = ColorHex(0x434343);

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
    namelab.text = @"修改密码";
    namelab.textAlignment =  NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:20];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseview.mas_top).offset(Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    UILabel *devname = [[UILabel alloc] init];
    [_baseview addSubview:devname];
    devname.text = @"原密码";
    devname.font = [UIFont systemFontOfSize:labelFontSize];
    devname.textColor = labelColor;
    [devname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap*2);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _nameField = [UITextField new];
    _nameField.delegate = self;
    _nameField.textColor = contentColor;
    _nameField.textAlignment = NSTextAlignmentCenter;

    _nameField.font = [UIFont systemFontOfSize:contentFontSize];
    _nameField.placeholder = @"请输入";
    ViewBorderRadius(_nameField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_nameField];

    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap*2);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    
    UILabel *pwlab = [[UILabel alloc] init];
    [_baseview addSubview:pwlab];
    pwlab.text = @"新密码";
    pwlab.font = [UIFont systemFontOfSize:labelFontSize];
    pwlab.textColor = labelColor;
    [pwlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameField.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _pwField = [UITextField new];
    _pwField.delegate = self;
    _pwField.textColor = contentColor;
    _pwField.textAlignment = NSTextAlignmentCenter;

    _pwField.font = [UIFont systemFontOfSize:contentFontSize];
    _pwField.placeholder = @"请输入";
    ViewBorderRadius(_pwField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_pwField];

    [_pwField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameField.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    
    UILabel *confirmlab = [[UILabel alloc] init];
    [_baseview addSubview:confirmlab];
    confirmlab.text = @"确认新密码";
    confirmlab.font = [UIFont systemFontOfSize:labelFontSize];
    confirmlab.textColor = labelColor;
    [confirmlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwField.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _confirmField = [UITextField new];
    _confirmField.delegate = self;
    _confirmField.textColor = contentColor;
    _confirmField.textAlignment = NSTextAlignmentCenter;

    _confirmField.font = [UIFont systemFontOfSize:contentFontSize];
    _confirmField.placeholder = @"请输入";
    ViewBorderRadius(_confirmField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_confirmField];

    [_confirmField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwField.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    
    /****************************************************************/
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
