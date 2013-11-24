//
//  MCChildrenViewControllerDelegate.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 24/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCChildrenViewController;
typedef NS_ENUM(NSInteger, MCChildrenSelected);

@protocol MCChildrenViewControllerDelegate <NSObject>
- (void)childrenViewController:(MCChildrenViewController *)childrenViewController didSelectChild:(MCChildrenSelected)selectedChild;
@end
