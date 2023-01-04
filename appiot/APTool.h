//
//  APTool.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
//工具类

@interface APTool : NSObject
//单例
+(APTool *)shareInstance;


- (UIImage *)imageWithColor:(UIColor *)color;

// 16进制转NSData
- (NSData *)convertHexStrToData:(NSString *)str;

//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString:(NSString *)string;

// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString;

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//UIAlertController 标题设置
-(void)setAlterviewTitleWith:(UIAlertController *)alert title:(NSString*)str color:(UIColor *)color;
//UIAlertController mesaage设置
-(void)setAlterviewMessageWith:(UIAlertController *)alert message:(NSString*)str color:(UIColor *)color;
//UIAlertController 背景颜色设置
-(void)setAlterviewBackgroundColor:(UIAlertController *)alert color:(UIColor*)color;


//设置不同字体颜色
-(void)fontColorLabel:(UILabel *)label FontNumber:(UIFont *)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
@end

NS_ASSUME_NONNULL_END
