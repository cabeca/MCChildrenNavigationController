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
    [self deselectRowInTableViewAnimated:animated];
}

#pragma mark - Public

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
    tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:tableHeaderView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.tableView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0
                                                                constant:0]];
    self.tableView.tableHeaderView = tableHeaderView;
    
    if ([self.delegate childrenViewControllerShouldShowAllNodeSelectionButton:self]) {
        MCTableHeaderViewButton *allNodeSelectionButton = [[MCTableHeaderViewButton alloc] init];
        allNodeSelectionButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        if ([self.node respondsToSelector:@selector(selectionAllLabel)] && self.node.selectionAllLabel) {
            allNodeSelectionButton.titleLabel.text = self.node.selectionAllLabel;
        } else {
            return;
        }
        
        if ([self.node respondsToSelector:@selector(image)]) {
            [allNodeSelectionButton setImage:self.node.image];
        }
        
        [tableHeaderView addSubview:allNodeSelectionButton];
        
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[button]-(0)-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"button":allNodeSelectionButton}];
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[button]-(0)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"button":allNodeSelectionButton}];
        allNodeSelectionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [tableHeaderView addConstraints:verticalConstraints];
        [tableHeaderView addConstraints:horizontalConstraints];
        
        self.configureAllNodeSelectionButtonBlock(allNodeSelectionButton, [self.delegate childrenViewControllerShouldSelectAll:self]);
        
        [allNodeSelectionButton addTarget:self
                                   action:@selector(didSelectAll)
                         forControlEvents:UIControlEventTouchUpInside];
    }
    
    [tableHeaderView layoutIfNeeded];
    CGFloat height = [tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect headerFrame = tableHeaderView.frame;
    headerFrame.size.height = height;
    tableHeaderView.frame = headerFrame;
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)setupNavigationItems
{
    self.navigationItem.title = self.node.label;
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(cancel)];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectAll
{
    [self.delegate childrenViewControllerDidSelectAll:self];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate childrenViewController:self didSelectChildIndex:[indexPath row]];
}

@end
