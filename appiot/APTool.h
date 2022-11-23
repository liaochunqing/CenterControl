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
@end

NS_ASSUME_NONNULL_END
