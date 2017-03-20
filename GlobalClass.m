//
//  GlobalClass.m
//  Sportalizer
//
//  Created by Admin on 16/01/17.
//  Copyright © 2017 Test. All rights reserved.
//

#import "GlobalClass.h"



@implementation GlobalClass

@synthesize IsSplashLoad,appDelegateTemp;
static GlobalClass * _sharedInstance = nil;

+(GlobalClass *)sharedInstance
{
    @synchronized([GlobalClass class])
    {
        if (!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

- (id)init {
    if (self = [super init]) {
        IsSplashLoad = false;
        appDelegateTemp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}



-(void)CustomTextField:(UITextField*)TextField
{
    [TextField setBackgroundColor:[UIColor whiteColor]];
    TextField.layer.opacity = 1.0;
    TextField.layer.borderWidth = 1.0;
    TextField.layer.borderColor = [UIColor grayColor].CGColor;
    TextField.layer.cornerRadius = 20;
    UIColor *color = [UIColor grayColor];
    TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:TextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    TextField.rightViewMode = UITextFieldViewModeAlways;
    TextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}

-(void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    
    [alert addAction:yesButton];
    
    [appDelegateTemp.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)validateString:(NSString*)stringToSearch withRegex:(NSString*)regexString {
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regex evaluateWithObject:stringToSearch];
}

-(NSMutableDictionary *)makeSportsArray:(NSString *)sportName  sportImg:(NSString *)sportImg
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:sportName forKey:@"name"];
    [dict setObject:sportImg forKey:@"img"];
    return dict;
}

- (NSData *)createBodyWithParameters:(NSDictionary *)parameters
                           fieldName:(NSString *)fieldName
                               image:(UIImage *)image
                            boundary:(NSString *)boundary
{
    NSMutableData *httpBody = [NSMutableData data];
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    if (image) {
        NSString *filename  = @"image.png";
        NSData   *data      = UIImageJPEGRepresentation(image, 0.5);
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

-(BOOL)isNetworkRechable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[GlobalClass alloc] hideLoading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Unable to connect to the Internet"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
}


-(NSString*)GetDocPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    return docsPath;
}



-(NSString *)localizeString:(NSString *)localeKey {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    NSString *localizedString = [languageBundle localizedStringForKey:localeKey value:@"" table:nil];
    
    return localizedString;
}



- (NSDictionary *) dictionaryByReplacingNullsWithStrings:(NSDictionary *)nullDict
{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: nullDict];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in nullDict)
    {
        const id object = [nullDict objectForKey: key];
        
        if (object == nul)
        {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]])
        {
            [replaced setObject: [self dictionaryByReplacingNullsWithStrings:object] forKey: key];
        }
        else
        {
            [replaced setObject:[NSString stringWithFormat:@"%@", object] forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

-(NSMutableArray *) arrayByReplacingNullsWithString:(NSMutableArray *) nullArray {
    
    for (int i = 0; i < [nullArray count]; i++) {
        
        [nullArray replaceObjectAtIndex:i withObject:[self dictionaryByReplacingNullsWithStrings:nullArray[i]]];
    }
    
    return nullArray;
}

- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSInteger) AdjustImageHeight:(NSInteger)Height Width:(NSInteger)Width UserWidth:(NSInteger)ModifiedWidth {
    return (ModifiedWidth * Height / Width);
}

-(NSInteger) AdjustImageWidth:(NSInteger)Height Width:(NSInteger)Width UserHeight:(NSInteger)ModifiedHeight {
    return (ModifiedHeight * Width / Height);
}

- (UIImage *) imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width {//method to scale image accordcing to width
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 0);
    
  //  UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaleImage:(UIImage*)image by:(float)scale
{
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)saveImage: (UIImage*)image imagename:(NSString *)name
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat: @"%@.png", name]];
        //NSLog(@"Path %@",path);
        NSData* data = UIImagePNGRepresentation(image);
        
        [data writeToFile:path atomically:YES];
    }
}
-(void) showLoadingWithView:(UIView *) view1 withLabel:(NSString *)lblString {
    
    [DejalBezelActivityView activityViewForView:view1 withLabel:lblString];
}
-(void) hideLoading {
    
    [DejalBezelActivityView removeViewAnimated:YES];
}
- (BOOL) CheckError:(NSError*)error
{
    if (error) {
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@", [error localizedDescription]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [Alert show];
        return YES;
    } else {
        return NO;
    }
}

-(NSString *)getTimeStamp:(NSString *)dateString
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [df dateFromString:dateString];
    
    NSTimeInterval since1970 = [date timeIntervalSince1970]; // January 1st 1970
    
    double result = since1970;
    
    double timeDiff = timeStamp - result;
    NSString *time;
    
    if (timeDiff < 60)
    {
        time = @"Just Now";
    }
    else if (timeDiff < 3600)
    {
        time = [NSString stringWithFormat:@"%.0f m ago",round(timeDiff/60)];
    }
    else if (timeDiff < 86400)
    {
        time = [NSString stringWithFormat:@"%.0f h ago",round(timeDiff/3600)];
    }
    else
    {
        time = [NSString stringWithFormat:@"%.0f d ago",round(timeDiff/86400)];
    }
    
    return time;
}

-(NSString *)getTimeStampWithSecond:(NSString *)dateString
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [df dateFromString:dateString];
    
    NSTimeInterval since1970 = [date timeIntervalSince1970]; // January 1st 1970
    
    double result = since1970;
    
    double timeDiff = timeStamp - result;
    NSString *time;
    
    if (timeDiff < 60)
    {
        time = @"Just Now";
    }
    else if (timeDiff < 3600)
    {
        time = [NSString stringWithFormat:@"%.0f m ago",round(timeDiff/60)];
    }
    else if (timeDiff < 86400)
    {
        time = [NSString stringWithFormat:@"%.0f h ago",round(timeDiff/3600)];
    }
    else
    {
        time = [NSString stringWithFormat:@"%.0f d ago",round(timeDiff/86400)];
    }
    
    return time;
}

-(NSString *)ConvertDateFormate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //// here set format of date which is in your output date (means above str with format)
    
    NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    
    return convertedString;
}

-(NSString *)convertNSDateToNSString:(NSDate *)date dateFormate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formate];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(NSDate *)convertNSStringToNSDate:(NSString *)string dateFormate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formate];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}
/*
#pragma mark - InApp Purchase Delegate Methods
-(void)fetchAvailableProducts:(NSMutableArray*)ArrMetadataList1 {
    ArrMetadataList = ArrMetadataList1;
    if ([ArrMetadataList count]==0) return;
    NSSet *productIdentifiers = [[NSSet alloc] initWithArray:[NSArray arrayWithArray:[ArrMetadataList copy]]];
    
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

// For update the download progress in iOS.
-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    // SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count > 0) {
        validProducts = response.products;
        NSMutableArray *DisplayData = [[NSMutableArray alloc] init];
        for (int i = 0; i<count; i++)
        {
            SKProduct *Product1 = [[SKProduct alloc] init];
            Product1 = [validProducts objectAtIndex:i];
            NSMutableDictionary *Data = [[NSMutableDictionary alloc] init];
            [Data setObject:[NSString stringWithFormat:@"%@", Product1.localizedTitle] forKey:@"localizedTitle"];
            [Data setObject:[NSString stringWithFormat:@"%@", Product1.productIdentifier] forKey:@"productIdentifier"];
            [DisplayData addObject:Data];
        }
        [[NSUserDefaults standardUserDefaults] setObject:DisplayData forKey:@"DisplayName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableReload" object:validProducts];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RestorePurchase" object:validProducts];
        // [TblList reloadData];
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product {
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        [[GlobalClass sharedInstance] hideLoading];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void) ClkRestorePurchase
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(bool)CheckPurchased:(NSString*)Identifier {
    NSMutableArray *PurchaseData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedSongs"] mutableCopy];
    for (int i = 0; i<[PurchaseData count]; i++)
        if ([Identifier isEqualToString:[PurchaseData objectAtIndex:i]])
            return true;
    return false;
}

#pragma mark StoreKit Delegate
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[GlobalClass sharedInstance] hideLoading];
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Restore purchase completed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [Alert show];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    bool isAllDownloaded = false;
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateRestored: {
                bool IsPurchased = false;
                if ([self CheckPurchased:transaction.payment.productIdentifier]) {
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    IsPurchased = true;
                }
                if(IsPurchased) break;
                isAllDownloaded = true;
                if ([transaction.payment.productIdentifier
                     isEqualToString:@"com.cearsinfotech.UserSubscribe"]) {
                    NSLog(@"Purchased: %@", transaction.payment.productIdentifier);
                }
                if (transaction.downloads != nil && transaction.downloads > 0) {
                    
                    // Purchase complete, and it has downloads... so download them!
                    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
                    //                    SKPaymentQueue.DefaultQueue.StartDownloads (transaction.downloads);
                    // CompleteTransaction() call has moved after downloads complete
                } else {
                    // complete the transaction now
                    //                    theManager.CompleteTransaction(transaction);
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }
                break;
            }
            case SKPaymentTransactionStatePurchased:
            {
                
                bool IsPurchased = false;
                if ([self CheckPurchased:transaction.payment.productIdentifier]) {
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    IsPurchased = true;
                }
                if(IsPurchased) break;
                isAllDownloaded = true;
                if ([transaction.payment.productIdentifier
                     isEqualToString:@"com.cearsinfotech.UserSubscribe"]) {
                    NSLog(@"Purchased: %@", transaction.payment.productIdentifier);
                }
                if (transaction.downloads != nil && transaction.downloads > 0) {
                    // Purchase complete, and it has downloads... so download them!
                    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
                    //                    SKPaymentQueue.DefaultQueue.StartDownloads (transaction.downloads);
                    // CompleteTransaction() call has moved after downloads complete
                } else {
                    // complete the transaction now
                    //                    theManager.CompleteTransaction(transaction);
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"Identifier Failed %@", transaction.transactionIdentifier);
                [[Glo	balClass sharedInstance] hideLoading];
                NSInteger iLoop = [self GetSongIndex:transaction.payment.productIdentifier];
                NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%d", iLoop], @"Value":@"0"};
                
                // Reload cell
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TableReload" object:validProducts];
                // [queue cancelDownloads:transaction.downloads];
                [queue finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateDeferred:
                break;
            default:
                break;
        }
    }
    
    if (!isAllDownloaded) [[GlobalClass sharedInstance] hideLoading];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads;
{
    for (SKDownload *download in downloads) {
        if (download.downloadState == SKDownloadStateFinished) {
            bool Status = true;
            if ([self CheckPurchased:download.contentIdentifier]) {
                NSInteger iLoop = [self GetSongIndex:download.contentIdentifier];
                NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%d", iLoop], @"Value":@"0"};
                
                // Reload cell
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
                
                [[GlobalClass sharedInstance] hideLoading];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TableReload" object:validProducts];
                [queue finishTransaction:download.transaction];
                Status = false;
            }
            if (!Status) break;
            NSString* srcPath = [[download.contentURL relativePath] stringByAppendingPathComponent:@"Contents"];
            [queue finishTransaction:download.transaction];
            if ([NSURL URLWithString:srcPath] == nil) return;
            
            // Get list of files from cache
            NSFileManager *fm = [NSFileManager defaultManager];
            NSArray * dirContents =
            [fm contentsOfDirectoryAtURL:[NSURL URLWithString:srcPath] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
            if (dirContents == nil) return;
            //            NSString *SongFolderName = [[download.contentIdentifier componentsSeparatedByString:@"."] lastObject];
            NSString *SongFolderName = download.contentIdentifier;
            NSString *ToFilePath = [NSString stringWithFormat:@"%@/songs/%@/", [[GlobalClass sharedInstance] GetDocPath], SongFolderName];
            NSError *Error;
            if(![[NSFileManager defaultManager] fileExistsAtPath:ToFilePath]) [[NSFileManager defaultManager] createDirectoryAtPath:ToFilePath
                                                                                                        withIntermediateDirectories:YES
                                                                                                                         attributes:nil
                                                                                                                              error:&Error];
            bool IsError = false;
            
            if (Error != nil) IsError = YES;
            NSString *ToFilePath1 = [NSString stringWithFormat:@"%@/songs/%@", [[GlobalClass sharedInstance] GetDocPath], SongFolderName];
            for (int i = 0; i< [dirContents count]; i++) {
                NSURL *s = [dirContents objectAtIndex:i];
                NSString *sd = s.relativePath;
                
                NSString *FileName = [[sd componentsSeparatedByString:@"/"] lastObject];
                NSString *ToFilePath2 = [NSString  stringWithFormat:@"%@/%@", ToFilePath1, FileName];
                
                if ([fm fileExistsAtPath:ToFilePath2] == NO) {
                    [fm copyItemAtPath:sd toPath:ToFilePath2 error:&Error];
                    if (Error != nil) {
                        if (Error != nil) IsError = YES;
                    }
                }
            }
            
            if (!IsError) {
                NSMutableArray *PurchaseData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedSongs"] mutableCopy];
                if (PurchaseData == nil) PurchaseData = [[NSMutableArray alloc] init];
                [PurchaseData addObject:[NSString stringWithFormat:@"%@", download.contentIdentifier]];
                [[NSUserDefaults standardUserDefaults] setObject:PurchaseData forKey:@"PurchasedSongs"];
            }
            
            NSInteger iLoop = [self GetSongIndex:download.contentIdentifier];
            NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%d", iLoop], @"Value":@"0"};
            
            // Reload cell
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
            
            [[GlobalClass sharedInstance] hideLoading];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TableReload" object:validProducts];
//            [self GetSongList];
        } else if (download.downloadState == SKDownloadStateActive) {
            NSString *productID = download.contentIdentifier; // in app purchase identifier
            NSTimeInterval remaining = download.timeRemaining; // secs
            float progress = download.progress; // 0.0 -> 1.0
            NSInteger iLoop = [self GetSongIndex:download.contentIdentifier];
            NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%ld", (long)iLoop], @"Value":[NSString stringWithFormat:@"%f", progress]};
            
            // If Song already downloaded than skip
            if ([self CheckPurchased:download.contentIdentifier]) {
                NSDictionary *Data1 = @{@"Row":[NSString stringWithFormat:@"%ld", (long)iLoop], @"Value":@"0"};
                Data = Data1;
                [queue finishTransaction:download.transaction];
            }
            
            // Reload cell
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
        } else if (download.downloadState == SKDownloadStateCancelled) {
            [queue cancelDownloads:download.transaction];
            [[GlobalClass sharedInstance] hideLoading];
            
            NSInteger iLoop = [self GetSongIndex:download.contentIdentifier];
            NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%d", iLoop], @"Value":@"0"};
            
            // Reload cell
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
        } else if (download.downloadState == SKDownloadStateFailed) {
            [queue cancelDownloads:download.transaction];
            [[GlobalClass sharedInstance] hideLoading];
            
            NSInteger iLoop = [self GetSongIndex:download.contentIdentifier];
            NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%d", iLoop], @"Value":@"0"};
            
            // Reload cell
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
            
        } else {    // waiting, paused
            NSInteger iLoop = [self GetSongIndex:download.contentIdentifier];
            NSDictionary *Data = @{@"Row":[NSString stringWithFormat:@"%d", iLoop], @"Value":@"0"};
            
            // Reload cell
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CellReload" object:Data];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
}

-(NSInteger)GetSongIndex:(NSString*)Identifier {
    return [ArrMetadataList indexOfObject:Identifier];
}

-(void)AddDownLoad:(NSString*)Identifier {
    [ActiveDownload addObject:Identifier];
}

-(void)RemoveDownload:(NSString*)Identifier {
    [ActiveDownload removeObject:Identifier];
} */

- (NSInteger)getAge:(NSDate*)date
{
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:date
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    AppDelegate *appDelegateTemp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIViewController *navigation = (UIViewController*) viewController;
    [appDelegateTemp.window.rootViewController.navigationController pushViewController:navigation animated:YES];
    
}


- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (CGFloat)getLabelWidth:(UILabel*)label
{
    CGSize constraint = CGSizeMake(CGFLOAT_MAX, label.frame.size.height);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.width+20;
}

-(UIImage *)takeScreenshotof:(CGRect)rect containView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef img = [viewImage CGImage];
    img = CGImageCreateWithImageInRect(img, rect);  // This is the specific frame size whatever you want to take scrrenshot
    viewImage = [UIImage imageWithCGImage:img];
    
    return viewImage;
}

- (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned int hex;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (NSString *)hexStringWithColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}
@end
