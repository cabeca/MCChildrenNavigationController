//
//  MCChildrenCollection.h
//  MCChildrenNavigationController
//
//  Created by Miguel Cabeça on 23/11/13.
//  Copyright (c) 2013 Miguel Cabeça. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCChildrenCollection <NSObject>
- (NSString *)label;
- (NSArray *)children;
@optional
- (UIImage *)image;
@end
