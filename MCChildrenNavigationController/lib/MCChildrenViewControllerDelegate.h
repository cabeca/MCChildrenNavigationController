//
//  MCChildrenViewControllerDelegate.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 24/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCChildrenViewController;

@protocol MCChildrenViewControllerDelegate <NSObject>

- (BOOL)childrenViewController:(MCChildrenViewController *)childrenViewController
       canNavigateToChildIndex:(NSInteger)childIndex;

- (BOOL)childrenViewController:(MCChildrenViewController *)childrenViewController
       canSelectChildIndex:(NSInteger)childIndex;

- (BOOL)childrenViewController:(MCChildrenViewController *)childrenViewController
        shouldSelectChildIndex:(NSInteger)childIndex;

- (BOOL)childrenViewControllerShouldShowAllNodeSelectionButton:(MCChildrenViewController *)childrenViewController;

- (BOOL)childrenViewControllerShouldSelectAllNodeSelectionButton:(MCChildrenViewController *)childrenViewController;

- (void)childrenViewController:(MCChildrenViewController *)childrenViewController
           didSelectChildIndex:(NSInteger)childIndex;

- (void)childrenViewControllerDidSelectAll:(MCChildrenViewController *)childrenViewController;

- (BOOL)childrenViewControllerShouldShowSpecialRootFeatureButton:(MCChildrenViewController *)childrenViewController;

- (BOOL)childrenViewControllerShouldSelectSpecialRootFeatureButton:(MCChildrenViewController *)childrenViewController;

- (void)childrenViewControllerDidSelectSpecialRootFeatureButton:(MCChildrenViewController *)childrenViewController;

@end
