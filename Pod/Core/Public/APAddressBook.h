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
typedef BOOL(^APFilterContactsBlock)(APContact * _Nonnull contact);
typedef void(^APLoadContactsBlock)(NSArray <APContact *> * _Nullable contacts, NSError * _Nullable error);
typedef void(^APRequestAccessBlock)(BOOL granted, NSError * _Nullable error);

@interface APAddressBook : NSObject

@property (nonatomic, assign) APContactField fieldsMask;
@property (nullable, nonatomic, copy) APFilterContactsBlock filterBlock;
@property (nullable, nonatomic, strong) NSArray <NSSortDescriptor *> *sortDescriptors;

+ (APAddressBookAccess)access;
+ (void)requestAccess:(nonnull APRequestAccessBlock)completionBlock;
+ (void)requestAccessOnQueue:(nonnull dispatch_queue_t)queue
                  completion:(nonnull APRequestAccessBlock)completionBlock;
- (void)loadContacts:(nonnull APLoadContactsBlock)completionBlock;
- (void)loadContactsOnQueue:(nonnull dispatch_queue_t)queue
                 completion:(nonnull APLoadContactsBlock)completionBlock;
- (void)startObserveChangesWithCallback:(nonnull void (^)())callback;
- (void)startObserveChangesOnQueue:(nonnull dispatch_queue_t)queue
                          callback:(nonnull void (^)())callback;
- (void)stopObserveChanges;

- (nullable APContact *)getContactByRecordID:(nonnull NSNumber *)recordID;

@end