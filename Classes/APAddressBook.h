//
//  APAddressBook.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    APAddressBookAccessUnknown = 0,
    APAddressBookAccessGranted = 1,
    APAddressBookAccessDenied = 2
} APAddressBookAccess;

@interface APAddressBook : NSObject

+ (APAddressBookAccess)access;
- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock;

@end
