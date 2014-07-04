//
//  TestViewController.m
//  CategorySliderView
//
//  Created by Cem Olcay on 04/07/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "TestViewController.h"
#import "CategorySliderView.h"

#define CategorySliderHeight 60

@interface TestViewController ()
@property CategorySliderView *sliderView;
@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sliderView = [[CategorySliderView alloc] initWithSliderHeight:CategorySliderHeight andCategoryViews:@[[self labelWithText:@"First Category"], [self labelWithText:@"Second Category"], [self labelWithText:@"Yet another category"], [self labelWithText:@"and antoher category"]] categorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
        UILabel *selectedView = (UILabel *)categoryView;
        NSLog(@"\"%@\" cateogry selected at index %d", selectedView.text, categoryIndex);
    }];
    
    [self.sliderView setY:-CategorySliderHeight];
    [self.sliderView moveY:20 duration:0.5 complation:nil];
    [self.view addSubview:self.sliderView];
    
    UIButton *addNewCat = [UIButton buttonWithType:UIButtonTypeCustom];
    [addNewCat setFrame:CGRectMake(10, 100, 300, CategorySliderHeight)];
    [addNewCat setTitle:@"Add New Category" forState:UIControlStateNormal];
    [addNewCat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addNewCat addTarget:self action:@selector(addNewCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewCat];
}

- (void)addNewCategory:(id)sender {
    [self.sliderView addCategotyView:[self labelWithText:@"New Category"]];
}

- (UILabel *)labelWithText:(NSString *)text {
    float w = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, CategorySliderHeight)];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [lbl setText:text];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    return lbl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
