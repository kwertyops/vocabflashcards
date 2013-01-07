//
//  EditDeckViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 12/6/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckManager.h"
#import "PrettyNavigationBar.h"

@interface EditDeckViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PrettyNavigationBar *navBar;
@property (nonatomic) DeckManager *deckManager;

- (IBAction)donePressed:(id)sender;
- (IBAction)trashPressed:(id)sender;

@end
