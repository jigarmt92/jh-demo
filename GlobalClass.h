//
//  CommonClass.h
//  Ecommerce
//
//  Created by Apple on 02/05/16.
//  Copyright © 2016 cears infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DejalActivityView.h"


//#define SERVERNAME @"http://192.168.1.15/api.php"
//#define SERVERNAME @"http://demo.ipure-store.com/api.php"
//#define SERVERNAME @"http://www.ipure-store.com/api.php"

//#define SERVERNAME @"http://192.168.1.24/dfd.api/api"


#define     THEME_COLOR     [UIColor colorWithRed:220/255.0f green:80/255.0f blue:20/255.0f alpha:1.0]

#define     TITLE_COLOR     [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]

#define     DESC_COLOR      [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0]

#define     CONTRAST_COLOR      [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0]

#define     SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define		SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define     HEXCOLOR(c)     [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define     RGB(r,g,b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//#define	COLOR_OUTGOING HEXCOLOR(0x007AFFFF)
//#define	COLOR_INCOMING HEXCOLOR(0xE6E5EAFF)

#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$" // 6 jex
#define REGEX_USER_NAME_LIMIT @"^.{1,20}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{1,20}"
#define REGEX_PASSWORD @"^(?!.*(.)\\1{3})((?=.*[\\d])(?=.*[A-Za-z])|(?=.*[^\\w\\d\\s])(?=.*[A-Za-z])).{6,20}$"
#define REGEX_PHONENUMBER @"[0-9-+()]{7,16}"
#define REGIX_NOTNULLNSPACE @""
#define REGEX_NUMBER @"[0-9.]{1,30}"
#define REGEX_AMOUNT @"[0-9]{1,30}"

@interface GlobalClass : NSObject
{
    
}

@property (nonatomic, strong) NSMutableDictionary *userDict;
@property (nonatomic, strong) NSMutableArray *cartArray;
@property (nonatomic, strong) NSString *companyAccountType;


+(GlobalClass *)sharedInstance;
-(BOOL)isNetworkRechable;
-(void) showLoadingWithView:(UIView *) view1 withLabel:(NSString *)lblString;
-(void) hideLoading;
- (BOOL)validateString:(NSString*)stringToSearch withRegex:(NSString*)regexString;
-(NSString *)localizeString:(NSString *)localeKey;
- (NSDictionary *) dictionaryByReplacingNullsWithStrings:(NSDictionary *)nullDict;
-(NSMutableArray *) arrayByReplacingNullsWithString:(NSMutableArray *) nullArray;
- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
-(NSDictionary*)UpdateCuisine:(NSDictionary *)jsonData UserId:(NSString*)UserId restID:(NSString*)RestID;
-(NSDictionary*)UpdateEstablishment:(NSDictionary *)jsonData UserId:(NSString*)UserId restID:(NSString*)RestID;
- (UIImage *)scaleAndRotateImage:(UIImage *) image isFrontCamera:(BOOL) IsFront;
@end
