//
//  APTcpSocket.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/29.
//

#import "APTcpSocket.h"
#define ConnectTime 5
static APTcpSocket *shareManager = nil;


@implementation APTcpSocket

#pragma mark连接服务器

- (void)connectToHost
{
//    if (self.socket == nil || self.socket.isConnected == NO)
    if (self.socket == nil)
    {
//        dispatch_queue_t queue = dispatch_queue_create("tcpqueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue socketQueue:nil];
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
            [self.socket writeData:self.senddata withTimeout:ConnectTime tag:0];
        }
//        NSLog(@"%p发送：%@",self.socket, self.senddata);
        [self.socket readDataWithTimeout:ConnectTime tag:0];
    }
}

#pragma mark 已连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *message = [NSString stringWithFormat:@"%@",host];
    NSLog(@"tcp ip = %@:连接成功",message);
    [self sendData];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.didConnectedBlock)
        {
            self.didConnectedBlock(message);
        }
    });
    
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
    
    [sock readDataWithTimeout:ConnectTime tag:0];
}

#pragma mark 连接失败,可以在这里设置重连
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString *message = [NSString stringWithFormat:@"tcp ip = %@ ：连接失败%d\n",self.ip, sock.isConnected];
    NSLog(@"%@",message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.didDisconnectBlock)
        {
            self.didDisconnectBlock(message);
        }
    });
    
}

@end
