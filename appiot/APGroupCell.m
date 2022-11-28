//
//  APGroupCell.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import "APGroupCell.h"

@implementation APGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        self.backgroundColor = [UIColor clearColor];
        
        //设置被选中颜色
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = ColorHex(0x29315F );//
    }
    return self;
}

-(void)updateCellWithData:(APGroupNote*)node index:(int)row
{
    if(!node) return;
    for (UIView *subview in self.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    if(node.height == 0)
    {
        return;
    };


    CGFloat midGap = W_SCALE(20);//cell各个图标文字中间的间隙
    
    CGFloat expendX = Left_Gap  + midGap* (node.depth);
    CGFloat expendW = W_SCALE(30);
    //展开箭头图标的创建
    _expendBtn = [UIButton new];
    [self.contentView addSubview:_expendBtn];

    [_expendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(expendX);
        make.size.mas_equalTo(CGSizeMake(expendW, expendW));
    }];
    _expendBtn.tag = row;
    [_expendBtn addTarget:self action:@selector(expendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (node.haveChild)
    {
        NSString *name = node.expand?@"Vector(2)" : @"Vector(1)";
        [_expendBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    }
    
    CGFloat imH = H_SCALE(29);
    CGFloat imW = W_SCALE(26);
    if (node.isDevice)
    {
        imH = H_SCALE(36);
        imW = W_SCALE(15);
    }
    
//    expendW = _expendBtn.hidden?0:W_SCALE(30);
    CGFloat imX = expendX + expendW + midGap;
    _im = [[UIImageView alloc] init];
    [self.contentView addSubview:_im];
    NSString *imgStr = node.isDevice?@"Group 11661" : @"Group 11674";
    _im.image = [UIImage imageNamed:imgStr];
    _im.contentMode=UIViewContentModeScaleAspectFill;
    _im.clipsToBounds=YES;
    [_im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(imX);
        make.size.mas_equalTo(CGSizeMake(imH, imW));
    }];
    
    //标题
    _title = [[UILabel alloc] init];
    _title.textColor = ColorHex(0xFFFFFF);
    _title.font = [UIFont systemFontOfSize:16];
    _title.textAlignment = NSTextAlignmentLeft;
    NSString *str = node.name;
    if(node.isDevice == NO)
    {
        str = [NSString stringWithFormat:@"(%d/%d)%@",node.childSelected,node.childNumber,node.name];
    }
    _title.text = str;
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_im.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(170), H_SCALE(28)));
    }];
    
    //选中图标
    _selectBtn = [UIButton new];
    _selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    _selectBtn.selected = node.selected;
    NSString *selectIamge = node.selected?@"all" : @"Ellipse 4";
    [_selectBtn setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
    
}


#pragma button响应
-(void)expendBtnClick:(UIButton *)btn
{
    if(btn == _expendBtn)
    {
        self.btnClickBlock(btn.tag);
    }
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color
{
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
