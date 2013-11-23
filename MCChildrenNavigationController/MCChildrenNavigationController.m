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

- (void)viewDidLoad
{
    [super viewDidLoad];

    MCChildrenViewController *childrenViewController = [[MCChildrenViewController alloc] init];
    childrenViewController.node = self.rootNode;
    
    self.viewControllers = @[childrenViewController];
}

@end
