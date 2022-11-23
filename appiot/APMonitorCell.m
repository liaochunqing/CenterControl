//
//  APMonitorCell.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//
#include "APMonitorCell.h"

@implementation APMonitorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        self.backgroundColor = [UIColor clearColor];
//        self.selectedBackgroundView.backgroundColor = ColorHex(0x3F6EF2);
    }
    return self;
}

-(void)updateCellWithData:(APMonitorModel*)node
{
    if(!node) return;
    for (UIView *subview in self.contentView.subviews)
    {
            [subview removeFromSuperview];
     }
    
    CGFloat midGap = 5;
    
    //第一行
    UIView *firtRow = [[UIView alloc] init];
    [self.contentView addSubview:firtRow];
    [firtRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(self.contentView.mas_top).offset(top_Gap);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
        make.height.mas_equalTo(H_SCALE(30));
    }];
    
    _im = [[UIImageView alloc] init];
    [firtRow addSubview:_im];
    _im.image = [UIImage imageNamed:@"Group 11661"];
    _im.contentMode=UIViewContentModeScaleAspectFill;
    [_im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(firtRow.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(40), H_SCALE(14)));
    }];
    
    UILabel *namelab = [[UILabel alloc] init];
    [firtRow addSubview:namelab];
    namelab.text = @"投影机10086 展厅10086";
    namelab.font = [UIFont systemFontOfSize:16];
    namelab.textColor = [UIColor whiteColor];
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(_im.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    //错误码
    UIButton *errorcode = [UIButton new];
    errorcode.userInteractionEnabled = NO;
    [errorcode setTitle:@"14406" forState:UIControlStateNormal];
    errorcode.titleLabel.font = [UIFont systemFontOfSize:16];
    ViewBorderRadius(errorcode, 5, 1, ColorHex(0xABBDD5));
    [firtRow addSubview:errorcode];
    [errorcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(namelab.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(62), H_SCALE(30)));
    }];
    

    //RS232
    UILabel *zhan = [[UILabel alloc] init];
    [firtRow addSubview:zhan];
    zhan.text = @"RS232已连接";
    zhan.font = [UIFont systemFontOfSize:16];
    zhan.textColor = [UIColor whiteColor];
    [zhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(firtRow.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(86), H_SCALE(20)));
    }];
    
    //开快门
    UILabel *kuaimen = [[UILabel alloc] init];
    [firtRow addSubview:kuaimen];
    kuaimen.text = @"开快门";
    kuaimen.font = [UIFont systemFontOfSize:16];
    kuaimen.textColor = [UIColor whiteColor];
    [kuaimen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(zhan.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), H_SCALE(20)));
    }];
    
    //开机
    UILabel *kaiji = [[UILabel alloc] init];
    [firtRow addSubview:kaiji];
    kaiji.text = @"开机";
    kaiji.font = [UIFont systemFontOfSize:16];
    kaiji.textColor = [UIColor whiteColor];
    [kaiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kuaimen.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), H_SCALE(20)));
    }];
    
    //ip
    UILabel *iplab = [[UILabel alloc] init];
    [self.contentView addSubview:iplab];
    iplab.text = @"IP:127.0.0.1:63142";
    iplab.font = [UIFont systemFontOfSize:12];
    iplab.textColor = ColorHex(0xABBDD5);
    [iplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(98), H_SCALE(17)));
    }];
    
    //信号源
    UILabel *singallab = [[UILabel alloc] init];
    [self.contentView addSubview:singallab];
    singallab.text = @"信源：HDBase_T";
    singallab.font = [UIFont systemFontOfSize:12];
    singallab.textColor = ColorHex(0xABBDD5);
    [singallab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iplab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(98), H_SCALE(17)));
    }];
    
    //温度
    UILabel *templab = [[UILabel alloc] init];
    [self.contentView addSubview:templab];
    templab.text = @"环境温度（°C）：38";
    templab.font = [UIFont systemFontOfSize:12];
    templab.textColor = ColorHex(0xABBDD5);
    [templab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singallab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(112), H_SCALE(17)));
    }];
    
    CGFloat left = W_SCALE(232);
    //ID
    UILabel *idlab = [[UILabel alloc] init];
    [self.contentView addSubview:idlab];
    idlab.text = @"ID：38T8759859";
    idlab.font = [UIFont systemFontOfSize:12];
    idlab.textColor = ColorHex(0xABBDD5);
    [idlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(self.contentView.mas_left).offset(left);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(210), H_SCALE(17)));
    }];
    
    //时间比
    UILabel *timelab = [[UILabel alloc] init];
    [self.contentView addSubview:timelab];
    timelab.text = @"整机/光源时间（h）：1000000/56795";
    timelab.font = [UIFont systemFontOfSize:12];
    timelab.textColor = ColorHex(0xABBDD5);
    [timelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idlab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(self.contentView.mas_left).offset(left);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(210), H_SCALE(17)));
    }];
    
    //详情箭头图标
    UIImageView *arror = [[UIImageView alloc] init];
    arror.image = [UIImage imageNamed:@"arrorright"];
    [self.contentView addSubview:arror];
    [arror mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(6), H_SCALE(12)));

    }];
    
    //底部分割线
    UIImageView *bottomLine = [[UIImageView alloc] init];
    bottomLine.backgroundColor = ColorHex(0x333A55);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView.mas_left).offset(Left_Gap);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);

    }];
/*
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
//    _im.image = [self scaleImage:[UIImage imageNamed:node.imageName] size:CGSizeMake(28, 28)];
    _im.contentMode=UIViewContentModeScaleAspectFill;
    _im.clipsToBounds=YES;
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
    */
}
@end
