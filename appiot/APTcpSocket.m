//
//  APTcpSocket.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/29.
//

#import "APTcpSocket.h"
#define ConnectTime -1


@implementation APTcpSocket
#pragma mark 伪单例模式
//+ (APTcpSocket *)shareManager
//{
//    static APTcpSocket *shareManager = nil;
//    static dispatch_once_t onecToken;
//    dispatch_once(&onecToken, ^{
//        shareManager = [[APTcpSocket alloc]init];
//    });
//    return shareManager;
//}

#pragma mark连接服务器
- (void)connectToHost:(NSString *)host Port:(NSUInteger)port
{
    if (self.socket == nil || [self.socket isDisconnected])
    {
//        dispatch_queue_t queue = dispatch_queue_create("com.test.testsocket.setter", DISPATCH_QUEUE_SERIAL);
//        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue socketQueue:nil];
//        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

//        self.socket.IPv4PreferredOverIPv6 = NO; // 设置支持IPV6
        
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.socket.delegate = self;
//        NSError *error = nil;
//        if (![self.socket connectToHost:host onPort:port error:&error]) {
//            //该方法异步
//            GFFLog(@"%@",  @"连接服务器失败");
//        }
    }
    NSError *error = nil;
    BOOL isConnectHost = [self.socket connectToHost:host
                                             onPort:(uint16_t)port
                                        withTimeout:ConnectTime
                                            error:&error];
    if (isConnectHost == NO)//没有链接到服务器
    {
        NSLog(@"ERROR:%@",error.description);
    }
}

#pragma mark 发送数据
-(void)sendData:(NSData *)contents
{
    NSError *error = nil;

//    NSData *contents = [NSJSONSerialization dataWithJSONObject:messageDict options:NSJSONWritingPrettyPrinted error:&error];
//        if(error)
//        {
//            NSLog(@"ERROR:%@",error.description);
//        }
        // 获取长度
//        int len = (int)contents.length;
//        NSData *lengthData = [NSData dataWithBytes:&len length:sizeof(len)];
        // 发送长度
//        [self.socket writeData:lengthData withTimeout:-1 tag:0];
        // 发送真实数据
        [self.socket writeData:contents withTimeout:-1 tag:0];
}
#pragma mark 已连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *message = [NSString stringWithFormat:@"DidConnectToHost.Host:%@--Port:%hu",host,port];
    NSLog(@"%@",message);
    APTool *tool = [APTool shareInstance];
//        NSString *str  = [tool stringFromHexString:@"41542B646576696365496E666F3F0D"];
    NSString *hex = [tool hexStringFromString:@"AT+deviceInfo?\r"];
    NSData *data = [tool convertHexStrToData:hex];
    
    [self sendData:data];
    // 读取数据
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 连接失败,可以在这里设置重连
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString *message = [NSString stringWithFormat:@"SocketDidDisconnect.ERROR:%@\n",err.description];
    NSLog(@"%@",message);
//    self.disconnectWithHost();

    //TODO:设置重连
}

#pragma mark 长时间没有接收到数据
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSString *message = [NSString stringWithFormat:@"DidAcceptNewSocket:%@",newSocket];
    NSLog(@"%@",message);
}

#pragma mark 服务器返回数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:0];
//    NSString *message = [NSData dataWithGBKEncodingOfData:data];
//    self.socketMessageBlock(message);
//    self.faceCompareTask(data, tag, message, sock);
}

#pragma mark 服务器返回的数据段长度
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSString *message = [NSString stringWithFormat:@"DidReadPartialDataOfLength:%lu",(unsigned long)partialLength];
    NSLog(@"%@",message);
}

#pragma mark 已经向服务器发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSString *message = [NSString stringWithFormat:@"DidWriteDataWithTag:%ld",tag];
    NSLog(@"%@",message);
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSString *message = [NSString stringWithFormat:@"DidWritePartialDataOfLength:%lu",(unsigned long)partialLength];
    NSLog(@"%@",message);
}

@end
