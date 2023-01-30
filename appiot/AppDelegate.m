//
//  AppDelegate.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/9.
//

#import "AppDelegate.h"
//#import "APLeftViewController.h"
//#import "APCenterViewController.h"
struct kkk
{
    NSString *f;
    NSString *l;
};

@interface AppDelegate ()
//@property (nonatomic,strong)UIWindow *window;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //初始化当前window并设置其大小
    self.mainVC = [[APViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.rootViewController = self.mainVC;
    [self.window makeKeyAndVisible];
    

    //第三方键盘初始化
    IQKeyboardManager *keyBoardManager = [IQKeyboardManager sharedManager];
    keyBoardManager.enable=YES;
    keyBoardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyBoardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    keyBoardManager.enableAutoToolbar=YES;
    keyBoardManager.shouldShowToolbarPlaceholder = NO;
    keyBoardManager.keyboardDistanceFromTextField = 18;
    keyBoardManager.shouldResignOnTouchOutside = YES;
    
/*//无用代码
        NSString *enp = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"js"];
    NSString *zhp = [[NSBundle mainBundle] pathForResource:@"zh" ofType:@"js"];

        NSData *reader = [NSData dataWithContentsOfFile:enp];
        NSString *e = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    NSArray *earray = [e componentsSeparatedByString:@"\r\n"];
    NSMutableArray *ea = [NSMutableArray array];
    for (NSString *str  in earray)
    {
        NSArray *temp = [str componentsSeparatedByString:@":"];
        NSString *firststr = temp.firstObject;
        NSString *laststr = temp.lastObject;
        NSString *finalStr1 = [SafeStr(laststr) stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *finalStr = [finalStr1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *string1 = [SafeStr(finalStr) stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *string = [string1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        APGroupNote *node = [APGroupNote new];
        node.nodeId = firststr;
        node.name = string;
        [ea addObject:node];
    }
    
    reader = [NSData dataWithContentsOfFile:zhp];
    e = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    NSArray *zarray = [e componentsSeparatedByString:@"\r\n"];
    NSMutableArray *za = [NSMutableArray array];
    for (NSString *str  in zarray)
    {
        NSArray *temp = [str componentsSeparatedByString:@":"];
        NSString *firststr = temp.firstObject;
        NSString *laststr = temp.lastObject;
        NSString *finalStr1 = [SafeStr(laststr) stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *finalStr = [finalStr1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *string1 = [SafeStr(finalStr) stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *string = [string1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

//        NSDictionary *d = [NSDictionary dictionaryWithObject:string forKey:firststr];
        APGroupNote *node = [APGroupNote new];
        node.nodeId = firststr;
        node.name = string;
        [za addObject:node];
    }
    
    NSString *total = @"";
    int i = 0;
    NSMutableArray *tep = [NSMutableArray array];
    for (APGroupNote *node in ea)
    {
        NSString *f = node.nodeId;
        for (int k = (int)za.count - 1; k>=0; k--)
        {
            APGroupNote *zhnode = za[k];
            if ([f isEqualToString:zhnode.nodeId])
            {
                BOOL have = NO;
                for (APGroupNote *nn in tep)
                {
                    if ([nn.nodeId isEqualToString:f])
                    {
                        have = YES;
                    }
                }
                
                if (have == NO)
                {
                    i++;
                    total = [total stringByAppendingFormat:@"\"%@\" = \"%@\";\r\n",zhnode.name,node.name];
                    [tep addObject:zhnode];
                    [za removeObject:zhnode];
                }
                
            }
        }
    }
    
    NSLog(total);
    int l = 0;
    */
    return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"appiot"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
