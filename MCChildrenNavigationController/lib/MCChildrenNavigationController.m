//
//  MCChildrenNavigationController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCChildrenNavigationController.h"
#import "MCEmptyViewController.h"
#import "MCChildrenViewController.h"

@interface MCChildrenNavigationController ()
@property (strong, nonatomic) id<MCChildrenCollection> selectedNodeCache;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@end

@implementation MCChildrenNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedNodeCache = nil;
        
        _rootNode = nil;
        _selectedNodeIndexPath = nil;
        _selectionMode = MCChildrenNavigationControllerSelectionModeAll;
        _maximumLevel = MCChildrenNavigationControllerMaximumLevelNone;
        
        _selectedNodeBlock = ^void(id<MCChildrenCollection> node, NSIndexPath *indexPath){};
        _configureChildrenViewControllerBlock = ^void(UIViewController *childrenViewController){};
        _configureEmptyViewControllerBlock = ^void(UIViewController *emptyViewController){};
        _configureTableViewBlock = ^void(UITableView *tableView, id<MCChildrenCollection> node){};
        _configureTableViewCellBlock = ^void(UITableViewCell *cell){};
        _configureAllNodeSelectionButtonBlock = ^void(MCTableHeaderViewButton *button, BOOL isSelected){};
    }
    return self;
}

- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
{
    return [self initWithRootNode:aRootNode selectedNodeIndexPath:nil selectedNodeBlock:nil];
}

- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath
{
    return [self initWithRootNode:aRootNode selectedNodeIndexPath:aSelectedNodeIndexPath selectedNodeBlock:nil];
}

- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath
     selectedNodeBlock:(selectedNodeBlock)aSelectedNodeBlock
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _rootNode = aRootNode;
        _selectedNodeIndexPath = aSelectedNodeIndexPath;
        _selectedNodeBlock = aSelectedNodeBlock;
    }
    return self;
}

- (void)setRootNode:(id<MCChildrenCollection>)rootNode
{
    _rootNode = rootNode;
    [self pushViewControllers];
}

- (void)setSelectedNodeIndexPath:(NSIndexPath *)selectedNodeIndexPath
{
    _selectedNodeIndexPath = selectedNodeIndexPath;
    _selectedNodeCache = nil;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pushViewControllers];
}

#pragma mark - Public

- (void)highlightSelectedNodeAnimated:(BOOL)animated
{
    MCChildrenViewController *childrenViewController = (MCChildrenViewController *)self.topViewController;
    [childrenViewController selectRowInTableViewAnimated:animated];
}

- (void)unhighlightSelectedNodeAnimated:(BOOL)animated
{
    MCChildrenViewController *childrenViewController = (MCChildrenViewController *)self.topViewController;
    [childrenViewController deselectRowInTableViewAnimated:animated];
}

#pragma mark - Private

- (void)pushViewControllers
{
    if (self.rootNode) {
        [self pushChildrenViewControllers];
    } else {
        [self pushEmptyViewController];
    }
}

- (void)pushEmptyViewController
{
    MCEmptyViewController *emptyViewController = [[MCEmptyViewController alloc] init];
    [emptyViewController changeCancelTitle:self.cancelButtonTitle];
    self.configureEmptyViewControllerBlock(emptyViewController);

    self.viewControllers = @[emptyViewController];
}

- (void)pushChildrenViewControllers
{
    self.viewControllers = @[];
    if (self.selectedNodeIndexPath) {
        [self pushChildrenViewControllersForSelectedNode];
    } else {
        [self pushChildrenViewControllerForRootNode];
    }
}

- (MCChildrenViewController *)pushChildrenViewControllerForRootNode
{
    return [self pushChildrenViewControllerForNode:self.rootNode level:0 index:-1 animated:NO];
}

- (void)pushChildrenViewControllersForSelectedNode
{
    MCChildrenViewController *currentViewController = nil;
    currentViewController = [self pushChildrenViewControllerForRootNode];
    
    for (NSInteger currentPosition = 0; currentPosition < [self.selectedNodeIndexPath length]; currentPosition++) {
        NSInteger currentIndex = [self.selectedNodeIndexPath indexAtPosition:currentPosition];
        
        if ([self childrenViewController:currentViewController canNavigateToChildIndex:currentIndex]) {
            id<MCChildrenCollection> node = currentViewController.node.children[currentIndex];
            NSInteger level = currentViewController.level + 1;
            currentViewController = [self pushChildrenViewControllerForNode:node level:level index:currentIndex animated:NO];
        } else {
            break;
        }
    }
}

- (MCChildrenViewController *)pushChildrenViewControllerForNode:(id<MCChildrenCollection>)node
                                    level:(NSInteger)level
                                    index:(NSInteger)index
                                 animated:(BOOL)animated
{
    MCChildrenViewController *childrenViewController =
        [[MCChildrenViewController alloc] initWithNode:node level:level index:index];

    childrenViewController.delegate = self;
    [childrenViewController changeCancelTitle:self.cancelButtonTitle];
    childrenViewController.configureTableViewBlock = self.configureTableViewBlock;
    childrenViewController.configureTableViewCellBlock = self.configureTableViewCellBlock;
    childrenViewController.configureAllNodeSelectionButtonBlock = self.configureAllNodeSelectionButtonBlock;
    childrenViewController.configureSpecialRootFeatureButtonBlock = self.configureSpecialRootFeatureButtonBlock;
    self.configureChildrenViewControllerBlock(childrenViewController);
    
    [self pushViewController:childrenViewController animated:animated];
    return childrenViewController;
}

- (id<MCChildrenCollection>)selectedNode
{
    if (!self.selectedNodeIndexPath) {
        return nil;
    }
    if (!_selectedNodeCache) {
        id<MCChildrenCollection> currentNode = self.rootNode;
        
        for (NSInteger currentPosition = 0; currentPosition < [self.selectedNodeIndexPath length]; currentPosition++) {
            NSInteger currentIndex = [self.selectedNodeIndexPath indexAtPosition:currentPosition];
            currentNode = currentNode.children[currentIndex];
        }
        _selectedNodeCache = currentNode;
    }
    return _selectedNodeCache;
}

- (NSIndexPath *)indexPathForCurrentNode
{
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    
    for (MCChildrenViewController *childrenViewController in self.viewControllers) {
        if (childrenViewController.node == self.rootNode) {
            continue;
        }
        indexPath = [indexPath indexPathByAddingIndex:childrenViewController.index];
    }
    
    return indexPath;
}

#pragma mark - MCChildrenViewControllerDelegate

- (BOOL)childrenViewController:(MCChildrenViewController *)childrenViewController
       canNavigateToChildIndex:(NSInteger)childIndex
{
    if ([childrenViewController.node.children count] <= childIndex) {
        return NO;
    }
    
    id<MCChildrenCollection> child = childrenViewController.node.children[childIndex];
    NSInteger childLevel = childrenViewController.level + 1;
    
    return child.children &&
        ((childLevel <= self.maximumLevel) ||
         (self.maximumLevel == MCChildrenNavigationControllerMaximumLevelNone));
}

- (BOOL)childrenViewController:(MCChildrenViewController *)childrenViewController
        canSelectChildIndex:(NSInteger)childIndex
{
    return (self.selectionMode != MCChildrenNavigationControllerSelectionModeNone) &&
        (![self childrenViewController:childrenViewController canNavigateToChildIndex:childIndex]);
}

- (BOOL)childrenViewController:(MCChildrenViewController *)childrenViewController
        shouldSelectChildIndex:(NSInteger)childIndex
{
    id<MCChildrenCollection> child = childrenViewController.node.children[childIndex];
    
    return (child == [self selectedNode]) &&
        [self childrenViewController:childrenViewController canSelectChildIndex:childIndex];
}

- (BOOL)childrenViewControllerShouldShowAllNodeSelectionButton:(MCChildrenViewController *)childrenViewController
{
    return (self.selectionMode == MCChildrenNavigationControllerSelectionModeAll) ||
        ((self.selectionMode == MCChildrenNavigationControllerSelectionModeNoRoot) &&
         (childrenViewController.level != 0));
}

- (BOOL)childrenViewControllerShouldSelectAllNodeSelectionButton:(MCChildrenViewController *)childrenViewController
{
    return (childrenViewController.node == [self selectedNode]) &&
        [self childrenViewControllerShouldShowAllNodeSelectionButton:childrenViewController];
}

- (void)childrenViewController:(MCChildrenViewController *)childrenViewController
           didSelectChildIndex:(NSInteger)childIndex
{
    id<MCChildrenCollection> node = childrenViewController.node.children[childIndex];

    if ([self childrenViewController:childrenViewController canSelectChildIndex:childIndex]) {
        self.selectedNodeIndexPath = [[self indexPathForCurrentNode] indexPathByAddingIndex:childIndex];
        self.selectedNodeBlock(node, self.selectedNodeIndexPath);
    }
    if ([self childrenViewController:childrenViewController canNavigateToChildIndex:childIndex]) {
        NSInteger level = childrenViewController.level + 1;
        [self pushChildrenViewControllerForNode:node level:level index:childIndex animated:YES];
    }
    self.specialRootFeatureSelected = NO;
}

- (void)childrenViewControllerDidSelectAll:(MCChildrenViewController *)childrenViewController
{
    id<MCChildrenCollection> node = childrenViewController.node;

    self.selectedNodeIndexPath = [self indexPathForCurrentNode];
    self.selectedNodeBlock(node, self.selectedNodeIndexPath);
    self.specialRootFeatureSelected = NO;
    return;
}

- (BOOL)childrenViewControllerShouldShowSpecialRootFeatureButton:(MCChildrenViewController *)childrenViewController
{
    return self.isSpecialRootFeatureEnabled && childrenViewController.level == 0;
}

- (BOOL)childrenViewControllerShouldSelectSpecialRootFeatureButton:(MCChildrenViewController *)childrenViewController
{
    return self.isSpecialRootFeatureEnabled && self.isSpecialRootFeatureSelected;
}

- (void)childrenViewControllerDidSelectSpecialRootFeatureButton:(MCChildrenViewController *)childrenViewController
{
    self.specialRootFeatureSelected = YES;
    self.selectedNodeIndexPath = nil;
    self.selectedSpecialRootFeatureBlock();
}

#pragma mark - Changing the cancel title

- (void)changeChildrensCancelTitle:(NSString *)cancelTitle
{
    self.cancelButtonTitle = cancelTitle;
    
    for (id viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[MCChildrenViewController class]]) {
            MCChildrenViewController *vc = (MCChildrenViewController *)viewController;
            [vc changeCancelTitle:self.cancelButtonTitle];
        }
        else if ([viewController isKindOfClass:[MCEmptyViewController class]]) {
            MCEmptyViewController *vc = (MCEmptyViewController *)viewController;
            [vc changeCancelTitle:self.cancelButtonTitle];
        }
    }
}

@end
