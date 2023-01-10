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
            sharedInstance = [[APUdpSocket alloc] init];
//            [sharedInstance createClientUdpSocket];
            });
    return sharedInstance;
}

#pragma mark -- 创建socket
-(void)createClientUdpSocket
{
    //1.创建一个 udp socket用来和服务器端进行通讯
//    if (_udpSocket == nil)
    {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:sharedInstance delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        NSError * error = nil;
        //广播
        [_udpSocket enableBroadcast:YES error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }else{
            [_udpSocket beginReceiving:&error];
        }
    }
}
-(void)broadcast:(NSData *)data
{
    if (_udpSocket)
    {
        //如果向特定ip发送，这里要写明ip
        _host = @"255.255.255.255";
        [self.udpSocket sendData:data toHost:_host port:_port withTimeout:-1 tag:100];
    }
}

- (void)sendMessage:(NSData *)data
{
    if (_udpSocket)
    {
        [_udpSocket sendData:data toHost:_host port:_port withTimeout:30 tag:100];
    }
}
-(void)cutOffSocket; // 断开socket连接
{
    if (_udpSocket && [_udpSocket isConnected])
    {
        [_udpSocket closeAfterSending];
    }
}

#pragma mark -GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSString *message = [NSString stringWithFormat:@"连接成功"];
    NSLog(@"%@",message);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error
{
    NSString *message = [NSString stringWithFormat:@"连接失败.ERROR:%@\n",error.description];
    NSLog(@"%@",message);
    if (self.didDisconnectBlock)
    {
        self.didDisconnectBlock(message);
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"收到响应 [%@:%d] == %@", ip, port, receiverStr);
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.socketMessageBlock)
        {
            self.socketMessageBlock(data);
        }
    });
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocket关闭");
}
@end
