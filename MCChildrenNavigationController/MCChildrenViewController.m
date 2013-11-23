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
    
    void (^configureCell)(UITableViewCell*, id<MCChildrenCollection>) = ^(UITableViewCell* cell, id<MCChildrenCollection> item) {
        cell.textLabel.text = item.label;
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
    segmentedControl.momentary = YES;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger row = [indexPath row];
    id<MCChildrenCollection> child = self.node.children[row];
    if (child.children) {
        [self pushChildrenViewControllerForNode:child];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"Selected node %@", child);
    }
}

- (void)pushChildrenViewControllerForNode:(id<MCChildrenCollection>)node
{
    MCChildrenViewController *childrenViewController = [[MCChildrenViewController alloc] init];
    childrenViewController.node = node;
    [self.navigationController pushViewController:childrenViewController animated:YES];
}

- (void)didSelectAll
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Selected node %@", self.node);
}

@end
