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
        self.selectedBackgroundView.backgroundColor = ColorHex(0x3F6EF2);
//        self.haveChild = YES;
    }
    return self;
}

-(void)updateCellWithData:(APGroupNote*)node
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

    //被选中颜色
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = ColorHex(0x3F6EF2);//

    //测试代码
    {
        if ([node.imageName isEqualToString:@"Group 11661"])
        {
            node.haveChild = NO;
        }
    }

    CGFloat midGap = W_SCALE(35);//cell各个图标文字中间的间隙
    //展开箭头图标的创建
    CGFloat expendX = Left_Gap  + midGap* (node.depth);
    CGFloat expendW = W_SCALE(14);
    CGFloat expendH = H_SCALE(7);
    _expendImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_expendImageView];
    if (node.haveChild == YES)
    {
        _expendImageView.hidden = NO;
    }
    else
    {
        _expendImageView.hidden = YES;
        expendX = Left_Gap  + midGap* (node.depth - 1);
    }
    [_expendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(expendX);
        make.size.mas_equalTo(CGSizeMake(expendW, expendH));
    }];
    NSString *name = node.expand?@"Vector(2)" : @"Vector(1)";
    _expendImageView.image = [UIImage imageNamed:name];

    
    //图标
//    CGFloat imX;
//    if (node.haveChild)
//    {
//        imX = expendX + expendW + midGap;
//    }
//    else
//    {
//        imX = Left_Gap  + midGap* (node.depth) + ;
//    }
    _im = [[UIImageView alloc] init];
    [self.contentView addSubview:_im];
    _im.image = [UIImage imageNamed:node.imageName];
    [_im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_expendImageView.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    //标题
    _title = [[UILabel alloc] init];
    _title.textColor = ColorHex(0xFFFFFF);
    _title.font = [UIFont systemFontOfSize:16];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.text = node.name;
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_im.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(88, 28));
    }];
    
    //选中图标
    _selectBtn = [UIButton new];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.tag = node.selected;//把是否被选中赋值给tag
    
    NSString *selectIamge = node.selected?@"all" : @"Ellipse 4";
    [_selectBtn setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
    
}

//-(BOOL)NoChildWithData:(APGroupNote*)node
//{
//
//}

#pragma button响应

-(void)btnClick:(UIButton *)btn
{
    if(btn)
    {
        //是否被选中，以tag作为判断值
        if (btn.tag == 1)
        {
            btn.tag = 0;
        }
        else
        {
            btn.tag = 1;
        }
        
        NSString *selectIamge = btn.tag?@"all" : @"Ellipse 4";
        [btn setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
