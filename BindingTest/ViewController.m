//
//  ViewController.m
//  BindingTest
//
//  Created by David House on 2/10/13.
//  Copyright (c) 2013 Random Accident. All rights reserved.
//

#import "ViewController.h"
#import "UIView+RAPropertyBinding.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a model object
    NSDictionary *bookInfo = @{ @"title": @"The Hobbit", @"author": @"J. R. R. Tolkien",
                                @"pubDate": @"21 September 1937", @"rating": [NSNumber numberWithInt:5] };
    [self.view bindWithObject:bookInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
