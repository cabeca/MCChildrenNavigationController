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
#import "MCTableHeaderViewButton.h"

typedef void (^configureTableViewBlock)(UITableView *tableView, id<MCChildrenCollection> node);
typedef void (^configureTableViewCellBlock)(UITableViewCell *cell);
typedef void (^configureAllNodeSelectionButtonBlock)(MCTableHeaderViewButton *button, BOOL isSelected);
typedef void (^configureSpecialRootFeatureButtonBlock)(MCTableHeaderViewButton *button, BOOL isSelected);

@interface MCChildrenViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<MCChildrenCollection> node;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id<MCChildrenViewControllerDelegate> delegate;

@property (nonatomic, copy) configureTableViewBlock configureTableViewBlock;
@property (nonatomic, copy) configureTableViewCellBlock configureTableViewCellBlock;
@property (nonatomic, copy) configureAllNodeSelectionButtonBlock configureAllNodeSelectionButtonBlock;
@property (nonatomic, copy) configureSpecialRootFeatureButtonBlock configureSpecialRootFeatureButtonBlock;

- (id)initWithNode:(id<MCChildrenCollection>)aNode level:(NSInteger)aLevel index:(NSInteger)anIndex;

- (void)selectRowInTableViewAnimated:(BOOL)animated;
- (void)deselectRowInTableViewAnimated:(BOOL)animated;
- (void)changeCancelTitle:(NSString *)cancelTitle;

@end
