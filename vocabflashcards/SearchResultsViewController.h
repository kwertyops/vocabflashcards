//
//  SearchResultsViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController<UITableViewDelegate>

@property (nonatomic) NSArray *resultsList;
@property (nonatomic) NSMutableArray *resultsByType;

@end
