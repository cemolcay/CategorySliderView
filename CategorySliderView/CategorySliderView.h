//
//  CategorySliderView.h
//  CategorySliderView
//
//  Created by Cem Olcay on 04/07/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^categorySelected)(UIView *categoryView, NSInteger categoryIndex);

@interface CategorySliderView : UIView <UIScrollViewDelegate>

@property (copy) categorySelected categorySelectedBlock;
@property (assign) NSInteger categoryViewPadding; //default 20
@property (assign) BOOL shouldAutoScrollSlider; // default YES auto scrolls closest category after scroll drag ends
@property (assign) BOOL shouldAutoSelectScrolledCategory; // default YES auto selects the slided category

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block;
- (instancetype)initWithSliderHeight:(CGFloat)height andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block;

- (void)addCategotyView:(UIView *)view;
- (void)setBackgroundImage:(UIImage *)image;

- (void)setY:(CGFloat)y;
- (void)moveY:(CGFloat)y duration:(NSTimeInterval)duration complation:(void(^)(void))complation;

@end
