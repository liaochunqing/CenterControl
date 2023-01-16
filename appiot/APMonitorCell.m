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
        
        //设置被选中颜色
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = ColorHex(0x29315F );//
        
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
    
    CGFloat midGap = 5;
    NSString *str = @"";
    UIColor *color = ColorHex(0xCCCCCC);
    NSString *imgName = @"";
    UIColor *detailColor = ColorHexAlpha(0xABBDD5, 0.7);//ColorHex(0xABBDD5);

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
    _im.image = [UIImage imageNamed:@"dev"];
    _im.contentMode=UIViewContentModeScaleAspectFit;
    [_im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(firtRow.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(40), H_SCALE(14)));
    }];
    
    UILabel *namelab = [[UILabel alloc] init];
    [firtRow addSubview:namelab];
    namelab.text = [NSString stringWithFormat:@"%@  %@",node.name,node.father?node.father.name:@""];//@"投影机10086 展厅10086";
    namelab.font = [UIFont systemFontOfSize:16];
    namelab.textColor = ColorHex(0xCCCCCC);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(_im.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    //错误码
    UILabel *errorcode = [[UILabel alloc] init];
    [firtRow addSubview:errorcode];
//    ViewBorderRadius(errorcode, 3, 0.7, detailColor);
    errorcode.text = node.error_code.length?node.error_code:@"--";//
    errorcode.font = [UIFont systemFontOfSize:16];
    errorcode.textColor = ColorHex(0xCCCCCC);
    errorcode.textAlignment = NSTextAlignmentLeft;
//    ViewBorderRadius(errorcode, 3, 0.5, ColorHex(0xCCCCCC));
    [errorcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(namelab.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(65), H_SCALE(30)));
    }];
    

    //RS232
    UILabel *zhan = [[UILabel alloc] init];
    [firtRow addSubview:zhan];
    zhan.font = [UIFont systemFontOfSize:16];
    [zhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(firtRow.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(110), H_SCALE(20)));
    }];
    UIImageView *imzhan = [[UIImageView alloc] init];
    [firtRow addSubview:imzhan];
    [imzhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(zhan.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
    }];
    
    if(node.connect.intValue == 1)
    {
        str = @"网络已连接";
        color = ColorHex(0xEC00CF );
        imgName =@"Group 11726";
        [[APTool shareInstance] shakeToShow:imzhan];
    }
    else
    {
        str = @"网络未连接";
        color = ColorHex(0xCCCCCC);
        imgName =@"Group 11727";
    }
    zhan.textColor = color;
    zhan.text = str;
    imzhan.image = [UIImage imageNamed:imgName];

    //开快门
    UILabel *kuaimen = [[UILabel alloc] init];
    [firtRow addSubview:kuaimen];
    kuaimen.font = [UIFont systemFontOfSize:16];
    [kuaimen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(zhan.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(55), H_SCALE(20)));
    }];
    UIImageView *imkuaimen = [[UIImageView alloc] init];
    [firtRow addSubview:imkuaimen];
    [imkuaimen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kuaimen.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
    }];
    if(node.shutter_status.intValue == 1)
    {
        str = @"快门开";
        color = ColorHex(0xFFBD12);
        imgName =@"Group 11725";
        [[APTool shareInstance] shakeToShow:imkuaimen];
    }
    else
    {
        str = @"快门关";
        color = ColorHex(0xCCCCCC);
        imgName =@"Group 11727";
    }
    kuaimen.text = str;
    kuaimen.textColor = color;
    imkuaimen.image = [UIImage imageNamed:imgName];
    
    
    //开机
    UILabel *kaiji = [[UILabel alloc] init];
    [firtRow addSubview:kaiji];
    kaiji.font = [UIFont systemFontOfSize:16];
    [kaiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kuaimen.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), H_SCALE(20)));
    }];
    
    UIImageView *imkaiji = [[UIImageView alloc] init];
    [firtRow addSubview:imkaiji];
    [imkaiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kaiji.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
    }];
    if(node.supply_status.intValue == 1)
    {
        str = @"开机";
        color = ColorHex(0x12D4B2 );
        imgName =@"Group 11724";
        [[APTool shareInstance] shakeToShow:imkaiji];
    }
    else if (node.supply_status.intValue == 0)
    {
        str = @"待机";
        color = ColorHex(0x12D4B2 );
        imgName =@"Group 11724";
        [[APTool shareInstance] shakeToShow:imkaiji];
    }
    else
    {
        str = @"关机";
        color = ColorHex(0xCCCCCC);
        imgName =@"Group 11727";
    }
    imkaiji.image = [UIImage imageNamed:imgName];
    kaiji.text = str;
    kaiji.textColor = color;

    
    CGFloat fontsize = H_SCALE(13);
    CGFloat w = W_SCALE(180);
    //ip
    UILabel *iplab = [[UILabel alloc] init];
    [self.contentView addSubview:iplab];
    iplab.text = [NSString stringWithFormat:@"IP : %@",node.ip];
    iplab.font = [UIFont systemFontOfSize:fontsize];
    iplab.textColor = detailColor;
    [iplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    CGFloat gap = W_SCALE(8);
    //信号源
    UILabel *singallab = [[UILabel alloc] init];
    [self.contentView addSubview:singallab];
    singallab.text = [NSString stringWithFormat:@"信源 : %@",node.signals];;
    singallab.font = [UIFont systemFontOfSize:fontsize];
    singallab.textColor = detailColor;
    [singallab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iplab.mas_bottom).offset(gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    //温度
    UILabel *templab = [[UILabel alloc] init];
    [self.contentView addSubview:templab];
    templab.text = [NSString stringWithFormat:@"环境温度(°C) : %@",node.temperature];;
    templab.font = [UIFont systemFontOfSize:fontsize];
    templab.textColor = detailColor;
    [templab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singallab.mas_bottom).offset(gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    CGFloat left = W_SCALE(232);
    //ID
    UILabel *idlab = [[UILabel alloc] init];
    [self.contentView addSubview:idlab];
    idlab.text = [NSString stringWithFormat:@"ID : %@",node.device_id.length?node.device_id:@"--"];;
    idlab.font = [UIFont systemFontOfSize:fontsize];
    idlab.textColor = detailColor;
    [idlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iplab.mas_bottom).offset(gap);
        make.left.mas_equalTo(self.contentView.mas_left).offset(left);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    //时间比
    UILabel *timelab = [[UILabel alloc] init];
    [self.contentView addSubview:timelab];
    timelab.text = [NSString stringWithFormat:@"整机/光源时间(h) : %@/%@",node.machine_running_time,node.light_running_time];//@"整机/光源时间（h）：1000000/56795";
    timelab.font = [UIFont systemFontOfSize:fontsize];
    timelab.textColor = detailColor;
    [timelab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(idlab.mas_bottom).offset(top_Gap);
        make.top.mas_equalTo(idlab.mas_bottom).offset(gap);
        make.left.mas_equalTo(self.contentView.mas_left).offset(left);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(380), H_SCALE(17)));
    }];
    
    //详情箭头图标
//    UIImageView *arror = [[UIImageView alloc] init];
//    arror.image = [UIImage imageNamed:@"arrorright"];
//    [self.contentView addSubview:arror];
//    [arror mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
//        make.size.mas_equalTo(CGSizeMake(W_SCALE(6), H_SCALE(12)));
//
//    }];
    
    //底部分割线
    UIImageView *bottomLine = [[UIImageView alloc] init];
    bottomLine.backgroundColor = ColorHex(0x333A55);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView.mas_left).offset(Left_Gap);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
}


@end
