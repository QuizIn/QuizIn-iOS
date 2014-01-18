
#import "QIStoreData.h"
#import "QIIAPHelper.h"

@implementation QIStoreData

/*
 @"com.kuhlmanation.hobnob.p_kit", - everything
 @"com.kuhlmanation.hobnob.q_pack", - question pack
 @"com.kuhlmanation.hobnob.f_pack", - filter pack
 @"com.kuhlmanation.hobnob.r_pack", - refresher pack
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
  
  NSString *detailKey = @"r_";
  NSIndexSet *detailIndexes = [products indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    SKProduct *product = (SKProduct *)obj;
    NSRange findKey = [product.productIdentifier rangeOfString:detailKey];
    NSUInteger found = findKey.location;
    if (found == NSNotFound){
      return NO;
    }
    else{
      NSLog(@"REFRESH: %@",product.productIdentifier);
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
     @"type":@"Quiz Filters",
     @"item":filterPurchasesItems,
     }];
  }

  if ([questionPurchasesItems count]>0){
    [storeItems addObject:
     @{
     @"type":@"Question Types",
     @"item":questionPurchasesItems,
     }];
  }
  
  if ([detailPurchasesItems count]>0){
    [storeItems addObject:
     @{
     @"type":@"Refresh Quiz",
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
          @"com.kuhlmanation.hobnob.p_kit",
          @"com.kuhlmanation.hobnob.q_pack",
          @"com.kuhlmanation.hobnob.f_pack",
          @"com.kuhlmanation.hobnob.r_pack"];
  
  switch ([productIdentifiers indexOfObject:product.productIdentifier]) {
    case 0: //@"com.kuhlmanation.hobnob.p_kit"
      return @"Get them all at a discount.";
      break;
    case 1: //@"com.kuhlmanation.hobnob.q_pack",
      return @"Go beyond multiple choice with more question types.";
      break;
    case 2: //@"com.kuhlmanation.hobnob.f_pack"
      return @"Filter quizzes down to a specific company, school, industry, or location.";
      break;
    case 3: //@"com.kuhlmanation.hobnob.r_pack"
      return @"Refresh yourself on the people you know the worst.";
      break;
    default:
      return @"Upgrade your HobNobin' abilities"; 
      break;
  }
}

+ (UIImage *)iconWithProduct:(SKProduct *)product{
  
  NSArray *productIdentifiers =
  @[
    @"com.kuhlmanation.hobnob.p_kit",
    @"com.kuhlmanation.hobnob.q_pack",
    @"com.kuhlmanation.hobnob.f_pack",
    @"com.kuhlmanation.hobnob.r_pack"];
  
  switch ([productIdentifiers indexOfObject:product.productIdentifier]) {
    case 0: //@"com.kuhlmanation.hobnob.p_kit"
      return [UIImage imageNamed:@"store_card_questiontypes"];
      break;
    case 1: //@"com.kuhlmanation.hobnob.q_pack"
      return [UIImage imageNamed:@"store_card_questiontypes"];
      break;
    case 2: //@"com.kuhlmanation.hobnob.f_pack"
      return [UIImage imageNamed:@"store_card_quizfilters"];
      break;
    case 3: //@"com.kuhlmanation.hobnob.r_pack"
      return [UIImage imageNamed:@"store_card_refreshquiz"];
      break;
    default:
      return [UIImage imageNamed:@"store_card_refreshquiz"];
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
