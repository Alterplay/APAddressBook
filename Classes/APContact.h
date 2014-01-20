//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "APTypes.h"

@interface APContact : NSObject

@property (nonatomic, readonly) APContactField fieldMask;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *company;
@property (nonatomic, readonly) NSArray *phones;
@property (nonatomic, readonly) NSArray *emails;
@property (nonatomic, readonly) UIImage *photo;
@property (nonatomic, readonly) UIImage *thumbnail;

- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

@end
