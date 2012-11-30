//
//  DBManager.h
//  vocabflashcardsbuilder
//
//  Created by Andrew Hannum on 6/27/12.
//  Copyright (c) 2012 GitRHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"

@interface DBManager : NSObject

@property (atomic) FMDatabase *db;

- (void)openDatabase;
- (void)checkForDBFile;
- (NSMutableArray *)autoComplete:(NSString *)searchTerm;
- (NSMutableArray *)searchForWord:(NSString *)word;


@end
