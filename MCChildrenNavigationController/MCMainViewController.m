//
//  MCMainViewController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCMainViewController.h"
#import "MCChildrenNavigationController.h"

@interface MCMainViewController ()

@end

@implementation MCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _numberOfLevels = 5;
        _maximumNodesPerLevel = 10;
        _rootNode = [self generateRootNode];
        _selectedIndexPath = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"rootNode: %@", self.rootNode);
}

#pragma - private
- (MCTreeNode *)generateRootNode
{
    return [[MCTreeNode alloc] initWithLabel:@"Root Note"
                                    children:[self generateChildrenForLevel:0]];
}

- (NSArray *)generateChildrenForLevel:(NSInteger)level
{
    NSInteger levelNumberOfNodes;
    NSInteger currentNodeNumber;
    
    if (level == self.numberOfLevels) {
        return nil;
    }
    
    NSMutableArray *children = [[NSMutableArray alloc] init];

    levelNumberOfNodes = arc4random_uniform(self.maximumNodesPerLevel) + 1;
    for (currentNodeNumber = 0; currentNodeNumber < levelNumberOfNodes; currentNodeNumber++) {
        MCTreeNode *treeNode = [self generateNodeWithNumber:currentNodeNumber forLevel:level];
        [children addObject:treeNode];
    }
    
    return children;
}

- (MCTreeNode *)generateNodeWithNumber:(NSInteger)number forLevel:(NSInteger)level
{
    NSArray *children = [self generateChildrenForLevel:level+1];
    MCTreeNode *treeNode = [[MCTreeNode alloc] initWithLabel:[NSString stringWithFormat:@"Level %d node number %d", level, number]
                                                    children:children];
    return treeNode;
}

- (IBAction)showChildrenButtonTapped:(id)sender
{
    NSLog(@"Show Children Button Tapped");

    MCChildrenNavigationController *childrenNC = [[MCChildrenNavigationController alloc] initWithRootNode:(id<MCChildrenCollection>)self.rootNode selectedNodeIndexPath:self.selectedIndexPath selectedNodeBlock:^(id<MCChildrenCollection> node, NSIndexPath *indexPath) {
            NSLog(@"node = %@, indexPath = %@", node, indexPath);
            self.selectedIndexPath = indexPath;
        }];
    [self presentViewController:childrenNC animated:YES completion:nil];

}
@end
