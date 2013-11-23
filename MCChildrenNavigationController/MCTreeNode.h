//
//  MCTreeNode.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTreeNode : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSArray *children;

- (instancetype)initWithLabel:(NSString *)aLabel children:(NSArray *)childrenOrNil;

@end
