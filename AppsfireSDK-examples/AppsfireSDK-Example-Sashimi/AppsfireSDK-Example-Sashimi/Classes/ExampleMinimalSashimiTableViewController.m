//
//  ExampleSashimiMinimalTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 04/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleMinimalSashimiTableViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// views
#import "ExampleMinimalSashimiTableViewCell.h"

@interface ExampleMinimalSashimiTableViewController ()

@property (nonatomic, assign) BOOL didIncludeSashimi;

@property (nonatomic, strong) NSMutableArray *arraySource;

- (BOOL)_includeSashimiIfAvailable;

@end

@implementation ExampleMinimalSashimiTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    if ((self = [super initWithStyle:style]) != nil) {
        
        //
        self.title = @"Sashimi Minimal";
        self.tableView.rowHeight = 100.0;
        
        //
        self.arraySource = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoremIpsum" ofType:@"plist"]];

        //
        self.didIncludeSashimi = NO;
        [self _includeSashimiIfAvailable];

    }
    return self;
    
}

#pragma mark - Include sashimi

- (void)tryToIncludeAds {
    
    if ([ self _includeSashimiIfAvailable ])
        [ self.tableView reloadData ];
    
}

- (BOOL)_includeSashimiIfAvailable {
    
    NSUInteger sashimiAdsCount;
    NSUInteger index, sashimiAdMax, sashimiAdSpacing, sashimiAdAdded;
    
    // if we already added some sashimi ad, stop here!
    if (self.didIncludeSashimi)
        return NO;
    
    // get number of available ads
    // stop there is no ad is available
    sashimiAdsCount = [AppsfireAdSDK numberOfSashimiAdsAvailableForFormat:AFAdSDKSashimiFormatMinimal];
    if (sashimiAdsCount == 0)
        return NO;
    
    // add ads into your content
    // adapt the logic to your own concern
    // or create a custom logic to better fit with your implementation!
    sashimiAdMax = 2;
    sashimiAdSpacing = 3;
    for (sashimiAdAdded = 0, index = sashimiAdSpacing ; index <= [self.arraySource count] && sashimiAdAdded < sashimiAdsCount && sashimiAdAdded < sashimiAdMax ; index += sashimiAdSpacing) {
        
        [ self.arraySource insertObject:@"sashimi" atIndex:index ];
        sashimiAdAdded++;
        index++;
        
    }
    
    //
    self.didIncludeSashimi = YES;
    
    return YES;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arraySource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    NSString *celluid;
    UITableViewCell *cell;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [self.arraySource count])
        sourceObject = self.arraySource[indexPath.row];
    
    // determine cell id
    celluid = ([sourceObject isKindOfClass:[NSString class]] && [sourceObject isEqualToString:@"sashimi"]) ? @"sashimi-minimal" : @"classic";
    
    // get cell
    cell = [tableView dequeueReusableCellWithIdentifier:celluid];
    if (cell == nil) {
        
        // create cell
        if ([celluid isEqualToString:@"sashimi-minimal"])
            cell = [[ExampleMinimalSashimiTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celluid];
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celluid];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [cell.textLabel setNumberOfLines:1];
            [cell.detailTextLabel setNumberOfLines:3];
            [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        }
        
        // no selection
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    // fill cell
    if ([sourceObject isKindOfClass:[NSDictionary class]]) {
        
        [cell.textLabel setText:sourceObject[@"title"]];
        [cell.detailTextLabel setText:sourceObject[@"content"]];
        
    }
    
    return cell;
    
}

@end
