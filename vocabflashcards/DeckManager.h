//
//  DeckManager.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeckManager : NSObject

@property (nonatomic) NSMutableArray *allDecks;
@property (nonatomic) NSMutableDictionary *currentDeck;
@property (nonatomic) NSMutableArray *cardQueue;
@property (nonatomic) NSString *filePath;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSInteger numWrong;

-(void)loadFile;

-(void)newDeck:(NSString *)title;
-(void)removeDeck:(NSDictionary *)deck;

-(NSMutableDictionary *)getCurrentDeck;
-(NSMutableDictionary *)nextCard;
-(NSInteger)indexForCurrentDeck;
-(void)gotOneWrong;
-(void)setCurrentDeck:(NSMutableDictionary *)currentDeck;
-(void)addCard:(NSDictionary *)card toDeck:(NSMutableDictionary *)deck;

@end
