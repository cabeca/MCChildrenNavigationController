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
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createCancelButtonWithTitle:(NSString *)cancelTitle
{
    UIBarButtonItem *cancelButton = nil;
    
    if (cancelTitle) {
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(cancel)];
    }
    else {
        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                     target:self
                                                                     action:@selector(cancel)];
    }
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

#pragma mark - Public

- (void)changeCancelTitle:(NSString *)cancelTitle
{
    [self createCancelButtonWithTitle:cancelTitle];
}

@end
