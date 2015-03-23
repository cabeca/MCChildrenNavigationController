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
#import "MCTableHeaderViewButton.h"

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
typedef void (^configureChildrenViewControllerBlock)(UIViewController *childrenViewController);
typedef void (^configureEmptyViewControllerBlock)(UIViewController *emptyViewController);
typedef void (^configureTableViewBlock)(UITableView *tableView, id<MCChildrenCollection> node);
typedef void (^configureTableViewCellBlock)(UITableViewCell *cell);
typedef void (^configureTableHeaderViewBlock)(MCTableHeaderViewButton *button, BOOL isSelected);

@interface MCChildrenNavigationController : UINavigationController <MCChildrenViewControllerDelegate>

@property (nonatomic, strong) id<MCChildrenCollection> rootNode;
@property (nonatomic, strong) NSIndexPath *selectedNodeIndexPath;
@property (nonatomic, assign) MCChildrenNavigationControllerSelectionMode selectionMode;
@property (nonatomic, assign) NSInteger maximumLevel;

@property (nonatomic, copy) selectedNodeBlock selectedNodeBlock;
@property (nonatomic, copy) configureChildrenViewControllerBlock configureChildrenViewControllerBlock;
@property (nonatomic, copy) configureEmptyViewControllerBlock configureEmptyViewControllerBlock;
@property (nonatomic, copy) configureTableViewBlock configureTableViewBlock;
@property (nonatomic, copy) configureTableViewCellBlock configureTableViewCellBlock;
@property (nonatomic, copy) configureTableHeaderViewBlock configureTableHeaderViewBlock;

- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode;
- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath;
- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath
     selectedNodeBlock:(selectedNodeBlock)aSelectedNodeBlock;

- (void)highlightSelectedNodeAnimated:(BOOL)animated;
- (void)unhighlightSelectedNodeAnimated:(BOOL)animated;

- (void)changeChildrensCancelTitle:(NSString *)cancelTitle;

@end

