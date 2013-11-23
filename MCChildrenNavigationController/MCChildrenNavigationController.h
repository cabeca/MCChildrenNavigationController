//
//  MCChildrenNavigationController.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChildrenCollection.h"
#import "MCArrayDataSource.h"

@interface MCChildrenNavigationController : UINavigationController

@property (nonatomic, strong) id<MCChildrenCollection> rootNode;
@property (nonatomic, strong) MCArrayDataSource *dataSource;

@end

