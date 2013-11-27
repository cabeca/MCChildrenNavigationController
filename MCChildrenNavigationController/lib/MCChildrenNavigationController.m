//
//  MCChildrenNavigationController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCChildrenNavigationController.h"
#import "MCChildrenViewController.h"

@interface MCChildrenNavigationController ()
@end

@implementation MCChildrenNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pushViewControllers];
}

- (void)pushViewControllers
{
    if (self.rootNode) {
        [self pushChildrenViewControllers];
    } else {
        [self pushEmptyController];
    }
}

- (void)pushEmptyController
{
    UIViewController *emptyController = [[UIViewController alloc] init];
    emptyController.navigationItem.title = @"Loading...";
    emptyController.view.backgroundColor = [UIColor whiteColor];
    [self pushViewController:emptyController animated:NO];
}

- (void)pushChildrenViewControllers
{
    self.viewControllers = @[];
    if (self.selectedNodeIndexPath) {
        [self pushChildrenViewControllersForSelectedNode];
    } else {
        [self pushChildrenViewControllersForRootNode];
    }
}


- (void)pushChildrenViewControllersForRootNode
{
    [self pushChildrenViewControllerForNode:self.rootNode animated:NO];
}

- (void)pushChildrenViewControllersForSelectedNode
{
    NSInteger currentIndex = 0;
    NSInteger maximumLevel = [self.selectedNodeIndexPath length];
    id<MCChildrenCollection> currentNode = self.rootNode;
    
    while (self.currentLevel < maximumLevel) {
        [self pushChildrenViewControllerForNode:currentNode animated:NO];
        if (self.currentLevel < [self.selectedNodeIndexPath length]) {
            currentIndex = [self.selectedNodeIndexPath indexAtPosition:self.currentLevel];
            currentNode = currentNode.children[currentIndex];
        }
    }
    if (!currentNode.children) {
        [self popViewControllerAnimated:NO];
    }
}

#pragma - MCChildrenViewControllerDelegate
- (void)childrenViewController:(MCChildrenViewController *)childrenViewController didSelectChild:(MCChildrenSelected)selectedChild
{
    if (selectedChild == MCChildrenSelectedNone) {
        return;
    }
    if (selectedChild == MCChildrenSelectedAll) {
        NSLog(@"Selected node %@", childrenViewController.node);
        if (self.selectedNodeBlock) {
            self.selectedNodeIndexPath = [self indexPathForSelectedNode];
            self.selectedNodeBlock(childrenViewController.node, self.selectedNodeIndexPath);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    id<MCChildrenCollection> child = childrenViewController.node.children[selectedChild];
    if (child.children) {
        [self pushChildrenViewControllerForNode:child animated:YES];
    } else {
        NSLog(@"Selected node %@", child);
        if (self.selectedNodeBlock) {
            self.selectedNodeIndexPath = [[self indexPathForSelectedNode] indexPathByAddingIndex:selectedChild];
            self.selectedNodeBlock(child, self.selectedNodeIndexPath);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pushChildrenViewControllerForNode:(id<MCChildrenCollection>)node animated:(BOOL)animated
{
    MCChildrenViewController *childrenViewController = [[MCChildrenViewController alloc] initWithNode:node];
    childrenViewController.delegate = self;
    if (self.selectedNodeIndexPath) {
        childrenViewController.selectedChild = [self selectedChildForNode:node];
    }
    [self pushViewController:childrenViewController animated:animated];
}

- (NSInteger)currentLevel
{
    return [self.viewControllers count] - 1;
}

- (MCChildrenSelected)selectedChildForNode:(id<MCChildrenCollection>)node
{
    if ([node isEqual:[self selectedNode]]) {
        return MCChildrenSelectedAll;
    }
    NSInteger childIndex = [node.children indexOfObject:[self selectedNode]];
    if (childIndex == NSNotFound) {
        return MCChildrenSelectedNone;
    } else {
        return childIndex;
    }
}

- (id<MCChildrenCollection>)selectedNode
{
    id<MCChildrenCollection> currentNode = self.rootNode;
    
    for (NSInteger currentPosition = 0; currentPosition < [self.selectedNodeIndexPath length]; currentPosition++) {
        NSInteger currentIndex = [self.selectedNodeIndexPath indexAtPosition:currentPosition];
        currentNode = currentNode.children[currentIndex];
    }
    return currentNode;
}

- (NSIndexPath *)indexPathForSelectedNode
{
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    id<MCChildrenCollection> currentNode = self.rootNode;
    
    for (MCChildrenViewController *childrenViewController in self.viewControllers) {
        if (childrenViewController.node == self.rootNode) {
            continue;
        }
        NSInteger index = [currentNode.children indexOfObject:childrenViewController.node];
        indexPath = [indexPath indexPathByAddingIndex:index];
        currentNode = currentNode.children[index];
    }
    return indexPath;
}

@end
