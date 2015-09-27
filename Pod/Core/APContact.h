//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "APTypes.h"

@interface APContact : NSObject

@property (nonatomic, readonly) APContactField fieldMask;
@property (nullable, nonatomic, readonly) NSString *firstName;
@property (nullable, nonatomic, readonly) NSString *middleName;
@property (nullable, nonatomic, readonly) NSString *lastName;
@property (nullable, nonatomic, readonly) NSString *compositeName;
@property (nullable, nonatomic, readonly) NSString *company;
@property (nullable, nonatomic, readonly) NSString *jobTitle;
@property (nullable, nonatomic, readonly) NSArray *phones;
@property (nullable, nonatomic, readonly) NSArray *phonesWithLabels;
@property (nullable, nonatomic, readonly) NSArray *emails;
@property (nullable, nonatomic, readonly) NSArray *addresses;
@property (nullable, nonatomic, readonly) UIImage *photo;
@property (nullable, nonatomic, readonly) UIImage *thumbnail;
@property (nullable, nonatomic, readonly) NSNumber *recordID;
@property (nullable, nonatomic, readonly) NSDate *creationDate;
@property (nullable, nonatomic, readonly) NSDate *modificationDate;
@property (nullable, nonatomic, readonly) NSArray *socialProfiles;
@property (nullable, nonatomic, readonly) NSString *note;
@property (nullable, nonatomic, readonly) NSArray *linkedRecordIDs;

- (nonnull id)initWithRecordRef:(nonnull ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

@end
