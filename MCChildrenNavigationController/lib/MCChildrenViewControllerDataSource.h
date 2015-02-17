//
//  MCChildrenViewControllerDataSource.h
//  Copyright (c) 2015 Miguel Cabeça. All rights reserved.
//

@class MCChildrenViewController;

@protocol MCChildrenViewControllerDataSource <NSObject>

- (NSString *)titleForSpecialRootFeatureInChildrenViewController:(MCChildrenViewController *)childrenViewController;

@end
