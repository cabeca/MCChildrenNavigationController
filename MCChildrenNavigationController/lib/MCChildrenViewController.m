//
//  MCChildrenViewController.m
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import "MCChildrenViewController.h"
#import "MCChildrenCollection.h"

@interface MCChildrenViewController ()
@property (nonatomic, strong) MCArrayDataSource *dataSource;
@end

@implementation MCChildrenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNode:(id<MCChildrenCollection>)aNode
{
    return [self initWithNode:aNode selectedChild:MCChildrenSelectedNone];
}

- (id)initWithNode:(id<MCChildrenCollection>)aNode selectedChild:(MCChildrenSelected)aSelectedChild
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _node = aNode;
        _selectedChild = aSelectedChild;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupTableHeaderView];
    [self.view addSubview:self.tableView];

    [self setupNavigationItems];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    void (^configureCell)(UITableViewCell*, id<MCChildrenCollection>, NSIndexPath *indexPath) = ^(UITableViewCell* cell, id<MCChildrenCollection> item, NSIndexPath *indexPath) {
        cell.textLabel.text = item.label;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (self.selectedChild == [indexPath row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if (item.children) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    };
    
    self.dataSource = [[MCArrayDataSource alloc] initWithItems:self.node.children
                                                cellIdentifier:@"cellIdentifier"
                                            configureCellBlock:configureCell];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
}

- (void)setupTableHeaderView
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All"]];

    if (self.selectedChild == MCChildrenSelectedAll) {
        segmentedControl.selectedSegmentIndex = 0;
    } else {
        segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    }

    [segmentedControl addTarget:self
                         action:@selector(didSelectAll)
               forControlEvents:UIControlEventValueChanged];

    self.tableView.tableHeaderView = segmentedControl;
}

- (void)setupNavigationItems
{
    self.navigationItem.title = self.node.label;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(cancel)];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate childrenViewController:self didSelectChild:[indexPath row]];
}

- (void)didSelectAll
{
    [self.delegate childrenViewController:self didSelectChild:MCChildrenSelectedAll];
}

@end
