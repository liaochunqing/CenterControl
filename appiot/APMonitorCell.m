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
    _im.contentMode=UIViewContentModeScaleAspectFill;
    [_im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(firtRow.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(40), H_SCALE(14)));
    }];
    
    UILabel *namelab = [[UILabel alloc] init];
    [firtRow addSubview:namelab];
    namelab.text = node.name;//@"投影机10086 展厅10086";
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
    errorcode.text = node.error_code.length?node.error_code:@"--";//
    errorcode.font = [UIFont systemFontOfSize:16];
    errorcode.textColor = ColorHex(0xCCCCCC);
    errorcode.textAlignment = NSTextAlignmentLeft;
//    ViewBorderRadius(errorcode, 3, 0.5, ColorHex(0xCCCCCC));
    [errorcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.left.mas_equalTo(namelab.mas_right).offset(midGap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(200), H_SCALE(30)));
    }];
    

    //RS232

    if(node.connect.intValue == 1)
    {
        str = @"RS232已连接";
        color = ColorHex(0xEC00CF );
        imgName =@"Group 11726";
    }
    else
    {
        str = @"RS232未连接";
        color = ColorHex(0xCCCCCC);
        imgName =@"Group 11727";
    }
    UILabel *zhan = [[UILabel alloc] init];
    [firtRow addSubview:zhan];
    zhan.text = str;
    zhan.font = [UIFont systemFontOfSize:16];
    zhan.textColor = color;
    [zhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(firtRow.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(110), H_SCALE(20)));
    }];
    UIImageView *imzhan = [[UIImageView alloc] init];
    imzhan.image = [UIImage imageNamed:imgName];
    [firtRow addSubview:imzhan];
    [imzhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(zhan.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
    }];
    
    //开快门
    if(node.shutter_status.intValue == 1)
    {
        str = @"快门开";
        color = ColorHex(0xFFBD12);
        imgName =@"Group 11725";
    }
    else
    {
        str = @"快门关";
        color = ColorHex(0xCCCCCC);
        imgName =@"Group 11727";
    }
    UILabel *kuaimen = [[UILabel alloc] init];
    [firtRow addSubview:kuaimen];
    kuaimen.text = str;
    kuaimen.font = [UIFont systemFontOfSize:16];
    kuaimen.textColor = color;
    [kuaimen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(zhan.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(55), H_SCALE(20)));
    }];
    UIImageView *imkuaimen = [[UIImageView alloc] init];
    imkuaimen.image = [UIImage imageNamed:imgName];
    [firtRow addSubview:imkuaimen];
    [imkuaimen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kuaimen.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
    }];
    
    //开机
    if(node.supply_status.intValue == 1)
    {
        str = @"开机";
        color = ColorHex(0x12D4B2 );
        imgName =@"Group 11724";
    }
    else
    {
        str = @"关机";
        color = ColorHex(0xCCCCCC);
        imgName =@"Group 11727";
    }
    UILabel *kaiji = [[UILabel alloc] init];
    [firtRow addSubview:kaiji];
    kaiji.text = str;
    kaiji.font = [UIFont systemFontOfSize:16];
    kaiji.textColor = color;
    [kaiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kuaimen.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), H_SCALE(20)));
    }];
    
    UIImageView *imkaiji = [[UIImageView alloc] init];
    imkaiji.image = [UIImage imageNamed:imgName];
    [firtRow addSubview:imkaiji];
    [imkaiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firtRow);
        make.right.mas_equalTo(kaiji.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
    }];
    
    
    CGFloat fontsize = H_SCALE(13);
    CGFloat w = W_SCALE(180);
    //ip
    UILabel *iplab = [[UILabel alloc] init];
    [self.contentView addSubview:iplab];
    iplab.text = [NSString stringWithFormat:@"ip:%@",node.ip];
    iplab.font = [UIFont systemFontOfSize:fontsize];
    iplab.textColor = ColorHex(0xABBDD5);
    [iplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    //信号源
    UILabel *singallab = [[UILabel alloc] init];
    [self.contentView addSubview:singallab];
    singallab.text = [NSString stringWithFormat:@"信源:%@",node.signals];;
    singallab.font = [UIFont systemFontOfSize:fontsize];
    singallab.textColor = ColorHex(0xABBDD5);
    [singallab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iplab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    //温度
    UILabel *templab = [[UILabel alloc] init];
    [self.contentView addSubview:templab];
    templab.text = [NSString stringWithFormat:@"温度:%@",node.temperature];;
    templab.font = [UIFont systemFontOfSize:fontsize];
    templab.textColor = ColorHex(0xABBDD5);
    [templab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singallab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(namelab.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    CGFloat left = W_SCALE(232);
    //ID
    UILabel *idlab = [[UILabel alloc] init];
    [self.contentView addSubview:idlab];
    idlab.text = [NSString stringWithFormat:@"ID:%@",node.device_id.length?node.device_id:@"--"];;
    idlab.font = [UIFont systemFontOfSize:fontsize];
    idlab.textColor = ColorHex(0xABBDD5);
    [idlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(self.contentView.mas_left).offset(left);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
    }];
    
    //时间比
    UILabel *timelab = [[UILabel alloc] init];
    [self.contentView addSubview:timelab];
    timelab.text = [NSString stringWithFormat:@"整机/光源时间(h):%@/%@",node.machine_running_time,node.light_running_time];//@"整机/光源时间（h）：1000000/56795";
    timelab.font = [UIFont systemFontOfSize:fontsize];
    timelab.textColor = ColorHex(0xABBDD5);
    [timelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idlab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(self.contentView.mas_left).offset(left);
        make.size.mas_equalTo(CGSizeMake(w, H_SCALE(17)));
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
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
}
@end
