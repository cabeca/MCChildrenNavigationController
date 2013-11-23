//
//  MCTreeNode.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCTreeNode.h"

@implementation MCTreeNode

- (instancetype)initWithLabel:(NSString *)aLabel children:(NSArray *)childrenOrNil
{
    self = [super init];
    if (self) {
        _label = aLabel;
        _children = childrenOrNil;
    }
    return self;
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> '%@' (%d children)", [self class], self, self.label, [self.children count]];
}
@end
