//
//  EditDeckViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 12/6/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "EditDeckViewController.h"
#import "AppDelegate.h"

@interface EditDeckViewController ()

@end

@implementation EditDeckViewController

@synthesize tableView = _tableView;
@synthesize deckManager = _deckManager;
@synthesize navBar = _navBar;

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
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _deckManager = appDelegate.deckManager;
    
    if([_deckManager currentDeck] != nil)
    {
        self.navBar.topItem.title = [[_deckManager currentDeck] objectForKey:@"title"];
    }
    else
    {
        self.navBar.topItem.title = @"No Deck";

    }
    
    [_tableView reloadData];
    
    [_tableView setEditing:YES animated:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[_deckManager getCurrentDeck] objectForKey:@"entries"] removeObjectAtIndex:indexPath.row];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [[appDelegate deckView] reload];
        [_tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_deckManager getCurrentDeck] objectForKey:@"entries"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell"];
    
    if (basicCell == nil) {
        basicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EntryCell"];
    }
    basicCell.textLabel.text = [[[[_deckManager getCurrentDeck] objectForKey:@"entries"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    basicCell.detailTextLabel.text = [[[[_deckManager getCurrentDeck] objectForKey:@"entries"] objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    return basicCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}


- (IBAction)donePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)trashPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [_deckManager removeDeck:[_deckManager getCurrentDeck]];
    
}
@end
