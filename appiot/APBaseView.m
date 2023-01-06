//
//  APBaseView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APBaseView.h"

@implementation APBaseView


//颜色转换为背景图片
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


-(NSArray *)resolveValue:(NSString *)parameter_value
{
    NSMutableArray *returnArray = [NSMutableArray array];

    NSString* pattern=@"(?<=,value:\"\\{)(.*?)(?=\\}\")";
    NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:pattern
                                      options:NSRegularExpressionCaseInsensitive error:nil];


    NSArray *match = [regex matchesInString:parameter_value options:0 range:NSMakeRange(0, parameter_value.length)];
    for (NSTextCheckingResult* b in match)
    {
        NSRange resultRange = [b rangeAtIndex:0];
        //从urlString当中截取数据
        NSString *result=[parameter_value substringWithRange:resultRange];
        if (result)
        {
            NSArray *tempArr = [result componentsSeparatedByString:@","];
            for (NSString *str  in tempArr)
            {
                NSArray *tempArr = [str componentsSeparatedByString:@":"];
                if(tempArr.count > 1)
                {
                    NSString *first = [tempArr firstObject];
                    
                    first = [first stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [first length])];
                    
                    NSString *last = [tempArr lastObject];
                    last = [last stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [last length])];

                    NSDictionary *dict = [NSDictionary dictionaryWithObject:last forKey:first];
                    [returnArray addObject:dict];
                }
            }
        }
    }
    return returnArray;
}
@end
