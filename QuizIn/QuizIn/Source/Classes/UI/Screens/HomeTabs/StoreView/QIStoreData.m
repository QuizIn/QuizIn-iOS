
#import "QIStoreData.h"

@implementation QIStoreData
/*
 Harden With Variety - Questions ask in different ways harden your learning.
    Multiple Choice Question Type	FREE
    Business Card Question Type   0.99
    Matching Question Type        0.99
 
 Deepen With Details - Questions about Connection include more details.
    Name, Company, Title	FREE
    Industry,School, and Locale   0.99
 
 
 Focus With Filters - Scope the question down to specific data sets.
    All Connections               FREE
    Company                       0.99
    Locale                        0.99
    School                        0.99
    Industry                      0.99
    People I know the Worst.      0.99
 
 
 Kit and Caboodle - Get everything and all future updates	4.99
 
*/

+ (NSArray *) getStoreData{
  return
  @[
    @{@"type": @"Focus With Filters",
      @"item": @[
                @{@"itemTitle":@"Business Card Question",
                  @"itemPrice":@".99",
                  @"itemDescription":@"Fill out Name, Title, and Company for each individual"},
                
                @{@"itemTitle":@"Business Card Question",
                  @"itemPrice":@".99",
                  @"itemDescription":@"Fill out Name, Title, and Company for each individual"},
                ]},
    
    @{@"type": @"Harden With Variety",
      @"item": @[
                @{@"itemTitle":@"Business Card Question",
                  @"itemPrice":@".99",
                  @"itemDescription":@"New way to harden your knowledge of name, title, and company"},
                
                @{@"itemTitle":@"Matching Question",
                  @"itemPrice":@".99",
                  @"itemDescription":@"Harden by picking from a group of pictures and tidbits"},
                ]},
    
    @{@"type": @"Deepen With Details",
      @"item": @[
                @{@"itemTitle":@"Industry,School,and Locale Details",
                  @"itemPrice":@".99",
                  @"itemDescription":@"Adds Industry, School, and Locale to teh question sets"},
                ]},
    ];
}


@end
