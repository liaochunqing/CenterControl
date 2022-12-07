//
//  config.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/10.
//

#import "APTool.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"
#include "Masonry.h"
#import "MBProgressHUD.h"
#import "FMDB.h"
#import "APTcpSocket.h"
#import "APGroupNote.h"

#ifndef config_h
#define config_h
//**系统对象
#define kAppWindow [UIApplication sharedApplication].delegate.window
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//1. 屏幕宽高及常用尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NavigationBar_HEIGHT 44.0f
#define TabBar_HEIGHT 49.0f
#define StatusBar_HEIGHT 20.0f
#define ToolsBar_HEIGHT 44.0f

//设备型号
#define IS_IPAD  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
//颜色
//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define ColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//block
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//property属性快速声明
#define PropertyString(s) @property(nonatomic,copy)NSString * s
#define PropertyNSInteger(s) @property(nonatomic,assign)NSIntegers
#define PropertyFloat(s) @property(nonatomic,assign)floats
#define PropertyLongLong(s) @property(nonatomic,assign)long long s
#define PropertyNSDictionary(s) @property(nonatomic,strong)NSDictionary * s
#define PropertyNSArray(s) @property(nonatomic,strong)NSArray * s
#define PropertyNSMutableArray(s) @property(nonatomic,strong)NSMutableArray * s

//数据验证
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \|| [_object isKindOfClass:[NSNull class]] \|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#define StrValid(f) (f!=nil &&[f isKindOfClass:[NSString class]]&& ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f)?f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)
#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil &&[f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil &&[f isKindOfClass:[NSArray class]]&&[f count]>0)
#define ValidNum(f) (f!=nil &&[f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil &&[f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil &&[f isKindOfClass:[NSData class]])


// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


// View加边框
#define ViewBorder(View, Width, Color)\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define DB_NAME @"CentralControl.db"

//适配
#define W_SCALE(value) (value * (SCREEN_WIDTH/1194))
#define H_SCALE(value) (value * (SCREEN_HEIGHT/834))

//基础图尺寸
//#define Left_View_Width (320 *(SCREEN_WIDTH/1194))//左视图宽度
//#define Center_View_Width (873*(SCREEN_WIDTH/1194))//右视图宽度
//左侧view
#define Left_View_Width W_SCALE(320 )//左视图宽度
#define Left_Gap W_SCALE(15)
#define top_Gap H_SCALE(15)
#define Group_Cell_Height H_SCALE(40)//左视图cell高度
#define Page_Btn_W W_SCALE(52)
#define Group_Btn_W W_SCALE(30)
#define Bottom_View_Height H_SCALE(88)//左视图cell高度

//右侧view
#define Center_View_Width W_SCALE(873)//右视图宽度
#define Center_Btn_Width W_SCALE(120)//中间菜单按钮宽度
#define Center_Btn_Heigth H_SCALE(44)
#define Center_Top_Gap H_SCALE(35)
#define Center_ChangeView_Top H_SCALE(127)//中间可变视图与顶部距离
#define Command_Btn_W W_SCALE(192)
#define Command_Btn_H H_SCALE(208)

//命令
#define Command_kaiji @"control-startMachine"  //开机
#define Command_guanji @"control-stopMachine"//关机
#define Command_kaikuaimen @"control-startShutter"//开快门
#define Command_guankuaimen @"control-stopShutter"//关开门

#define Command_guan @"control-testChart-off"//关
#define Command_wangge @"control-testChart-gridding"//网格
#define Command_bai @"control-testChart-white"//白
#define Command_hong @"control-testChart-red"//红
#define Command_lv @"control-testChart-green"//绿
#define Command_lan @"control-testChart-blue"//蓝
#define Command_hei @"control-testChart-black"//黑

#define Monitor_information @"information source"  //查询信号源
#define Monitor_status @"Power Supply"//查询投影机状态
#define Monitor_device_info @"deviceInfo"//信息获取
#define Monitor_shutter_info @"Shutter"//查询光源
#endif /* config_h */
