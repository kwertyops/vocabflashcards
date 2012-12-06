//
//  InsertCardViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 12/5/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckManager.h"

@interface InsertCardViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *allDecks;
@property (weak, nonatomic) DeckManager *deckManager;
@property (weak, nonatomic) NSDictionary *cardToInsert;

@end
