//
//  QIStoreTableHeaderView.h
//  QuizIn
//
//  Created by Rick Kuhlman on 7/28/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QIStoreTableHeaderView : UIView

@property (nonatomic, strong) UIButton *buyAllButton;
@property (nonatomic, strong) UILabel *bestOfferLabel;
@property (nonatomic, strong) UILabel *buyAllPriceLabel;
@property (nonatomic, strong) NSString *allPrice; 
@property (nonatomic, strong) UIImageView *checkmark;
@property (nonatomic, assign) BOOL allPurchased;

@end
