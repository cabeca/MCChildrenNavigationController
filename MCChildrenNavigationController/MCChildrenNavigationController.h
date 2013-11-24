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

typedef void (^selectedNodeBlock)(id<MCChildrenCollection> node, NSIndexPath *indexPath);

@interface MCChildrenNavigationController : UINavigationController <MCChildrenViewControllerDelegate>

@property (nonatomic, strong) id<MCChildrenCollection> rootNode;
@property (nonatomic, strong) NSIndexPath *selectedNodeIndexPath;
@property (nonatomic, copy) selectedNodeBlock selectedNodeBlock;

- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode;
- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath;
- (id)initWithRootNode:(id<MCChildrenCollection>)aRootNode
 selectedNodeIndexPath:(NSIndexPath *)aSelectedNodeIndexPath
     selectedNodeBlock:(selectedNodeBlock)aSelectedNodeBlock;

@end

