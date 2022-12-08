//
//  APGroupTableView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import "APGroupTableView.h"
#import "AppDelegate.h"
@implementation APGroupTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        //        self.dataSource = self;
        //        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
