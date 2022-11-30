//
//  APUdpSocket.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/21.
//

#import "APUdpSocket.h"
static APUdpSocket *sharedInstance = nil;

@implementation APUdpSocket

+ (APUdpSocket *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            sharedInstance = [[APUdpSocket alloc]init];
//            [sharedInstance createClientUdpSocket];
            });
    return sharedInstance;
}

#pragma mark -- 创建socket
-(void)createClientUdpSocket
{
    //1.创建一个 udp socket用来和服务器端进行通讯
    if (_udpSocket == nil)
    {
        [_udpSocket closeAfterSending];
        
        dispatch_queue_t qQueue = dispatch_queue_create("Client queue", NULL);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:sharedInstance delegateQueue:qQueue];
        NSError * error = nil;
        if([_udpSocket bindToPort :_port error:&error])
        {
            NSLog(@"bindToPort");
        }
        //广播
        [_udpSocket enableBroadcast:YES error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }else{
            [_udpSocket beginReceiving:&error];
        }
        
//        if ([_udpSocket connectToHost:_host onPort:_port error:&error])
//        {
//            NSLog(@"udpsoket连接成功");
//        }
        
        // 开始接收对方发来的消息
//        [_udpSocket beginReceiving:nil];
    }
}
-(void)broadcast:(NSData *)data
{
   //消息内容
//    NSData *sendData = [self convertHexStrToData:message];
    //如果向特定ip发送，这里要写明ip
    [self.udpSocket sendData:data toHost:_host port:_port withTimeout:-1 tag:100];
}

- (void)sendMessage:(NSString *)message
{
    if (_udpSocket)
    {
//        NSData *sendData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSData *sendData = [self convertHexStrToData:message];

        [_udpSocket sendData:sendData toHost:_host port:_port withTimeout:60 tag:100];
    }

}
-(void)cutOffSocket; // 断开socket连接
{
    if (_udpSocket && [_udpSocket isConnected])
    {
        [_udpSocket closeAfterSending];
    }
}
#pragma mark - 十六进制转换工具
// 16进制转NSData
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

-(NSData *)hexString:(NSString *)hexString {
    int j=0;
    Byte bytes[20];
    ///3ds key的Byte 数组， 128位
    for(int i=0; i<[hexString length]; i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i];// 两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;//    0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;//  A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16;//  a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);//  0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55;//  A 的Ascll - 65
        else
            int_ch2 = hex_char2-87;//  a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:20];
    
    return newData;
}

// NSData转16进制 第一种
- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}
#pragma mark -GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"接收到%@的消息:%@",address,data);//自行转换格式吧
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocket关闭");
}
@end
