//
//  APContactDataExtractor 
//  AddressBook
//
//  Created by Alexey Belkevich on 22.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface APContactDataExtractor : NSObject

@property (nonatomic, assign) ABRecordRef recordRef;

- (NSString *)stringProperty:(ABPropertyID)property;
- (NSArray *)arrayProperty:(ABPropertyID)property;
- (NSDate *)dateProperty:(ABPropertyID)property;
- (UIImage *)imagePropertyFullSize:(BOOL)isFullSize;
- (NSArray *)phonesWithLabels;
- (NSArray *)addresses;
- (NSString *)compositeName;
- (NSArray *)socialProfiles;
- (NSArray *)linkedRecordIDs;

@end