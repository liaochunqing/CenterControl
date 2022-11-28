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
    }
    return self;
}

-(void)setSelectedAndCount:(BOOL)selected
{
//    self.selected = selected;
//    if (self.isDevice)
//    {
//        if (selected)
//        {
//            if (self.grandfather) self.grandfather.childSelected++;
//            if (self.father) self.father.childSelected++;
//        }
//        else
//        {
//            if (self.grandfather) self.grandfather.childSelected--;
//            if (self.father) self.father.childSelected--;
//        }
//    }
}

//- (instancetype)initWithParentId : (int)parentId
//                          nodeId : (int)nodeId
//                       imageName : (NSString *)imageName
//                            name : (NSString *)name
//                           depth : (int)depth
//                            height:(CGFloat)height
//                          expand : (BOOL)expand
//                         selected:(BOOL)selected
//{
//    if (self = [super init])
//    {
//        self.parentId = parentId;
//        self.nodeId = nodeId;
//        self.imageName = imageName;
//        self.name = name;
//        self.depth = depth;
//        self.height = height;
//        self.expand = expand;
//        self.haveChild = YES;
//    }
//    return self;
//}
@end
