//
//  APSetNumberItem.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APSetNumberItem.h"

@implementation APSetNumberItem


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createItem];
    }
    return self;
}


-(void)createItem
{
    
    CGFloat lineH = H_SCALE(30);//行高
    CGFloat labelW = W_SCALE(78);//左侧标题控件的宽度
    CGFloat labelFontSize = 15;
    UIColor *labelColor = ColorHex(0xA1A7C1);
    CGFloat textW = W_SCALE(68);
    CGFloat contentFontSize = 14;
    UIColor *contentColor = ColorHex(0x9699AC);
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    _label = fenzuLab;
    fenzuLab.text = @"亮度对比";
    [self addSubview:fenzuLab];
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    
    _slider = [[UISlider alloc] init];
    _slider.value = 0;
    _slider.minimumValue = 0;
    _slider.maximumValue = 100;
//    _slider.continuous = NO;
    _slider.maximumTrackTintColor = [UIColor blackColor];

    [_slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderTouchUp) forControlEvents:UIControlEventTouchUpInside];
//    [_slider addTarget:self action:@selector(sliderValueChange2) forControlEvents:UIControlEventTouchUpOutside];

    [self addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(_label.mas_right).offset(W_SCALE(10));
        make.height.mas_equalTo(lineH);
        make.right.mas_equalTo(self.mas_right).offset(-(textW+W_SCALE(10)));
    }];
    
    
    _field = [UITextField new];
    _field.delegate = self;
    _field.textColor = KWhiteColor;
    _field.textAlignment = NSTextAlignmentCenter;
    _field.font = [UIFont systemFontOfSize:contentFontSize];
    _field.keyboardType = UIKeyboardTypeDecimalPad;//UIKeyboardTypePhonePad;
    ViewBorderRadius(_field, 5, 1, ColorHex(0xADACA8));
    [self addSubview:_field];
    NSString *holderText = @"0";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:KGrayColor
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _field.attributedPlaceholder = placeholder;

    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(textW);
        make.height.mas_equalTo(lineH);
    }];
}

#pragma  mark sliderValueChange
-(void)sliderValueChange
{
//    NSLog(@"%d",(int)_slider.value);
    _field.text = [NSString stringWithFormat:@"%d",(int)_slider.value];
}
-(void)sliderTouchUp
{
//    NSLog(@"%d",(int)_slider.value);
    if (self.changedBlock)
    {
        self.changedBlock(SafeStr(_field.text));
    }
}

#pragma  mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码

    return YES;
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.changedBlock)
    {
        self.changedBlock(SafeStr(_field.text));
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
//    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
//    {
//        return NO;
//    }
//
//    NSString * searchText = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//
//    return YES;
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *regexStr = @"^\\d{0,3}$";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", regexStr];
        if([predicate evaluateWithObject:text] && [text integerValue] <= 100){
            [_slider setValue:text.intValue animated:YES];
            return YES;
        }
        return NO;

}


@end
