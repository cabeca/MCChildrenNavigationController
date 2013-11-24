//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//

#import <Foundation/Foundation.h>


typedef void (^TableViewCellConfigureBlock)(id cell, id item, NSIndexPath *indexPath);


@interface MCArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end