//
//  DeckManager.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "DeckManager.h"

@implementation DeckManager

@synthesize allDecks = _allDecks;
@synthesize currentDeck = _currentDeck;
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
        [_allDecks writeToFile:_filePath atomically: TRUE];
    }
    else
    {
        NSLog(@"Loading decks plist.");
        _allDecks = [NSMutableArray arrayWithContentsOfFile:_filePath];
    }
}

-(void)newDeck:(NSString *)title
{
    
    NSLog(@"Creating new deck");
    
    NSMutableDictionary *newDeck = [[NSMutableDictionary alloc] init];
    
    [newDeck setValue:title forKey:@"title"];
    [newDeck setValue:[[NSMutableArray alloc] init] forKey:@"entries"];
    
    [_allDecks addObject:newDeck];
    
}

-(void)removeDeck:(NSDictionary *)deck
{
    [_allDecks removeObject:deck];
}

-(NSMutableDictionary *)getCurrentDeck
{
    return _currentDeck;
}

-(void)setCurrentDeck:(NSMutableDictionary *)currentDeckIn
{
    _currentDeck = currentDeckIn;
}

@end
