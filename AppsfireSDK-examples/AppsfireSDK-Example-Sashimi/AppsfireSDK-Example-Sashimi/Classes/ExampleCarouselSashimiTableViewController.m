//
//  ExampleCarouselSashimiTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 24/09/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleCarouselSashimiTableViewController.h"
//
#import "AppsfireAdSDK.h"
//
#import "AFAdSDKSashimiExtendedView.h"
#import "AFAdSDKSashimiMinimalView.h"
#import "AFAdSDKCarouselSashimiView.h"

#pragma mark - Table View Cell

@interface ExampleCarouselSashimiTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat horizontalMargin;

@end

@implementation ExampleCarouselSashimiTableViewCell

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.horizontalMargin, CGRectGetMinY(self.frame), CGRectGetWidth(self.superview.bounds) - (self.horizontalMargin * 2.0), CGRectGetHeight(self.bounds));
    
}

@end

#pragma mark - Table View Controller

@interface ExampleCarouselSashimiTableViewController ()

@property (nonatomic, assign) BOOL didIncludeCarousel;

@property (nonatomic, strong) AFAdSDKCarouselSashimiView *carouselView;

@property (nonatomic, strong) NSMutableArray *arraySource;

- (BOOL)_includeCarouselIfAvailable;

@end

@implementation ExampleCarouselSashimiTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSUInteger index, count;
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    if ((self = [super initWithStyle:style]) != nil) {
        
        //
        self.title = @"Sashimi Carousel";
        self.tableView.rowHeight = 100.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // load content
        self.arraySource = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoremIpsum" ofType:@"plist"]];
        
        // add spacers
        count = [self.arraySource count];
        for (index = 0; index < count; index++) {
            [self.arraySource insertObject:@"spacer" atIndex:(index*2)];
        }
        [self.arraySource addObject:@"spacer"];
  
        //
        self.didIncludeCarousel = NO;
        [self _includeCarouselIfAvailable];
        
    }
    return self;
    
}

- (void)loadView {
    
    [super loadView];
    
    //
    self.view.backgroundColor = [UIColor colorWithWhite:229.0/255.0 alpha:1.0];
    
}

#pragma mark - Include carousel

- (void)tryToIncludeAds {
    
    if ([ self _includeCarouselIfAvailable ])
        [ self.tableView reloadData ];
    
}

- (BOOL)_includeCarouselIfAvailable {
        
    // if we already added some sashimi ad, stop here!
    if (self.didIncludeCarousel)
        return NO;
    
    // get number of available ads
    // stop there is no ad is available
    if ([AppsfireAdSDK numberOfSashimiAdsAvailableForSubclass:[AFAdSDKSashimiExtendedView class] forZone:@"/3180317/square/af"] == 0)
        return NO;
    
    // add carousel into your content
    [ self.arraySource insertObject:@"spacer" atIndex:2 ];
    [ self.arraySource insertObject:@"carousel" atIndex:3 ];
    
    //
    self.didIncludeCarousel = YES;
    
    return YES;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arraySource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [self.arraySource count])
        sourceObject = self.arraySource[indexPath.row];
    
    //
    if ([sourceObject isKindOfClass:[NSString class]]) {

        // carousel
        if ([sourceObject isEqualToString:@"carousel"])
            return 300.0;
        
        // space
        else if ([sourceObject isEqualToString:@"spacer"])
            return 10.0;

    }
    
    //
    return 100.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    NSString *celluid;
    ExampleCarouselSashimiTableViewCell *cell;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [self.arraySource count])
        sourceObject = self.arraySource[indexPath.row];
    
    // determine cell id
    celluid = ([sourceObject isKindOfClass:[NSString class]]) ? sourceObject : @"content";
    
    // get cell
    cell = [tableView dequeueReusableCellWithIdentifier:celluid];
    if (cell == nil) {
        cell = [[ExampleCarouselSashimiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celluid];
        cell.backgroundColor = self.view.backgroundColor;
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [cell.textLabel setNumberOfLines:1];
        [cell.detailTextLabel setNumberOfLines:3];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // carousel
    if ([celluid isEqualToString:@"carousel"]) {
        
        // instanciate only one carousel
        if (self.carouselView == nil) {
            self.carouselView = [[AFAdSDKCarouselSashimiView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds)) sashimiClass:[AFAdSDKSashimiExtendedView class] effects:AFAdSDKCarouselEffectScale];
            self.carouselView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        
        //
        if (self.carouselView.superview != cell.contentView)
            [cell.contentView addSubview:self.carouselView];
        
    }
    
    // spacer
    else if ([celluid isEqualToString:@"carousel"]) {
        
        //
        
    }
    
    // content
    else if ([sourceObject isKindOfClass:[NSDictionary class]]) {
        
        //
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
        
        cell.horizontalMargin = 10.0;
        
        // border
        cell.contentView.layer.borderColor = [UIColor colorWithWhite:199.0/255.0 alpha:1.0].CGColor;
        cell.contentView.layer.borderWidth = 1.0;
        
        // content
        [cell.textLabel setText:sourceObject[@"title"]];
        [cell.detailTextLabel setText:sourceObject[@"content"]];
        
    }
    
    return cell;
    
}

@end
