//
//  AppDelegate.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/9.
//

#import "AppDelegate.h"
//#import "APLeftViewController.h"
//#import "APCenterViewController.h"

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

//-(void)createButton{
//    if (!_button) {
////        _window = [[UIApplication sharedApplication] keyWindow];
//        _window.backgroundColor = [UIColor whiteColor];
//        [_window addSubview:self.button];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:
//                                       self action:@selector(locationChange:)];
//        pan.delaysTouchesBegan = YES;
//        [_button addGestureRecognizer:pan];
//    }
//}
//
//- (UIButton*)button {
//    if (!_button) {
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        _button.frame = CGRectMake(W_SCALE(250), H_SCALE(468), W_SCALE(55), H_SCALE(55));//初始在屏幕上的位置
//        [_button setImage:[UIImage imageNamed:@"Group 11697"] forState:UIControlStateNormal];
//    }
//    return _button;
//}
//
//-(void)locationChange:(UIPanGestureRecognizer*)p{
//    CGFloat HEIGHT=_button.frame.size.height;
//    CGFloat WIDTH=_button.frame.size.width;
//    BOOL isOver = NO;
//    CGPoint panPoint = [p locationInView:[UIApplication sharedApplication].windows[0]];
//    CGRect frame = CGRectMake(panPoint.x, panPoint.y, HEIGHT, WIDTH);
//    NSLog(@"%f--panPoint.x-%f-panPoint.y-", panPoint.x, panPoint.y);
//    if(p.state == UIGestureRecognizerStateChanged){
//        _button.center = CGPointMake(panPoint.x, panPoint.y);
//    }
//    else if(p.state == UIGestureRecognizerStateEnded){
//        if (panPoint.x + WIDTH > SCREEN_WIDTH) {
//            frame.origin.x = SCREEN_WIDTH - WIDTH;
//            isOver = YES;
//        } else if (panPoint.y + HEIGHT > SCREEN_HEIGHT) {
//            frame.origin.y = SCREEN_HEIGHT - HEIGHT;
//            isOver = YES;
//        } else if(panPoint.x - WIDTH / 2< 0) {
//            frame.origin.x = 0;
//            isOver = YES;
//        } else if(panPoint.y - HEIGHT / 2 < 0) {
//            frame.origin.y = 0;
//            isOver = YES;
//        }
//        if (isOver) {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.button.frame = frame;
//            }];
//        }
//    }
//}
@end
