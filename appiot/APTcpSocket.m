//
//  APTcpSocket.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/29.
//

#import "APTcpSocket.h"
#define ConnectTime -1
static APTcpSocket *shareManager = nil;


@implementation APTcpSocket
//#pragma mark 伪单例模式
//+ (APTcpSocket *)shareManager
//{
//    static dispatch_once_t onecToken;
//    dispatch_once(&onecToken, ^{
//        shareManager = [[APTcpSocket alloc] init];
//    });
//    return shareManager;
//}


#pragma mark连接服务器
- (void)connectToHost:(NSString *)host Port:(NSUInteger)port
{

    if (self.socket == nil || [self.socket isDisconnected])
    {
        dispatch_queue_t queue = dispatch_queue_create("tcpqueue", NULL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue socketQueue:nil];
//        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:shareManager delegateQueue:dispatch_get_main_queue()];
    }
    
    if (self.socket && self.socket.isConnected)
    {
        [self sendData];
        return;
    }

    [self.socket connectToHost:host onPort:(uint16_t)port withTimeout:ConnectTime error:nil];

}

- (void)connectToHost
{

    if (self.socket == nil || [self.socket isDisconnected])
    {
        dispatch_queue_t queue = dispatch_queue_create("tcpqueue", NULL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue socketQueue:nil];
//        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:shareManager delegateQueue:dispatch_get_main_queue()];
    }
    
    if (self.socket && self.socket.isConnected)
    {
        [self sendData];
        return;
    }

    [self.socket connectToHost:self.ip onPort:(uint16_t)self.port withTimeout:ConnectTime error:nil];

}
#pragma mark 发送数据
-(void)sendData
{
    if (self.socket && self.socket.isConnected)
    {
        if (self.senddata)
        {
            [self.socket writeData:self.senddata withTimeout:-1 tag:0];
        }
//        NSLog(@"%p发送：%@",self.socket, self.senddata);
        [self.socket readDataWithTimeout:-1 tag:0];
    }
}

#pragma mark 已连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *message = [NSString stringWithFormat:@"%@",host];
    NSLog(@"tcp ip = %@:连接成功",message);
    [self sendData];
    if (self.didConnectedBlock)
    {
        self.didConnectedBlock(message);
    }
    
    // 读取数据
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 已经向服务器发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSString *message = [NSString stringWithFormat:@"ip = %@:发送数据成功",self.ip];
    NSLog(@"%@",message);
}


#pragma mark 服务器返回数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [APTool dictionaryWithJsonString:receiverStr];
//    NSLog(@"%@收到数据: %@",sock,receiverStr);
//    NSLog(@"1 == %@", [NSThread currentThread]);

    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.socketMessageBlock)
        {
            self.socketMessageBlock(receiverStr);
        }
//        NSLog(@"2 == %@", [NSThread currentThread]);

    });
    
    
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 连接失败,可以在这里设置重连
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString *message = [NSString stringWithFormat:@"tcp ip = %@ ：连接失败\n",self.ip];
//    NSLog(@"%@",message);
    if (self.didDisconnectBlock)
    {
        self.didDisconnectBlock(message);
    }
}

@end
