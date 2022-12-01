//
//  AppDelegate.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/9.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "APViewController.h"

//#import "MMDrawerController.h"
//#import "APBaseViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic,strong)UIWindow *window;
@property (nonatomic,strong) APViewController *mainVC;
//@property (strong, nonatomic) UIButton *button;//悬浮小球按钮

- (void)saveContext;


@end

