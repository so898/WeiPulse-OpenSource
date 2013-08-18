//
//  Purchases.h
//  WeiPulse
//
//  Created by so898 on 12-8-22.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol PurchasesDelegate;
@interface Purchases :NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    
}

@property (nonatomic, weak) id <PurchasesDelegate> delegate;

- (void) requestProUpgradeProductData;
- (void) RequestProductData;
- (bool) CanMakePay;
- (void) buy;
- (void) confirm:(BOOL)a;
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) PurchasedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;
- (void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent:(NSString *)product;
- (void) recordTransaction:(NSString *)product;
@end
@protocol PurchasesDelegate <NSObject>
- (void)Done;
- (void)Restore;
- (void)Fail;
- (void)Stop;
- (void)Info;
- (void)Error:(NSString *)type;
@end

