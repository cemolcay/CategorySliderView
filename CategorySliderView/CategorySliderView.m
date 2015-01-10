//
//  CategorySliderView.m
//  CategorySliderView
//
//  Created by Cem Olcay on 04/07/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "CategorySliderView.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface CategorySliderView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *categoryViews;
@end

@implementation CategorySliderView

- (instancetype)initWithFrame:(CGRect)frame andSliderDirection:(SliderDirection)direction {
    if ((self = [self initWithFrame:frame andCategoryViews:nil sliderDirection:direction categorySelectionBlock:nil])) {
    
    }
    return self;
}


- (instancetype)initWithSliderHeight:(CGFloat)height andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block {
    if ((self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, height) andCategoryViews:categoryViews sliderDirection:SliderDirectionHorizontal categorySelectionBlock:block])) {
        
    }
    return self;
}

- (instancetype)initWithSliderWidth:(CGFloat)width andCategoryViews:(NSArray *)categoryViews categorySelectionBlock:(categorySelected)block {
    if ((self = [self initWithFrame:CGRectMake(0, 0, width, ScreenHeight) andCategoryViews:categoryViews sliderDirection:SliderDirectionVertical categorySelectionBlock:block])) {
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame andCategoryViews:(NSArray *)categoryViews sliderDirection:(SliderDirection)direction categorySelectionBlock:(categorySelected)block {
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.scrollView setDelegate:self];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        
        self.sliderDirection = direction;
        self.categorySelectedBlock = block;
        self.categoryViews = [[NSMutableArray alloc] init];
        self.categoryViewPadding = 20;
        self.shouldAutoScrollSlider = YES;
        self.shouldAutoSelectScrolledCategory = YES;
        
        for (UIView *v in categoryViews) {
            [self addCategoryView:v];
        }
    }
    return self;
}


#pragma mark - Slider

- (void)addCategoryView:(UIView *)view {
    
    if (self.sliderDirection == SliderDirectionHorizontal) {
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
    else if (self.sliderDirection == SliderDirectionVertical) {
        float h = 0;
        if (self.categoryViews.count > 0) {
            UIView *lastView = [self.categoryViews lastObject];
            h = lastView.frame.origin.y+lastView.frame.size.height+self.categoryViewPadding;
        }
        else {
            h = [self height]/2 - view.frame.size.height/2;
        }
        
        [self.scrollView addSubview:view];
        [view setFrame:CGRectMake(0, h, view.frame.size.width, view.frame.size.height)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryViewTapped:)];
        [tap setNumberOfTapsRequired:1];
        [view setUserInteractionEnabled:YES];
        [view addGestureRecognizer:tap];
        [view setTag:self.categoryViews.count];
        
        h += [self height]/2 + view.frame.size.height/2;
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, h)];
        [self.categoryViews addObject:view];
    }}

- (void)setBackgroundImage:(UIImage *)image {
    _backgroundImage = image;
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:100];
    if (imageView) {
        [imageView setImage:image];
    }
    else {
        imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [imageView setImage:image];
        [imageView setTag:100];
        [self addSubview:imageView];
        
        [self bringSubviewToFront:self.scrollView];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self.scrollView setBackgroundColor:backgroundColor];
}

- (void)categoryViewTapped:(UITapGestureRecognizer *)tap {
    [self slideItemAtIndex:tap.view.tag animated:YES];
    
    if (self.categorySelectedBlock && !self.shouldAutoSelectScrolledCategory)
        self.categorySelectedBlock ([self.categoryViews objectAtIndex:tap.view.tag], tap.view.tag);
}


#pragma mark - UIView

- (void)setX:(CGFloat)x {
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setY:(CGFloat)y {
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)moveX:(CGFloat)x duration:(NSTimeInterval)duration complation:(void(^)(void))complation {
    [UIView animateWithDuration:duration animations:^{
        [self setX:x];
    } completion:^(BOOL finished) {
        if (complation)
            complation();
    }];
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

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)contentWidth {
    return self.scrollView.contentSize.width;
}

- (CGFloat)contentHeight {
    return self.scrollView.contentSize.height;
}


#pragma mark - Sliding

- (void)slideItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    UIView *v = [self.categoryViews objectAtIndex:index];
    
    if (self.sliderDirection == SliderDirectionHorizontal)
        [self.scrollView setContentOffset:CGPointMake(v.center.x - [self width]/2, self.scrollView.contentOffset.y) animated:animated];
    else if (self.sliderDirection == SliderDirectionVertical)
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, v.center.y - [self height]/2) animated:animated];
    
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
    
    if (self.sliderDirection == SliderDirectionHorizontal) {
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
    else if (self.sliderDirection == SliderDirectionVertical) {
        if (velocity.x == 0)
        {
            float y = scrollView.contentOffset.y + [self height]/2;
            float distance = 1000;
            int closest = -1;
            
            for (int i = 0; i < self.categoryViews.count; i++)
            {
                UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
                
                if (abs(y - view.center.y) < distance)
                {
                    distance = abs(y-view.center.y);
                    closest = i;
                }
            }
            
            [self slideItemAtIndex:closest animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.shouldAutoScrollSlider)
        return;
   
    if (self.sliderDirection == SliderDirectionHorizontal) {
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
    else if (self.sliderDirection == SliderDirectionVertical) {
        float y = scrollView.contentOffset.y + [self height]/2;
        float distance = 1000;
        int closest = -1;
        
        for (int i = 0; i < self.categoryViews.count; i++)
        {
            UIView *view = (UIView*)[self.categoryViews objectAtIndex:i];
            
            if (abs(y - view.center.y) < distance)
            {
                distance = abs(y-view.center.y);
                closest = i;
            }
        }
        
        [self slideItemAtIndex:closest animated:YES];
    }
}



@end
