//
//  MCChildrenViewController.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCArrayDataSource.h"
#import "MCChildrenCollection.h"

@interface MCChildrenViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<MCChildrenCollection> node;

@end
