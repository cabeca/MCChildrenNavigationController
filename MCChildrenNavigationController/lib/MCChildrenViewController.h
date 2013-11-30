//
//  MCChildrenViewController.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChildrenCollection.h"
#import "MCChildrenViewControllerDelegate.h"

typedef void (^configureTableViewBlock)(UITableView *tableView);
typedef void (^configureTableViewCellBlock)(UITableViewCell *cell);

@interface MCChildrenViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<MCChildrenCollection> node;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id<MCChildrenViewControllerDelegate> delegate;

@property (nonatomic, copy) configureTableViewBlock configureTableViewBlock;
@property (nonatomic, copy) configureTableViewCellBlock configureTableViewCellBlock;

- (id)initWithNode:(id<MCChildrenCollection>)aNode level:(NSInteger)aLevel index:(NSInteger)anIndex;

@end
