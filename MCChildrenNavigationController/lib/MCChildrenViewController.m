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
        _configureTableHeaderViewBlock = ^void(MCTableHeaderViewButton *button, BOOL isSelected){};
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
    if ([self.delegate childrenViewControllerShouldShowAll:self]) {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        MCTableHeaderViewButton *headerButton = [[MCTableHeaderViewButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

        if ([self.node respondsToSelector:@selector(selectionAllLabel)] && self.node.selectionAllLabel) {
            headerButton.titleLabel.text = self.node.selectionAllLabel;
        } else {
            return;
        }
        
        if ([self.node respondsToSelector:@selector(image)]) {
            [headerButton setImage:self.node.image];
        }
        
        [tableHeaderView addSubview:headerButton];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[button]-(0)-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"button":headerButton}];
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[button]-(0)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"button":headerButton}];
        headerButton.translatesAutoresizingMaskIntoConstraints = NO;
        [tableHeaderView addConstraints:verticalConstraints];
        [tableHeaderView addConstraints:horizontalConstraints];
        
        self.configureTableHeaderViewBlock(headerButton,[self.delegate childrenViewControllerShouldSelectAll:self]);
        
        [headerButton addTarget:self
                         action:@selector(didSelectAll)
        forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.tableHeaderView = tableHeaderView;
    }
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate childrenViewController:self didSelectChildIndex:[indexPath row]];
}

@end
