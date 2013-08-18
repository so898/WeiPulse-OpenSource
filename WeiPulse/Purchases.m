//
//  Purchases.m
//  WeiPulse
//
//  Created by so898 on 12-8-22.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//


#import "Purchases.h"
#import "VerificationController.h"
#define Upgrade @"UpgradeToPro"

@implementation Purchases

-(id)init
{
    if ((self = [super init])) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(void)buy
{
    if ([SKPaymentQueue canMakePayments]) {
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self RequestProductData];
        NSLog(@"允许程序内付费购买");
    }
    else
    {
        NSLog(@"不允许程序内付费购买");
        /*UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"You can‘t purchase in app store（Himi说你没允许应用程序内购买）"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
        [alerView show];*/
        if ([self.delegate respondsToSelector:@selector(Stop)]){
            [self.delegate performSelector:@selector(Stop)];
        }
    }
}

-(bool)CanMakePay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = [[NSArray alloc] initWithObjects:Upgrade,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
}

//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"没有激活的产品:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    
    if ([self.delegate respondsToSelector:@selector(Info)])
        [self.delegate performSelector:@selector(Info)];
}

- (void) confirm:(BOOL)a
{
    if (a){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:Upgrade];
        NSLog(@"---------发送购买请求------------");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    if ([self.delegate respondsToSelector:@selector(Error:)]){
        [self.delegate performSelector:@selector(Error:) withObject:[error localizedDescription]];
    }
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                {
                    [self completeTransaction:transaction];
                }
                break;
            case SKPaymentTransactionStateFailed://交易失败
                {
                    [self failedTransaction:transaction];
                    [self two];
                }
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                {
                    [self restoreTransaction:transaction];
                    NSLog(@"-----已经购买过该商品 --------");
                }
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}

- (void)one
{
    NSLog(@"-----交易完成 --------");
    /*UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Himi说你购买成功啦～娃哈哈"
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
    
    [alerView show];*/
    if ([self.delegate respondsToSelector:@selector(Done)]){
        [self.delegate performSelector:@selector(Done)];
    }
}

- (void)two
{
    NSLog(@"-----交易失败 --------");
    /*UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Himi说你购买失败，请重新尝试购买～"
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
    
    [alerView2 show];*/
    if ([self.delegate respondsToSelector:@selector(Fail)]){
        [self.delegate performSelector:@selector(Fail)];
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
    if (![[VerificationController sharedInstance] verifyPurchase:transaction]){
        [self two];
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        return;
    }
    [self one];
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    //[self two];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    [self one];
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}


#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

@end
