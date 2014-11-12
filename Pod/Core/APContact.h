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
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *middleName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *compositeName;
@property (nonatomic, readonly) NSString *company;
@property (nonatomic, readonly) NSArray *phones;
@property (nonatomic, readonly) NSArray *phonesWithLabels;
@property (nonatomic, readonly) NSArray *emails;
@property (nonatomic, readonly) NSArray *addresses;
@property (nonatomic, readonly) UIImage *photo;
@property (nonatomic, readonly) UIImage *thumbnail;
@property (nonatomic, readonly) NSNumber *recordID;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSDate *modificationDate;
@property (nonatomic, readonly) NSArray *socialProfiles;
@property (nonatomic, readonly) NSString *note;

- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

@end
