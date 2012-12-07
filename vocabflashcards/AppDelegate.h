//
//  AppDelegate.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/29/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "DeckViewController.h"
#import "DeckManager.h"
#import "GHMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) DeckManager *deckManager;

@property (nonatomic, strong) GHRevealViewController *revealController;

@property (strong, nonatomic) DeckViewController *deckView;
@property (strong, nonatomic) GHMenuViewController *menuController;

@end
