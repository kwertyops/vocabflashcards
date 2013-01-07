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
@synthesize numWrong = _numWrong;

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
        //[self newDeck:@"Default Deck"];
        //_currentDeck = [_allDecks objectAtIndex:0];
        //[_allDecks addObject:@{@"title":@"Default Deck", @"entries": @[@{@"name":@"word",@"description":@"Description OMG!",@"type":@"noun",@"correct":[NSNumber numberWithInt:0],@"attempts":[NSNumber numberWithInt:0]}]}];
        
        NSMutableDictionary *newDeck = [[NSMutableDictionary alloc] init];
        
        [newDeck setValue:@"Default Deck" forKey:@"title"];
        [newDeck setValue:[[NSMutableArray alloc] init] forKey:@"entries"];
        
        [[newDeck objectForKey:@"entries"] addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"name":@"Wiktionary",@"description":@"A collaborative project run by the Wikimedia Foundation to produce a free and complete dictionary (lexicon and thesaurus therein) in every language.",@"type":@"noun",@"correct":[NSNumber numberWithInt:0],@"attempts":[NSNumber numberWithInt:0]}]];
        [[newDeck objectForKey:@"entries"] addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"name":@"flashcard",@"description":@"A card used to aid rote memorization. One side of the card contains data of one kind, or a question, and the other side contains the associated response which one wants to memorize.",@"type":@"noun",@"correct":[NSNumber numberWithInt:0],@"attempts":[NSNumber numberWithInt:0]}]];
        [[newDeck objectForKey:@"entries"] addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"name":@"word",@"description":@"A distinct unit of language (sounds in speech or written letters) with a particular meaning, composed of one or more morphemes, and also of one or more phonemes that determine its sound pattern.",@"type":@"noun",@"correct":[NSNumber numberWithInt:0],@"attempts":[NSNumber numberWithInt:0]}]];
        
        [_allDecks addObject:newDeck];
        
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
    [_allDecks writeToFile:_filePath atomically:TRUE];
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
    else if(_numWrong == 3)
    {
        [self loadCardQueue];
        _numWrong = 0;
    }
    else if([_cardQueue count] == 0)
    {
        NSLog(@"Out of cards");
        [self loadCardQueue];
    }
    
    NSMutableDictionary *lastCard = [_cardQueue lastObject];

    [_cardQueue removeLastObject];

    return lastCard;
        
}

-(void)gotOneWrong
{
    _numWrong++;
}

-(void)loadCardQueue
{
    _cardQueue = [[NSMutableArray alloc] init];
    
    _numWrong = 0;
    
    if([[_currentDeck objectForKey:@"entries"] count] != 0)
    {
        _cardQueue = [[NSMutableArray alloc] initWithArray:[_currentDeck objectForKey:@"entries"]];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"correct" ascending:NO];
    _cardQueue = [[NSMutableArray alloc] initWithArray:[_cardQueue sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]];
        
}

-(void)newDeck:(NSString *)title
{
        
    NSMutableDictionary *newDeck = [[NSMutableDictionary alloc] init];
    
    [newDeck setValue:title forKey:@"title"];
    [newDeck setValue:[[NSMutableArray alloc] init] forKey:@"entries"];
    
    [_allDecks addObject:newDeck];
    [self setCurrentDeck:newDeck];
    
}

-(void)removeDeck:(NSDictionary *)deck
{
    [_allDecks removeObject:deck];
    
    if([_allDecks count] > 0)
        [self setCurrentDeck:[_allDecks objectAtIndex:0]];
    else
        [self setCurrentDeck:[[NSMutableDictionary alloc] init]];
    
}

-(NSMutableDictionary *)getCurrentDeck
{
    return _currentDeck;
}

-(void)setCurrentDeck:(NSMutableDictionary *)currentDeckIn
{
    _currentDeck = currentDeckIn;
    
    for(NSMutableDictionary *entry in [_currentDeck objectForKey:@"entries"])
    {
        [entry setValue:[NSNumber numberWithInt:0] forKey:@"attempts"];
        [entry setValue:[NSNumber numberWithInt:0] forKey:@"correct"];
    }
    
    [self loadCardQueue];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate deckView] reload];
    [[appDelegate menuController] reinit];
    
    [self writeFile];
    
}

-(void)addCard:(NSDictionary *)card toDeck:(NSMutableDictionary *)deck
{
    
    [card setValue:[NSNumber numberWithInt:0] forKey:@"attempts"];
    [card setValue:[NSNumber numberWithInt:0] forKey:@"correct"];
    
    [[deck objectForKey:@"entries"] addObject:card];
    
    [self writeFile];
    
}

@end
