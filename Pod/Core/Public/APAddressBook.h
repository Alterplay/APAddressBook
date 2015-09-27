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
typedef BOOL(^APContactFilterBlock)(APContact * _Nonnull contact);

@interface APAddressBook : NSObject

@property (nonatomic, assign) APContactField fieldsMask;
@property (nullable, nonatomic, copy) APContactFilterBlock filterBlock;
@property (nullable, nonatomic, strong) NSArray *sortDescriptors;

+ (APAddressBookAccess)access;
+ (void)requestAccess:(nullable void (^)(BOOL granted, NSError * _Nullable error))completionBlock;
+ (void)requestAccessOnQueue:(nonnull dispatch_queue_t)queue
                  completion:(nullable void (^)(BOOL granted, NSError * _Nullable error))completionBlock;
- (void)loadContacts:(nullable void (^)(NSArray * _Nullable contacts, NSError * _Nullable error))completionBlock;
- (void)loadContactsOnQueue:(nonnull dispatch_queue_t)queue
                 completion:(nullable void (^)(NSArray * _Nullable contacts, NSError * _Nullable error))completionBlock;

- (void)startObserveChangesWithCallback:(nonnull void (^)())callback;
- (void)startObserveChangesOnQueue:(nonnull dispatch_queue_t)queue callback:(nonnull void (^)())callback;
- (void)stopObserveChanges;

- (nullable APContact *)getContactByRecordID:(nonnull NSNumber *)recordID;

@end