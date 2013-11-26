//
//  MCMainViewController.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTreeNode.h"
#import "MCChildrenNavigationController.h"

@interface MCMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *showChildrenButton;
@property (nonatomic, assign) NSInteger numberOfLevels;
@property (nonatomic, assign) NSInteger maximumNodesPerLevel;
@property (nonatomic, strong) MCTreeNode *rootNode;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) MCChildrenNavigationController *childrenNC;

- (IBAction)showChildrenButtonTapped:(id)sender;

@end
