//
//  MCChildrenViewController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCChildrenViewController.h"
#import "MCArrayDataSource.h"
#import "MCTableHeaderViewButton.h"

@interface MCChildrenViewController ()
@property (nonatomic, strong) MCArrayDataSource *dataSource;
@end

@implementation MCChildrenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _configureTableViewBlock = ^void(UITableView *tableView, id<MCChildrenCollection> node){};
        _configureTableViewCellBlock = ^void(UITableViewCell *cell){};
        _configureAllNodeSelectionButtonBlock = ^void(MCTableHeaderViewButton *button, BOOL isSelected){};
        _configureSpecialRootFeatureButtonBlock = ^void(MCTableHeaderViewButton *button, BOOL isSelected){};
    }
    return self;
}

- (id)initWithNode:(id<MCChildrenCollection>)aNode level:(NSInteger)aLevel index:(NSInteger)anIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _node = aNode;
        _level = aLevel;
        _index = anIndex;
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupTableHeaderView];
    [self.view addSubview:self.tableView];
    [self setupNavigationItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self deselectRowInTableViewAnimated:animated];
}

#pragma mark - Public

- (void)changeCancelTitle:(NSString *)cancelTitle
{
    [self createCancelButtonWithTitle:cancelTitle];
}

- (void)selectRowInTableViewAnimated:(BOOL)animated
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)deselectRowInTableViewAnimated:(BOOL)animated
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:animated];
    }
}

#pragma mark - Private
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    __weak __typeof(self) weakSelf = self;
    TableViewCellConfigureBlock configureCell = ^(UITableViewCell* cell, id<MCChildrenCollection> item, NSIndexPath *indexPath) {
        cell.textLabel.text = item.label;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([weakSelf.delegate childrenViewController:weakSelf shouldSelectChildIndex:[indexPath row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([weakSelf.delegate childrenViewController:weakSelf canNavigateToChildIndex:[indexPath row]]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if ([item respondsToSelector:@selector(image)]) {
            cell.imageView.image = item.image;
        }
        
        weakSelf.configureTableViewCellBlock(cell);
    };
    
    self.dataSource = [[MCArrayDataSource alloc] initWithItems:self.node.children
                                                cellIdentifier:@"cellIdentifier"
                                            configureCellBlock:configureCell];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;

    self.configureTableViewBlock(self.tableView, self.node);
}

- (void)setupTableHeaderView
{
    UIView *tableHeaderView = [[UIView alloc] init];
    self.tableView.tableHeaderView = tableHeaderView;
    if ([self.delegate childrenViewControllerShouldShowSpecialRootFeatureButton:self]) {
        [self showSpecialRootFeatureButton];
    }
    
    if ([self.delegate childrenViewControllerShouldShowAllNodeSelectionButton:self]) {
        [self showAllNodeSelectionButton];
    }
    [self setupConstraintsForTableHeaderView:tableHeaderView];
    [self adjustFrameForTableHeaderView:tableHeaderView];
}

- (void)showAllNodeSelectionButton
{
    MCTableHeaderViewButton *button = [[MCTableHeaderViewButton alloc] init];
    if ([self.node respondsToSelector:@selector(selectionAllLabel)] && self.node.selectionAllLabel) {
        button.titleLabel.text = self.node.selectionAllLabel;
    } else {
        return;
    }
    if ([self.node respondsToSelector:@selector(image)]) {
        [button setImage:self.node.image];
    }
    [self setupConstraintsForTableHeaderViewButton:button];
    self.configureAllNodeSelectionButtonBlock(button, [self.delegate childrenViewControllerShouldSelectAllNodeSelectionButton:self]);
    [button addTarget:self action:@selector(didSelectAll) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showSpecialRootFeatureButton
{
    MCTableHeaderViewButton *button = [[MCTableHeaderViewButton alloc] init];
    button.titleLabel.text = @"Special Root Feature";
    [self setupConstraintsForTableHeaderViewButton:button];
    self.configureSpecialRootFeatureButtonBlock(button, [self.delegate childrenViewControllerShouldSelectSpecialRootFeatureButton:self]);
    [button addTarget:self action:@selector(didSelectSpecialRootFeature) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraintsForTableHeaderView:(UIView *)tableHeaderView
{
    tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:tableHeaderView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.tableView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0]];

    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:tableHeaderView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.tableView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0
                                                                constant:0]];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:tableHeaderView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.tableView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0
                                                                constant:0]];
    
    UIView *lastView = [[tableHeaderView subviews] lastObject];
    if (lastView) {
        [tableHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:tableHeaderView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:lastView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0]];
    }
}

- (void)setupConstraintsForTableHeaderViewButton:(MCTableHeaderViewButton *)button
{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *lastView = [[self.tableView.tableHeaderView subviews] lastObject];
    [self.tableView.tableHeaderView addSubview:button];
    if (lastView) {
        [self.tableView.tableHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:lastView
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:button
                                                                                   attribute:NSLayoutAttributeTop
                                                                                  multiplier:1.0
                                                                                    constant:0]];
    }
    else {
        [self.tableView.tableHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView.tableHeaderView
                                                                                   attribute:NSLayoutAttributeTop
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:button
                                                                                   attribute:NSLayoutAttributeTop
                                                                                  multiplier:1.0
                                                                                    constant:0]];
    }
    [self.tableView.tableHeaderView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[button]-(0)-|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:@{@"button":button}]];
}

- (void)adjustFrameForTableHeaderView:(UIView *)tableHeaderView
{
    CGFloat height = [tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect headerFrame = tableHeaderView.frame;
    headerFrame.size.height = height;
    tableHeaderView.frame = headerFrame;
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)setupNavigationItems
{
    self.navigationItem.title = self.node.label;
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

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectAll
{
    [self.delegate childrenViewControllerDidSelectAll:self];
}

- (void)didSelectSpecialRootFeature
{
    [self.delegate childrenViewControllerDidSelectSpecialRootFeatureButton:self];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate childrenViewController:self didSelectChildIndex:[indexPath row]];
}

@end
