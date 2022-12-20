//
//  APRadioItem.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/20.
//

#import "APRadioItem.h"

@implementation APRadioItem


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self createUI];
    }
    return self;
}


-(void)createUI
{
//    [self createScaleView];
}

-(void)createScaleView:(NSArray *)array title:(NSString *)title
{
    CGFloat lineH = H_SCALE(30);//行高
    CGFloat labelW = W_SCALE(103);//左侧标题控件的宽度
    CGFloat labelFontSize = 15;
    UIColor *labelColor = ColorHex(0xA1A7C1);
    
    CGFloat btn_w = W_SCALE(80);
    CGFloat btn_fontsize = 14;
    UIColor *btn_color = ColorHex(0xA1A7C1);
    
    /*********************************************************************************************/
    _label = [[UILabel alloc] init];
    [self addSubview:_label];
    _label.text = title;
    _label.font = [UIFont systemFontOfSize:labelFontSize];
    _label.textColor = labelColor;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _btnArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _labArray = [NSMutableArray array];
    for (int i = 0 ;i < array.count; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_btnArray addObject:button];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_label.mas_right).offset(Left_Gap + i * (btn_w + Left_Gap));
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.height.mas_equalTo(lineH);
            make.width.mas_equalTo(btn_w);
        }];
        
        UIImageView *im = [[UIImageView alloc] init];
        NSString *str = i==0?@"Group 11709":@"Ellipse 87";
        im.image = [UIImage imageNamed:str];
        [_imageArray addObject:im];
        im.tag = i;
        [button addSubview:im];
        [im mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(button.mas_left).offset(0);
            make.centerY.mas_equalTo(button);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        
        UILabel *lab = [[UILabel alloc] init];
        [button addSubview:lab];
        [_labArray addObject:lab];
        lab.tag = i;
        lab.text = SafeStr(array[i]);
        lab.font = [UIFont systemFontOfSize:btn_fontsize];
        UIColor *cl = i==0?ColorHex(0x0083FF) : btn_color;
        lab.textColor = cl;
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_top).offset(0);
            make.left.mas_equalTo(im.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(labelW, lineH));
        }];
    }
    
}


#pragma  mark 私有方法

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView*view = [super hitTest:point withEvent:event];
    if(view ==nil)
    {
        for(UIView*subView in self.subviews)
        {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if(CGRectContainsPoint(subView.bounds, myPoint))
            {
                return subView;
            }
        }
    }
    return view;
}
#pragma mark 对外接口
-(void)setDefaultValue:(NSArray *)array title:(NSString *)title
{
    if (array == nil)
        return;
    //设置默认值
    [self createScaleView:array title:title];
//    _dataArray = [NSMutableArray arrayWithArray:array];
//    id string = _dataArray[0];
//    if ([string isKindOfClass:[NSString class]])
    {
//        _field.text = SafeStr(string);
    }
    
}


-(void)btnClick:(UIButton *)btn
{
    if(btn)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < _imageArray.count; i++)
        {
            UIImageView *temp = _imageArray[i];
            if (temp)
            {
                temp.image = [UIImage imageNamed:@"Ellipse 87"];
                if(temp.tag ==  btn.tag)
                {
                    temp.image = [UIImage imageNamed:@"Group 11709"];
                }
            }
        }
        
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < _labArray.count; i++)
        {
            UILabel *temp = _labArray[i];
            if (temp)
            {
                [temp setTextColor:ColorHex(0xA1A7C1)];
            }
        }
        
        UILabel *lab = _labArray[btn.tag];
        [lab setTextColor:ColorHex(0x0083FF)];
        
        if (self.btnClickBlock)
        {
            self.btnClickBlock(SafeStr(lab.text));
        }
        
        switch (btn.tag) {
            case 0://
            {
            }
                break;
                
            case 7://“
            {
            }
                break;
                
            default:
                break;
        }
    }
}


@end
