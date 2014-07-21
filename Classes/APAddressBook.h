//
//  APAddressBook.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APTypes.h"

@class APContact;

@interface APAddressBook : NSObject

@property (nonatomic, assign) APContactField fieldsMask;
@property (nonatomic, copy) APContactFilterBlock filterBlock;
@property (nonatomic, strong) NSArray *sortDescriptors;

+ (APAddressBookAccess)access;

- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock;
- (void)loadContactsOnQueue:(dispatch_queue_t)queue
                 completion:(void (^)(NSArray *contacts, NSError *error))completionBlock;

- (void)startObserveChangesWithCallback:(void (^)())callback;
- (void)stopObserveChanges;

@end
