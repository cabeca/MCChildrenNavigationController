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
#import "MCChildrenViewControllerDelegate.h"

typedef NS_ENUM(NSInteger, MCChildrenSelected) {
    MCChildrenSelectedNone = -2,
    MCChildrenSelectedAll = -1
};

@interface MCChildrenViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<MCChildrenCollection> node;
@property (nonatomic, assign) MCChildrenSelected selectedChild;
@property (nonatomic, weak) id<MCChildrenViewControllerDelegate> delegate;

- (id)initWithNode:(id<MCChildrenCollection>)aNode;
- (id)initWithNode:(id<MCChildrenCollection>)aNode selectedChild:(MCChildrenSelected)aSelectedChild;

@end
