CategorySliderView
==================

Horizontal or vertical slider view for choosing categories. Add any UIView type as category item view. Fully customisable

Demo
====
![alt tag](https://raw.githubusercontent.com/cemolcay/CategorySliderView/master/demo.gif)

Usage
-----
Copy CategorySliderView.h/m files into your project.

    UILabel *category1 = ......
    UILabel *category2 = ......
    UILabel *category3 = ......
    ...
    
    CategorySliderView *sliderView = [[CategorySliderView alloc] initWithSliderHeight:60 andCategoryViews:@[category1, category2, category3] categorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
        UILabel *selectedView = (UILabel *)categoryView;
        NSLog(@"\"%@\" cateogry selected at index %d", selectedView.text, categoryIndex);
    }];
    [self.view addSubview:sliderView];


you can add as many items as you want

    UIView *newCategoryView = .....
    [sliderView addCategoryView:newCategoryView];
    


Optional Properties
-------------------

    shouldAutoScrollSlider: scrolls to closest category item after dragging ends
    shouldAutoSelectScrolledCategory: selects the closest category item after dragging ends
    categoryViewPadding: padding between category item views
    backgroundImage: background image for slider
    
