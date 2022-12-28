//
//  APGroupNote.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import "APGroupNote.h"

@implementation APGroupNote

- (instancetype)init
{
    if (self = [super init])
    {
        self.height = Group_Cell_Height;
        self.expand = YES;
        self.haveChild = NO;
        self.childNumber = 0;

        self.commandDict = [NSMutableDictionary dictionary];
        self.monitorDict = [NSMutableDictionary dictionary];
    }
    return self;
}
@end
