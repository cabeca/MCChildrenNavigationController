//
//  MCChildrenNavigationController.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChildrenCollection.h"
#import "MCChildrenViewControllerDelegate.h"

typedef NS_ENUM(NSInteger, MCChildrenNavigationControllerSelectionMode) {
    MCChildrenNavigationControllerSelectionModeAll,
    MCChildrenNavigationControllerSelectionModeNoRoot,
    MCChildrenNavigationControllerSelectionModeLeafs,
    MCChildrenNavigationControllerSelectionModeNone
};

typedef NS_ENUM(NSInteger, MCChildrenNavigationControllerMaximumLevel) {
    MCChildrenNavigationControllerMaximumLevelNone = -1
};

typedef void (^selectedNodeBlock)(id<MCChildrenCollection> node, NSIndexPath *indexPath);
typedef void (^configureNavigationControllerBlock)(UINavigationController *navigationController);
typedef void (^configureChildrenViewControllerBlock)(MCChildrenViewController *childrenViewController);
typedef void (^configureTableViewBlock)(UITableView *tableView);
typedef void (^configureTableViewCellBlock)(UITableViewCell *cell);

@interface MCChildrenNavigationController : UINavigationController <MCChildrenViewControllerDelegate>

@property (nonatomic, strong) id<MCChildrenCollection> rootNode;
@property (nonatomic, strong) NSIndexPath *selectedNodeIndexPath;
@property (nonatomic, assign) MCChildrenNavigationControllerSelectionMode selectionMode;
@property (nonatomic, assign) NSInteger maximumLevel;

@property (nonatomic, copy) selectedNodeBlock selectedNodeBlock;
@property (nonatomic, copy) configureNavigationControllerBlock configureNavigationControllerBlock;
@property (nonatomic, copy) configureChildrenViewControllerBlock configureChildrenViewControllerBlock;
@property (nonatomic, copy) configureTableViewBlock configureTableViewBlock;
@property (nonatomic, copy) configureTableViewCellBlock configureTableViewCellBlock;

- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode;
- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath;
- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath
     selectedNodeBlock:(selectedNodeBlock)aSelectedNodeBlock;

@end

