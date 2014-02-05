//
//  MCTableHeaderViewButton.m
//  MCChildrenNavigationController
//
//  Created by Charly Liu Chou on 1/30/14.
//  Copyright (c) 2014 Miguel Cabeça. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTableHeaderViewButton : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *accessoryParentView;

@property (nonatomic, strong, readonly) NSLayoutConstraint *superToImageConstraint;
@property (nonatomic, strong, readonly) NSLayoutConstraint *imageToTitleConstraint;


- (void)setImage:(UIImage *)image;
- (void)setAccessoryView:(UIView *)accessoryView;

@end
