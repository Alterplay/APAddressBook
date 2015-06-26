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
@property (nullable, nonatomic, copy) APContactFilterBlock filterBlock;
@property (nullable, nonatomic, strong) NSArray *sortDescriptors;

+ (APAddressBookAccess)access;
+ (void)requestAccess:(nullable void (^)(BOOL granted,  NSError * __nullable  error))completionBlock;
+ (void)requestAccessOnQueue:(nonnull dispatch_queue_t)queue
                  completion:(nullable void (^)(BOOL granted, NSError * __nullable error))completionBlock;

- (void)loadContacts:(nullable void (^)(NSArray * __nullable contacts, NSError * __nullable error))completionBlock;
- (void)loadContactsOnQueue:(nonnull dispatch_queue_t)queue
                 completion:(nullable void (^)(NSArray * __nullable contacts, NSError * __nullable error))completionBlock;

- (void)startObserveChangesWithCallback:(nullable void (^)())callback;
- (void)stopObserveChanges;

- (nullable APContact *)getContactByRecordID:(nonnull NSNumber *)recordID;

@end
