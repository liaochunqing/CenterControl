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
@end

NS_ASSUME_NONNULL_END
