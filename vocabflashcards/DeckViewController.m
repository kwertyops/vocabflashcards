//
//  ViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/29/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "DeckViewController.h"
#import "MBProgressHUD.h"
#import "DeckManager.h"
#import "AppDelegate.h"

@interface DeckViewController ()

@end

@implementation DeckViewController

@synthesize revealBlock = _revealBlock;
@synthesize deckManager = _deckManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _deckManager = [appDelegate deckManager];
    
    if([[_deckManager currentDeck] objectForKey:@"title"] != nil)
    {
        self.title = [[_deckManager currentDeck] objectForKey:@"title"];
    }
    else
    {
        self.title = @"No Deck";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTitle
{
    if([[_deckManager currentDeck] objectForKey:@"title"] != nil)
    {
        self.title = [[_deckManager currentDeck] objectForKey:@"title"];
    }
    else
    {
        self.title = @"No Deck";
    }
}

- (void)setRevealBlock:(RevealBlock)revealBlock {
    _revealBlock = [revealBlock copy];
}

- (IBAction)revealSidebar:(id)sender {
    _revealBlock();
}
@end
