//
//  GlobalClass.h
//  Sportalizer
//
//  Created by Admin on 16/01/17.
//  Copyright © 2017 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <StoreKit/StoreKit.h>
#import "SBPickerSelector.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "Constants.h"
#import "DejalActivityView.h"
@interface GlobalClass : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver,UITabBarControllerDelegate,SBPickerSelectorDelegate>
{
    UIViewController *ViewController;
    
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
    NSMutableArray *ArrMetadataList;
    NSMutableArray *ActiveDownload;
}

@property (nonatomic) AppDelegate *appDelegateTemp;

@property (nonatomic,strong) NSMutableDictionary *locationDictionary;
@property (nonatomic) BOOL IsSplashLoad;
@property (nonatomic,strong) NSMutableDictionary *SignUpDictionary;
@property (nonatomic) NSMutableArray *CountryList,*StateList,*CityList;

+(GlobalClass *)sharedInstance;

-(void)CustomTextField:(UITextField*)TextField;
-(NSMutableDictionary *)makeSportsArray:(NSString *)sportName  sportImg:(NSString *)sportImg;
-(void)showAlert:(NSString *)title message:(NSString *)message;
- (BOOL)validateString:(NSString*)stringToSearch withRegex:(NSString*)regexString;
-(void)signInWithGoogle:(UIViewController *)ViewC;
-(void)TwitterLogin:(UIViewController *)vc;
-(NSMutableDictionary *)locationManagerMethod;
-(BOOL)isNetworkRechable;
-(void) showLoadingWithView:(UIView *) view1 withLabel:(NSString *)lblString;
-(void) hideLoading;
- (NSString *)mimeTypeForPath:(NSString *)path;
- (NSString *)generateBoundaryString;
- (BOOL) CheckError:(NSError*)error;
-(NSString*)GetDocPath;
- (NSDictionary *) dictionaryByReplacingNullsWithStrings:(NSDictionary *)nullDict;
-(NSMutableArray *) arrayByReplacingNullsWithString:(NSMutableArray *) nullArray;
- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
- (void)saveImage: (UIImage*)image imagename:(NSString *)name;
-(NSString *)getTimeStamp:(NSString *)dateString;
-(NSString *)ConvertDateFormate:(NSString *)dateString;
- (NSInteger)getAge:(NSDate*)date;
-(void)CreateTabBar;
-(NSString *)getTimeStampWithSecond:(NSString *)dateString;
- (CGFloat)getLabelHeight:(UILabel*)label;
- (CGFloat)getLabelWidth:(UILabel*)label;
-(UIImage *)takeScreenshotof:(CGRect)rect containView:(UIView *)view;
- (UIImage*)scaleImage:(UIImage*)image by:(float)scale;

- (NSData *)createBodyWithParameters:(NSDictionary *)parameters
                           fieldName:(NSString *)fieldName
                               image:(UIImage *)image
                            boundary:(NSString *)boundary;

-(NSInteger) AdjustImageHeight:(NSInteger)Height Width:(NSInteger)Width UserWidth:(NSInteger)ModifiedWidth;
-(NSInteger) AdjustImageWidth:(NSInteger)Height Width:(NSInteger)Width UserHeight:(NSInteger)ModifiedHeight;
- (UIImage *) imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
- (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)hexStringWithColor:(UIColor *)color;
-(NSString *)convertNSDateToNSString:(NSDate *)date dateFormate:(NSString *)formate;
-(NSDate *)convertNSStringToNSDate:(NSString *)string dateFormate:(NSString *)formate;

#pragma mark - In App methods
-(void)fetchAvailableProducts:(NSMutableArray*)ArrMetadataList;
-(void)ClkRestorePurchase;
- (void)purchaseMyProduct:(SKProduct*)product;

@end
