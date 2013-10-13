
#import "QIStoreData.h"
#import "QIIAPHelper.h"

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

+ (NSArray *) getStoreDataWithProducts:(NSArray *)products{
  
  NSString *filterKey = @"f_";
  NSIndexSet *filterIndexes = [products indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    SKProduct *product = (SKProduct *)obj;
    NSRange findKey = [product.productIdentifier rangeOfString:filterKey];
    NSUInteger found = findKey.location;
    if (found == NSNotFound){
      return NO;
    }
    else{
      NSLog(@"FILTER: %@",product.productIdentifier);
      return YES;
    }
  }];
  NSArray *filterPurchases = [products objectsAtIndexes:filterIndexes]; 
  
  NSString *questionKey = @"q_";
  NSIndexSet *questionTypeIndexes = [products indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    SKProduct *product = (SKProduct *)obj;
    NSRange findKey = [product.productIdentifier rangeOfString:questionKey];
    NSUInteger found = findKey.location;
    if (found == NSNotFound){
      return NO;
    }
    else{
      NSLog(@"QUESTION: %@",product.productIdentifier);
      return YES;
    }
  }];
  NSArray *questionPurchases = [products objectsAtIndexes:questionTypeIndexes];
  
  NSString *detailKey = @"d_";
  NSIndexSet *detailIndexes = [products indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    SKProduct *product = (SKProduct *)obj;
    NSRange findKey = [product.productIdentifier rangeOfString:detailKey];
    NSUInteger found = findKey.location;
    if (found == NSNotFound){
      return NO;
    }
    else{
      NSLog(@"DETAIL: %@",product.productIdentifier);
      return YES;
    }
  }];
  NSArray *detailPurchases = [products objectsAtIndexes:detailIndexes];
  
  NSMutableArray *filterPurchasesItems = [NSMutableArray array];
  for (SKProduct *product in filterPurchases){
    [filterPurchasesItems addObject:[self storeItemWithProduct:product]];
  }
  
  NSMutableArray *questionPurchasesItems = [NSMutableArray array];
  for (SKProduct *product in questionPurchases){
    [questionPurchasesItems addObject:[self storeItemWithProduct:product]];
  }
  
  NSMutableArray *detailPurchasesItems = [NSMutableArray array];
  for (SKProduct *product in detailPurchases){
    [detailPurchasesItems addObject:[self storeItemWithProduct:product]];
  }
  
  NSMutableArray *storeItems = [NSMutableArray array];
  
  if ([filterPurchasesItems count]>0){
    [storeItems addObject:
     @{
     @"type":@"Focus With Filters",
     @"item":filterPurchasesItems,
     }];
  }

  if ([questionPurchasesItems count]>0){
    [storeItems addObject:
     @{
     @"type":@"Harden With Variety",
     @"item":questionPurchasesItems,
     }];
  }
  
  if ([detailPurchasesItems count]>0){
    [storeItems addObject:
     @{
     @"type":@"Deepen With Details",
     @"item":detailPurchasesItems,
     }];
  }
  return storeItems; 
}

+ (NSArray *)getBuyAllProductWithProducts:(NSArray *)products{
  NSString *allKey = @"p_";
  NSIndexSet *allIndexes = [products indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    SKProduct *product = (SKProduct *)obj;
    NSRange findKey = [product.productIdentifier rangeOfString:allKey];
    NSUInteger found = findKey.location;
    if (found == NSNotFound){
      return NO;
    }
    else{
      NSLog(@"BUY_ALL: %@",product.productIdentifier);
      return YES;
    }
  }];
  return [products objectsAtIndexes:allIndexes];
}

+ (NSString *)formattedPriceWithProduct:(SKProduct *)product{
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [numberFormatter setLocale:product.priceLocale];
  return [numberFormatter stringFromNumber:product.price];
}

+ (NSString *)shortDescrtptionWithProduct:(SKProduct *)product{
  //Todo Change this into a singleton
  NSArray *productIdentifiers = 
        @[
          @"com.kuhlmanation.hobnob.d_pack1",
          @"com.kuhlmanation.hobnob.p_kit",
          @"com.kuhlmanation.hobnob.q_businesscard",
          @"com.kuhlmanation.hobnob.q_matching",
          @"com.kuhlmanation.hobnob.f_company",
          @"com.kuhlmanation.hobnob.f_group",
          @"com.kuhlmanation.hobnob.f_industry",
          @"com.kuhlmanation.hobnob.f_locale",
          @"com.kuhlmanation.hobnob.f_least"];
  
  switch ([productIdentifiers indexOfObject:product.productIdentifier]) {
    case 0: //com.kuhlmanation.hobnob.d_pack1
      return @"Add more details to your HobNobin' abilities";
      break;
    case 1: //com.kuhlmanation.hobnob.p_kit
      return @"Get them all at a discount";
      break;
    case 2: //com.kuhlmanation.hobnob.q_businesscard
      return @"Add the business card question type to the HobNob mix";
      break;
    case 3: //com.kuhlmanation.hobnob.q_matching
      return @"Add a matching question type to the HobNob mix";
      break;
    case 4: //com.kuhlmanation.hobnob.f_company
      return @"HobNob with contacts from specific companies";
      break;
    case 5: //com.kuhlmanation.hobnob.f_group
      return @"HobNob with contacts with specific interests and associations";
      break;
    case 6: //com.kuhlmanation.hobnob.f_industry
      return @"HobNob with contacts from particular industries"; 
      break;
    case 7: //com.kuhlmanation.hobnob.f_locale
      return @"HobNob with contacts in various locations";
      break;
    case 8: //com.kuhlmanation.hobnob.f_least"
      return @"HobNob with contacts you know the worst"; 
      break;
    default:
      return @"Upgrade your HobNobin' abilities"; 
      break;
  }
}

+ (UIImage *)iconWithProduct:(SKProduct *)product{
  
  NSArray *productIdentifiers =
  @[
    @"com.kuhlmanation.hobnob.d_pack1",
    @"com.kuhlmanation.hobnob.p_kit",
    @"com.kuhlmanation.hobnob.q_businesscard",
    @"com.kuhlmanation.hobnob.q_matching",
    @"com.kuhlmanation.hobnob.f_company",
    @"com.kuhlmanation.hobnob.f_group",
    @"com.kuhlmanation.hobnob.f_industry",
    @"com.kuhlmanation.hobnob.f_locale",
    @"com.kuhlmanation.hobnob.f_least"];
  
  switch ([productIdentifiers indexOfObject:product.productIdentifier]) {
    case 0: //com.kuhlmanation.hobnob.d_pack1
      return [UIImage imageNamed:@"store_producticon_businesscard"];
      break;
    case 1: //com.kuhlmanation.hobnob.p_kit
      return [UIImage imageNamed:@"store_producticon_businesscard"];
      break;
    case 2: //com.kuhlmanation.hobnob.q_businesscard
      return [UIImage imageNamed:@"store_producticon_businesscard"];
      break;
    case 3: //com.kuhlmanation.hobnob.q_matching
      return [UIImage imageNamed:@"store_producticon_matching"];
      break;
    case 4: //com.kuhlmanation.hobnob.f_company
      return [UIImage imageNamed:@"store_producticon_company"]; 
      break;
    case 5: //com.kuhlmanation.hobnob.f_group
      return [UIImage imageNamed:@"store_producticon_group"];
      break;
    case 6: //com.kuhlmanation.hobnob.f_industry
      return [UIImage imageNamed:@"store_producticon_industry"];
      break;
    case 7: //com.kuhlmanation.hobnob.f_locale
      return [UIImage imageNamed:@"store_producticon_locale"];
      break;
    case 8: //com.kuhlmanation.hobnob.f_least"
      return [UIImage imageNamed:@"store_producticon_leastofthese"];
      break;
    default:
      return [UIImage imageNamed:@"store_producticon_businesscard"];
      break;
  }
}

+ (NSNumber *)productPurchasedWithProduct:(SKProduct *)product{
  return [NSNumber numberWithBool:[[QIIAPHelper sharedInstance] productPurchased:product.productIdentifier]];
}

+ (NSDictionary *)storeItemWithProduct:(SKProduct *)product{
  return
    @{
      @"itemTitle":product.localizedTitle,
      @"itemPrice":[self formattedPriceWithProduct:product],
      @"itemDescription":product.localizedDescription,
      @"itemShortDescription":[self shortDescrtptionWithProduct:product],
      @"itemIcon":[self iconWithProduct:product],
      @"itemPurchased":[self productPurchasedWithProduct:product],
      @"product":product
    };
}

@end
