//
//  ExampleUdonNoodleTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Ali on 14/04/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleUdonNoodleTableViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// views
#import "AFAdSDKUdonNoodleControl.h"


@interface ExampleUdonNoodleTableViewController () <AFAdSDKUdonNoodleControlDelegate> {
    
    NSMutableArray *_arraySource;
    AFAdSDKUdonNoodleControl *_refreshControl;
    
}

@end

@implementation ExampleUdonNoodleTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    if ((self = [super initWithStyle:style]) != nil) {
        
        //
        self.title = @"Udon Noodle";
        self.tableView.rowHeight = 100.0;
        
        //
        _arraySource = [NSMutableArray array];
        
        // fill array with dummy inserts for test purpose
        [_arraySource addObject:@{@"title": @"Lorem ipsum dolor sit amet, consectetur adipiscing elit.", @"content": @"Sed lacinia dui at dui euismod, posuere ultricies massa mollis. Donec id orci quis dui lobortis scelerisque."}];
        [_arraySource addObject:@{@"title": @"Aliquam sollicitudin turpis quis enim iaculis eleifend non a dolor.", @"content": @"Cras accumsan erat ac nunc suscipit, id venenatis libero rhoncus. Aliquam egestas tortor sed purus porttitor laoreet."}];
        [_arraySource addObject:@{@"title": @"Praesent tristique dolor vehicula mi porttitor dictum quis id sem.", @"content": @"Nam vitae sem id sem ullamcorper pretium. Cras consectetur lectus sed diam egestas sodales."}];
        [_arraySource addObject:@{@"title": @"Nullam bibendum ligula ac purus imperdiet sodales.", @"content": @"Morbi eu justo a lorem blandit vulputate vitae eget tortor. Fusce iaculis justo a orci interdum, et vulputate sem gravida."}];
        [_arraySource addObject:@{@"title": @"Phasellus rhoncus nisi id hendrerit tempus.", @"content": @"Nulla ac nibh eu ante tempus ornare et ut massa. Cras eleifend odio ut ullamcorper cursus."}];
        [_arraySource addObject:@{@"title": @"Suspendisse eleifend quam non scelerisque fermentum.", @"content": @"Vestibulum dictum nibh ut ipsum varius malesuada. Morbi volutpat magna ut nibh condimentum, tincidunt pulvinar magna vulputate."}];

    }
    return self;
    
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshControl = [[AFAdSDKUdonNoodleControl alloc] initWithScrollView:self.tableView];
    _refreshControl.delegate = self;
    [_refreshControl addTarget:self action:@selector(doRefresh:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Udon Noodle adjustments.
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        CGFloat topOffset = self.topLayoutGuide.length;
        _refreshControl.defaultTopContentOffset = topOffset;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arraySource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    NSString *celluid;
    UITableViewCell *cell;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [_arraySource count]) {
        sourceObject = _arraySource[indexPath.row];
    }
    
    // determine cell id
    celluid = @"classic";
    
    // get cell
    cell = [tableView dequeueReusableCellWithIdentifier:celluid];
    if (!cell) {
        
        // create cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celluid];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [cell.textLabel setNumberOfLines:1];
        [cell.detailTextLabel setNumberOfLines:3];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        
        // no selection
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    [cell.textLabel setText:sourceObject[@"title"]];
    [cell.detailTextLabel setText:sourceObject[@"content"]];
    
    return cell;
    
}

#pragma mark - Refreshing

- (void)doRefresh:(AFAdSDKUdonNoodleControl *)refreshControl {
    [_refreshControl beginRefreshing];
    NSLog(@"Refreshing...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_refreshControl endRefreshing];
        NSLog(@"Refreshed!");
    });
}

#pragma mark - AFAdSDKUdonNoodleControlDelegate

- (void)udonNoodleControl:(AFAdSDKUdonNoodleControl *)udonNoodleControl customizeSashimiView:(AFAdSDKSashimiMinimalView *)sashimiView {

    // Uncomment the following lines to see the effect of customization.
    /*
    // Changing the background color to a lighter gray.
    sashimiView.contentBackgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:240.0 / 255.0 blue:240.0 / 255.0 alpha:1.0];
    
    // Changing the color of the title to yellow.
    sashimiView.titleLabel.textColor = [UIColor colorWithRed:213.0 / 255.0 green:198.0 / 255.0 blue:136.0 / 255.0 alpha:1.0];
    
    // Changing the color of the icon color to black.
    sashimiView.iconBorderColor = [UIColor blackColor];
     */
}

@end
