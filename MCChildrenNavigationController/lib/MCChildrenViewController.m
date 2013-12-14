//
//  MCChildrenViewController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCChildrenViewController.h"
#import "MCArrayDataSource.h"

@interface MCChildrenViewController ()
@property (nonatomic, strong) MCArrayDataSource *dataSource;
@end

@implementation MCChildrenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _configureTableViewBlock = ^void(UITableView *tableView){};
        _configureTableViewCellBlock = ^void(UITableViewCell *cell){};
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
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:animated];
    }
}

#pragma mark - private
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    TableViewCellConfigureBlock configureCell = ^(UITableViewCell* cell, id<MCChildrenCollection> item, NSIndexPath *indexPath) {
        cell.textLabel.text = item.label;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([self.delegate childrenViewController:self shouldSelectChildIndex:[indexPath row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([self.delegate childrenViewController:self canNavigateToChildIndex:[indexPath row]]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        self.configureTableViewCellBlock(cell);
    };
    
    self.dataSource = [[MCArrayDataSource alloc] initWithItems:self.node.children
                                                cellIdentifier:@"cellIdentifier"
                                            configureCellBlock:configureCell];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;

    self.configureTableViewBlock(self.tableView);
}

- (void)setupTableHeaderView
{
    if ([self.delegate childrenViewControllerShouldShowAll:self]) {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All"]];
        
        [tableHeaderView addSubview:segmentedControl];
        
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[segmentedControl]-(8)-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"segmentedControl":segmentedControl}];
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(32)-[segmentedControl]-(32)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"segmentedControl":segmentedControl}];
        segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
//        tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        [tableHeaderView addConstraints:verticalConstraints];
        [tableHeaderView addConstraints:horizontalConstraints];

        
        if ([self.delegate childrenViewControllerShouldSelectAll:self]) {
            segmentedControl.selectedSegmentIndex = 0;
        } else {
            segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        
        [segmentedControl addTarget:self
                             action:@selector(didSelectAll)
                   forControlEvents:UIControlEventValueChanged];
        
        self.tableView.tableHeaderView = tableHeaderView;
    }
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
