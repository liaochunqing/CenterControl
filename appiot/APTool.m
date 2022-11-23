//
//  APTool.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import "APTool.h"

@implementation APTool
//单例
+(APTool *)shareInstance{
    static APTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APTool alloc]init];
    });
    return instance;
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
