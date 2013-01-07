//
//  DBManager.m
//  vocabflashcardsbuilder
//
//  Created by Andrew Hannum on 6/27/12.
//  Copyright (c) 2012 GitRHub. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager

@synthesize db = _db;
@synthesize tempResults = _tempResults;

- (void)openDatabase
{
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"wiktionarydb2.sqlite"];
    
    _db = [FMDatabase databaseWithPath:defaultDBPath];
    
    [_db open];
    
}

//Check for the writable database file, if it doesn't exist, create it.
- (void)checkForDBFile
{
    
}

//The algorithm for returning autoComplete results in an array
- (NSMutableArray *)autoComplete : (NSString *)searchTerm
{
    
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    FMResultSet *s = [_db executeQuery:[NSString stringWithFormat:(@"SELECT name, type, description FROM dictionary WHERE name LIKE '%@%%' ORDER BY name COLLATE NOCASE"), searchTerm]];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    _tempResults = [[NSMutableDictionary alloc] init];
    
    while([s next])
    {
        if(![results containsObject:[s stringForColumn:@"name"]])
            [results addObject:[s stringForColumn:@"name"]];
        
        NSMutableDictionary *word = [[NSMutableDictionary alloc] init];
        [word setValue:[s stringForColumn:@"name"] forKey:@"name"];
        [word setValue:[s stringForColumn:@"type"] forKey:@"type"];
        [word setValue:[s stringForColumn:@"description"] forKey:@"description"];
        
        if([_tempResults objectForKey:[word objectForKey:@"name"]] == nil)
        {
            [_tempResults setValue:[[NSMutableArray alloc] init] forKey:[word objectForKey:@"name"]];
        }
        
        [[_tempResults objectForKey:[word objectForKey:@"name"]] addObject:word];
        
    }
    
    return results;
    
}

//This is an actual search with no limit and where word type matters
- (NSMutableArray *)searchForWord : (NSString *)searchTerm
{
    
    /*
    
    
    
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    FMResultSet *s = [_db executeQuery:[NSString stringWithFormat:(@"SELECT name, type, description FROM dictionary WHERE name='%@' COLLATE BINARY ORDER BY name"), searchTerm]];
    */
    
    NSMutableArray *results = [_tempResults objectForKey:searchTerm];
    
    for(NSMutableDictionary *word in results)
    {
        /*
        //NSMutableDictionary *word = [[NSMutableDictionary alloc] init];
        [word setValue:[s stringForColumn:@"name"] forKey:@"name"];
        [word setValue:[s stringForColumn:@"type"] forKey:@"type"];
        [word setValue:[s stringForColumn:@"description"] forKey:@"description"];
        */
        
        NSString *description = [word objectForKey:@"description"];
                
        //Remove leading #
        description = [description stringByReplacingOccurrencesOfString:@"# " withString:@""];
        
        //Replace '' with "
        description = [description stringByReplacingOccurrencesOfString:@"''" withString:@"\""];
    
        //Remove {{ * | * | * }}
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{(.*?)\\|(.*?)\\|(.*?)\\}\\}" options:NSRegularExpressionCaseInsensitive error:nil];
        if([regex numberOfMatchesInString:description options:0 range:NSMakeRange(0, description.length)] == 1)
        {
        description = [regex stringByReplacingMatchesInString:description options:0 range:NSMakeRange(0, description.length) withTemplate:@"$1"];
        }
        
        
        //Remove {{ * }}
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{(.*?)\\}\\}" options:NSRegularExpressionCaseInsensitive error:nil];
        NSString *description_temp = [regex stringByReplacingMatchesInString:description options:0 range:NSMakeRange(0, description.length) withTemplate:@""];
        
        
        //If the {{ }} was the only text, put back what was inside of it
        if([[description_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        {
            description = [regex stringByReplacingMatchesInString:description options:0 range:NSMakeRange(0, description.length) withTemplate:@"$1"];
            description = [description stringByReplacingOccurrencesOfString:@"|" withString:@" "];
            description = [description stringByAppendingString:@"."];
        }
        else
        {
            description = description_temp;
        }
        
        
        //Remove [[ * |
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\[.*?\\|" options:NSRegularExpressionCaseInsensitive error:nil];
        description = [regex stringByReplacingMatchesInString:description options:0 range:NSMakeRange(0, description.length) withTemplate:@""];
        
        //Remove remaining [[ and ]]
        description = [description stringByReplacingOccurrencesOfString:@"[[" withString:@""];
        description = [description stringByReplacingOccurrencesOfString:@"]]" withString:@""];
        
        //Remove <ref> and </ref>
        description = [description stringByReplacingOccurrencesOfString:@"<ref>" withString:@""];
        description = [description stringByReplacingOccurrencesOfString:@"</ref>" withString:@""];
        
        //Remove leading whitespace
        while([[description substringToIndex:1] isEqualToString:@" "])
        {
            description = [description substringFromIndex:1];
        }
        
        //Capitalize first letter
        description = [description stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[description substringToIndex:1] uppercaseString]];
        
        
        [word setValue:description forKey:@"description"];
        
        //[results addObject:word];
    }
    
    
    return results;
}

- (void)updateDictionary
{
    //[_database executeUpdate:@"CREATE TABLE dictionary(lang, name COLLATE NOCASE, type, description)"];
    
    /*
     
     [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"Building dictionary...";
     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
     
     char str[20000];
     FILE *fp;
     const char *path = [defaultDBPath UTF8String];
     fp = fopen(path, "r");
     if(!fp)
     NSLog(@"File not found");
     else
     {
     NSLog(@"File found");
     while(fgets(str,sizeof(str),fp) != NULL)
     {
     // strip trailing '\n' if it exists
     int len = strlen(str)-1;
     if(str[len] == '\n')
     str[len] = 0;
     NSString *translation = [[NSString alloc] initWithUTF8String:str];
     //NSLog(@"String: %@", translation);
     NSArray *explode = [translation componentsSeparatedByString:@"\t"];
     //NSLog(@"Explosion: %@", explode);
     
     [_database executeUpdate:[NSString stringWithFormat:@"INSERT INTO dictionary (lang, name, type, description) VALUES ('%@', '%@', '%@', '%@')", [explode objectAtIndex:0],[explode objectAtIndex:1],[explode objectAtIndex:2],[explode objectAtIndex:3]]];
     }
     fclose(fp);
     }
     
     dispatch_async(dispatch_get_main_queue(), ^{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     });
     });
     */
    
}



@end
