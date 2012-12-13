//
//  InsertCardViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 12/5/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "InsertCardViewController.h"
#import "DeckManager.h"
#import "AppDelegate.h"

@interface InsertCardViewController ()

@end

@implementation InsertCardViewController

@synthesize tableView = _tableView;
@synthesize allDecks = _allDecks;
@synthesize cardToInsert = _cardToInsert;
@synthesize deckManager = _deckManager;

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
	// Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _deckManager = [appDelegate deckManager];
    
    _allDecks = [_deckManager allDecks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_allDecks count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Add To Deck:";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];

    if (basicCell == nil) {
        basicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BasicCell"];
    }
    basicCell.textLabel.text = [[_allDecks objectAtIndex:indexPath.row] objectForKey:@"title"];
    basicCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return basicCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    [_cardToInsert setValue:[NSNumber numberWithFloat:0] forKey:@"attempts"];
    [_cardToInsert setValue:[NSNumber numberWithFloat:0] forKey:@"correct"];
        
    [[[_allDecks objectAtIndex:indexPath.row] objectForKey:@"entries"] addObject:_cardToInsert];
    
    */
    [_deckManager addCard:_cardToInsert toDeck:[_allDecks objectAtIndex:indexPath.row]];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate deckView] reload];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
