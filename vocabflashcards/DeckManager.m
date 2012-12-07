//
//  DeckManager.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "DeckManager.h"
#import "AppDelegate.h"
#import "GHRevealViewController.h"
#import "DeckViewController.h"

@implementation DeckManager

@synthesize allDecks = _allDecks;
@synthesize currentDeck = _currentDeck;
@synthesize cardQueue = _cardQueue;
@synthesize fileManager = _fileManager;
@synthesize filePath = _filePath;

-(void)loadFile
{
    _allDecks = [[NSMutableArray alloc] init];
    _currentDeck = [[NSMutableDictionary alloc] init];
    _fileManager = [[NSFileManager alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _filePath = [documentsDirectory stringByAppendingPathComponent:@"userdecks.plist"];
        
    //create Favorites file if it doesn't already exist
    if (![_fileManager fileExistsAtPath:_filePath])
    {
        NSLog(@"Creating decks plist.");
        [self newDeck:@"Default Deck"];
        _currentDeck = [_allDecks objectAtIndex:0];
        [[_currentDeck objectForKey:@"entries"] addObject:@{@"name":@"Test",@"description":@"test description",@"type":@"noun"}];
        [_allDecks writeToFile:_filePath atomically: TRUE];
    }
    else
    {
        NSLog(@"Loading decks plist.");
        _allDecks = [NSMutableArray arrayWithContentsOfFile:_filePath];
    }
}

-(void)writeFile
{
    
}

-(NSInteger)indexForCurrentDeck
{
    NSInteger i = 0;
    
    for(NSMutableDictionary *deck in _allDecks)
    {
        if(_currentDeck == deck)
        {
            return i;
        }
        else
        {
            i++;
        }
    }
    return -1;
}

-(NSMutableDictionary *)nextCard
{
    
    if(_cardQueue == nil || [_cardQueue count] == 0)
    {
        [self loadCardQueue];
    }
    else
    {
        [_cardQueue removeLastObject];
        
        if([_cardQueue count] == 0)
            [self loadCardQueue];
    }
    
    return [_cardQueue lastObject];
    
}

-(void)loadCardQueue
{
    _cardQueue = [[NSMutableArray alloc] init];
    
    if([[_currentDeck objectForKey:@"entries"] count] != 0)
    {
        _cardQueue = [[NSMutableArray alloc] initWithArray:[_currentDeck objectForKey:@"entries"]];
    }
}

-(void)newDeck:(NSString *)title
{
        
    NSMutableDictionary *newDeck = [[NSMutableDictionary alloc] init];
    
    [newDeck setValue:title forKey:@"title"];
    [newDeck setValue:[[NSMutableArray alloc] init] forKey:@"entries"];
    
    [_allDecks addObject:newDeck];
    _currentDeck = newDeck;
    
    [self loadCardQueue];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate deckView] reload];
    [[appDelegate menuController] reinit];
    
}

-(void)removeDeck:(NSDictionary *)deck
{
    [_allDecks removeObject:deck];
    
    if([_allDecks count] > 0)
        _currentDeck = [_allDecks objectAtIndex:0];
    else
        _currentDeck = [[NSMutableDictionary alloc] init];
    
    [self loadCardQueue];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate deckView] reload];
    [[appDelegate menuController] reinit];
    
}

-(NSMutableDictionary *)getCurrentDeck
{
    return _currentDeck;
}

-(void)setCurrentDeck:(NSMutableDictionary *)currentDeckIn
{
    _currentDeck = currentDeckIn;
    
    [self loadCardQueue];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate deckView] reload];
    [[appDelegate menuController] reinit];
    
}

@end
