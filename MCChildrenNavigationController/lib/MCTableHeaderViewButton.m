//
//  MCTableHeaderViewButton.m
//  MCChildrenNavigationController
//
//  Created by Charly Liu Chou on 1/30/14.
//  Copyright (c) 2014 Miguel Cabeça. All rights reserved.
//

#import "MCTableHeaderViewButton.h"

@interface MCTableHeaderViewButton (Constraints)
@property (nonatomic, strong) NSLayoutConstraint *superToImageConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageToTitleConstraint;
@end

@implementation MCTableHeaderViewButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _accessoryParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_accessoryParentView];
        
        [self createConstraints];

    }
    return self;
}

- (void)createConstraints
{
    NSArray *HorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[image]-10-[title]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"image":_imageView,
                                                                                       @"title":_titleLabel,
                                                                                       @"accessoryView":_accessoryParentView}];
    _superToImageConstraint = HorizontalConstraints[0];
    _imageToTitleConstraint = HorizontalConstraints[1];
    NSArray *imageVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[image]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"image":_imageView}];
    NSArray *titleVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[title]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"title":_titleLabel}];
    NSArray *accessoryHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[accessoryView]-43-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"accessoryView":_accessoryParentView}];
    NSArray *accessoryVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[accessoryView]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"accessoryView":_accessoryParentView}];
    
    
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _accessoryParentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:HorizontalConstraints];
    [self addConstraints:imageVerticalConstraints];
    [self addConstraints:titleVerticalConstraints];
    [self addConstraints:accessoryHorizontalConstraints];
    [self addConstraints:accessoryVerticalConstraints];
    
}

- (void)updateConstraints
{
    CGFloat titleMaxsize = 258.0;
    
    if (self.imageView.image){
        _superToImageConstraint.constant = 11;
        _imageToTitleConstraint.constant = 14;
        
        titleMaxsize = titleMaxsize - 36;
    }
    
    [self.titleLabel sizeToFit];
    if (self.titleLabel.bounds.size.width >= titleMaxsize){
        NSArray *largeTitleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-(43)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"title":_titleLabel}];
        [self addConstraints:largeTitleConstraints];
    }
    
    [super updateConstraints];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    
    [self setNeedsUpdateConstraints];
}


- (void)setAccessoryView:(UIView *)accessoryView
{
    for (UIView *view in [self.accessoryParentView subviews]){
        [view removeFromSuperview];
    }
    
    if (!accessoryView){
        return;
    }
    
    [self.accessoryParentView addSubview:accessoryView];
    
    [self setNeedsUpdateConstraints];
}

@end
