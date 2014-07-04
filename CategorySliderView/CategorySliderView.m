//
//  CategorySliderView.m
//  CategorySliderView
//
//  Created by Cem Olcay on 04/07/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "CategorySliderView.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width

@interface CategorySliderView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *categoryViews;
@end

@implementation CategorySliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [self initWithFrame:frame andCategoryViews:nil categorySelectionBlock:nil])) {
    
    }
    return self;
}

- (instancetype)initWithSliderHeight:(CGFloat)height andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block {
    if ((self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, height) andCategoryViews:categoryViews categorySelectionBlock:block])) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block {
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [self.scrollView setDelegate:self];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        
        self.categorySelectedBlock = block;
        self.categoryViews = [[NSMutableArray alloc] init];
        self.categoryViewPadding = 20;
        self.shouldAutoScrollSlider = YES;
        self.shouldAutoSelectScrolledCategory = YES;
        
        for (UIView *v in categoryViews) {
            [self addCategotyView:v];
        }
    }
    return self;
}


#pragma mark - Slider

- (void)addCategotyView:(UIView *)view {
    float w = 0;
    if (self.categoryViews.count > 0) {
        UIView *lastView = [self.categoryViews lastObject];
        w = lastView.frame.origin.x+lastView.frame.size.width+self.categoryViewPadding;
    }
    else {
        w = [self width]/2 - view.frame.size.width/2;
    }
    
    [self.scrollView addSubview:view];
    [view setFrame:CGRectMake(w, 0, view.frame.size.width, view.frame.size.height)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTapped:)];
    [tap setNumberOfTapsRequired:1];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:tap];
    [view setTag:self.categoryViews.count];
    
    w += [self width]/2 + view.frame.size.width/2;
    [self.scrollView setContentSize:CGSizeMake(w, self.scrollView.contentSize.height)];
    [self.categoryViews addObject:view];
}

- (void)setBackgroundImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    [imageView setImage:image];
    [self addSubview:imageView];
    [self bringSubviewToFront:self.scrollView];
}

- (void)categoryViewTapped:(UITapGestureRecognizer *)tap {
    [self slideItemAtIndex:tap.view.tag animated:YES];
    
    if (self.categorySelectedBlock && !self.shouldAutoSelectScrolledCategory)
        self.categorySelectedBlock ([self.categoryViews objectAtIndex:tap.view.tag], tap.view.tag);
}

#pragma mark - UIView

- (void)setY:(CGFloat)y {
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)moveY:(CGFloat)y duration:(NSTimeInterval)duration complation:(void(^)(void))complation {
    [UIView animateWithDuration:duration animations:^{
        [self setY:y];
    } completion:^(BOOL finished) {
        if (complation)
            complation();
    }];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)contentWidth {
    return self.scrollView.contentSize.width;
}


#pragma mark - Sliding

- (void)slideItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    UIView *v = [self.categoryViews objectAtIndex:index];
    [self.scrollView setContentOffset:CGPointMake(v.center.x - [self width]/2, self.scrollView.contentOffset.y) animated:animated];
    
    if (self.shouldAutoSelectScrolledCategory)
        if (self.categorySelectedBlock)
            self.categorySelectedBlock (v, index);
}

- (void)stopScroll {
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:offset animated:NO];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!self.shouldAutoScrollSlider)
        return;
    
    if (velocity.x == 0)
    {
        float x = scrollView.contentOffset.x + [self width]/2;
        float distance = 1000;
        int closest = -1;
        
        for (int i = 0; i < self.categoryViews.count; i++)
        {
            UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
            
            if (abs(x - view.center.x) < distance)
            {
                distance = abs(x-view.center.x);
                closest = i;
            }
        }
        
        [self slideItemAtIndex:closest animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.shouldAutoScrollSlider)
        return;
    
    float x = scrollView.contentOffset.x + [self width]/2;
    float distance = 1000;
    int closest = -1;
    
    for (int i = 0; i < self.categoryViews.count; i++)
    {
        UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
        
        if (abs(x - view.center.x) < distance)
        {
            distance = abs(x-view.center.x);
            closest = i;
        }
    }
    
    [self slideItemAtIndex:closest animated:YES];
}


@end
