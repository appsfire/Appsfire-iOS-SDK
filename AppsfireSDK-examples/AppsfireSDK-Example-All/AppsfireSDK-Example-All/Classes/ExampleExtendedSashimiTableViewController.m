//
//  ExampleSashimiExtendedTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 04/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleExtendedSashimiTableViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// views
#import "ExampleExtendedSashimiTableViewCell.h"

@interface ExampleExtendedSashimiTableViewController () {
    
    BOOL _didIncludeSashimi;
    NSMutableArray *_arraySource;
    
}
- (BOOL)_includeSashimiIfAvailable;

@end

@implementation ExampleExtendedSashimiTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    if ((self = [super initWithStyle:style]) != nil) {
        
        //
        self.title = @"Sashimi Extended";
        
        //
        _arraySource = [NSMutableArray array];
        
        // fill array with dummy inserts for test purpose
        [_arraySource addObject:@{@"title": @"Lorem ipsum dolor sit amet, consectetur adipiscing elit.", @"content": @"Sed lacinia dui at dui euismod, posuere ultricies massa mollis. Donec id orci quis dui lobortis scelerisque."}];
        [_arraySource addObject:@{@"title": @"Aliquam sollicitudin turpis quis enim iaculis eleifend non a dolor.", @"content": @"Cras accumsan erat ac nunc suscipit, id venenatis libero rhoncus. Aliquam egestas tortor sed purus porttitor laoreet."}];
        [_arraySource addObject:@{@"title": @"Praesent tristique dolor vehicula mi porttitor dictum quis id sem.", @"content": @"Nam vitae sem id sem ullamcorper pretium. Cras consectetur lectus sed diam egestas sodales."}];
        [_arraySource addObject:@{@"title": @"Nullam bibendum ligula ac purus imperdiet sodales.", @"content": @"Morbi eu justo a lorem blandit vulputate vitae eget tortor. Fusce iaculis justo a orci interdum, et vulputate sem gravida."}];
        [_arraySource addObject:@{@"title": @"Phasellus rhoncus nisi id hendrerit tempus.", @"content": @"Nulla ac nibh eu ante tempus ornare et ut massa. Cras eleifend odio ut ullamcorper cursus."}];
        [_arraySource addObject:@{@"title": @"Suspendisse eleifend quam non scelerisque fermentum.", @"content": @"Vestibulum dictum nibh ut ipsum varius malesuada. Morbi volutpat magna ut nibh condimentum, tincidunt pulvinar magna vulputate."}];

        //
        _didIncludeSashimi = NO;
        [self _includeSashimiIfAvailable];

    }
    return self;
    
}

#pragma mark - Include sashimi

- (void)tryIncludingSashimiAds {
    
    if ([ self _includeSashimiIfAvailable ])
        [ self.tableView reloadData ];
    
}

- (BOOL)_includeSashimiIfAvailable {
    
    NSUInteger sashimiAdsCount;
    NSUInteger index, sashimiAdMax, sashimiAdSpacing, sashimiAdAdded;
    
    // if we already added some sashimi ad, stop here!
    if (_didIncludeSashimi)
        return NO;
    
    // get number of available ads
    // stop there is no ad is available
    sashimiAdsCount = [AppsfireAdSDK numberOfSashimiAdsAvailableForFormat:AFAdSDKSashimiFormatExtended];
    if (sashimiAdsCount == 0)
        return NO;
    
    // add ads into your content
    // adapt the logic to your own concern
    // or create a custom logic to better fit with your implementation!
    sashimiAdMax = 2;
    sashimiAdSpacing = 3;
    for (sashimiAdAdded = 0, index = sashimiAdSpacing ; index <= [_arraySource count] && sashimiAdAdded < sashimiAdsCount && sashimiAdAdded < sashimiAdMax ; index += sashimiAdSpacing) {
        
        [ _arraySource insertObject:@"sashimi" atIndex:index ];
        sashimiAdAdded++;
        index++;
        
    }
    
    //
    _didIncludeSashimi = YES;
    
    return YES;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arraySource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [_arraySource count])
        sourceObject = _arraySource[indexPath.row];
    
    //
    return ([sourceObject isKindOfClass:[NSString class]] && [sourceObject isEqualToString:@"sashimi"]) ? 300.0 : 100.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    NSString *celluid;
    UITableViewCell *cell;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [_arraySource count])
        sourceObject = _arraySource[indexPath.row];
    
    // determine cell id
    celluid = ([sourceObject isKindOfClass:[NSString class]] && [sourceObject isEqualToString:@"sashimi"]) ? @"sashimi-extended" : @"classic";
    
    // get cell
    cell = [tableView dequeueReusableCellWithIdentifier:celluid];
    if (cell == nil) {
        
        // create cell
        if ([celluid isEqualToString:@"sashimi-extended"])
            cell = [[ExampleExtendedSashimiTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celluid];
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
