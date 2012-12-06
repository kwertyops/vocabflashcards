//
//  SearchResultsViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "NewCardViewController.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

@synthesize resultsList = _resultsList;
@synthesize resultsByType = _resultsByType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [[_resultsList objectAtIndex:0] objectForKey:@"name"];
    
    _resultsByType = [[NSMutableArray alloc] init];
    
    for(NSDictionary *word in _resultsList)
    {
        BOOL typeExists = NO;
        
        for(NSDictionary *subType in _resultsByType)
        {
            if([[subType objectForKey:@"type"] isEqualToString:[word objectForKey:@"type"]])
            {
                [[subType objectForKey:@"words"] addObject:word];
                typeExists = YES;
            }
        }
        
        if(!typeExists)
        {
            NSMutableDictionary *newSubtype = [[NSMutableDictionary alloc] init];
            NSMutableArray *wordsForSubtype = [[NSMutableArray alloc] init];
            [wordsForSubtype addObject:word];
            [newSubtype setValue:wordsForSubtype forKey:@"words"];
            [newSubtype setValue:[word objectForKey:@"type"] forKey:@"type"];
            [_resultsByType addObject:newSubtype];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_resultsByType count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[_resultsByType objectAtIndex:section] objectForKey:@"type"];
    
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[_resultsByType objectAtIndex:section] objectForKey:@"words"] count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (detailCell == nil) {
        detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    detailCell.textLabel.text = [[[[_resultsByType objectAtIndex:indexPath.section] objectForKey:@"words"] objectAtIndex:indexPath.row] objectForKey:@"description"];
    detailCell.textLabel.numberOfLines = 0;
    
    
    return detailCell;
    
}

- (void)tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    NewCardViewController *ncvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NewCardViewController"];
    
    ncvc.wordFromDict = [[[_resultsByType objectAtIndex:indexPath.section] objectForKey:@"words"] objectAtIndex:indexPath.row];
    
    [[self navigationController] pushViewController:ncvc animated:YES];
    
}


//If a cell height needs to be changed.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [[[[[_resultsByType objectAtIndex:indexPath.section] objectForKey:@"words"] objectAtIndex:indexPath.row] objectForKey:@"description"] sizeWithFont:[UIFont boldSystemFontOfSize:19.0f] constrainedToSize:CGSizeMake(320.0f, 2000.0f) lineBreakMode:NSLineBreakByWordWrapping].height+20;
    
}

@end
