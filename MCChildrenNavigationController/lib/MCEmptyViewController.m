//
//  MCEmptyViewController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 14/12/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCEmptyViewController.h"

@interface MCEmptyViewController ()

@end

@implementation MCEmptyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationItems];
    [self setupView];
}

- (void)setupNavigationItems
{
    self.navigationItem.title = @"Empty";
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(cancel)];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
