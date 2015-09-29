//
//  APAddressBook.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APAddressBook.h"
#import "APAddressBookAccessRoutine.h"
#import "APAddressBookContactsRoutine.h"
#import "APAddressBookExternalChangeRoutine.h"
#import "APAddressBookRefWrapper.h"
#import "APThread.h"
#import "NSArray+APAddressBook.h"

@interface APAddressBook () <APAddressBookExternalChangeDelegate>
@property (nonatomic, strong) APAddressBookAccessRoutine *access;
@property (nonatomic, strong) APAddressBookContactsRoutine *contacts;
@property (nonatomic, strong) APAddressBookExternalChangeRoutine *externalChange;
@property (nonatomic, strong) APThread *thread;
@property (atomic, copy) void (^externalChangeCallback)();
@property (atomic, strong) dispatch_queue_t externalChangeQueue;
@end

@implementation APAddressBook

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    self.fieldsMask = APContactFieldDefault;
    self.thread = [[APThread alloc] init];
    [self.thread start];
    [self.thread dispatchAsync:^
    {
        APAddressBookRefWrapper *refWrapper = [[APAddressBookRefWrapper alloc] init];
        if (!refWrapper.error)
        {
            self.access = [[APAddressBookAccessRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
            self.contacts = [[APAddressBookContactsRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
            self.externalChange = [[APAddressBookExternalChangeRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
            self.externalChange.delegate = self;
        }
        else
        {
            NSLog(@"APAddressBook initialization error:\n%@", refWrapper.error);
        }
    }];
    return self;
}

- (void)dealloc
{
    [self.thread cancel];
}

#pragma mark - public

+ (APAddressBookAccess)access
{
    return [APAddressBookAccessRoutine accessStatus];
}

+ (void)requestAccess:(APRequestAccessBlock)completionBlock
{
    [self requestAccessOnQueue:dispatch_get_main_queue() completion:completionBlock];
}

+ (void)requestAccessOnQueue:(dispatch_queue_t)queue completion:(APRequestAccessBlock)completionBlock
{
    APAddressBookRefWrapper *refWrapper = [[APAddressBookRefWrapper alloc] init];
    APAddressBookAccessRoutine *access = [[APAddressBookAccessRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
    [access requestAccessWithCompletion:^(BOOL granted, NSError *error)
    {
        dispatch_async(queue, ^
        {
            completionBlock ? completionBlock(granted, error) : nil;
        });
    }];
}

- (void)loadContacts:(APLoadContactsBlock)completionBlock
{
    [self loadContactsOnQueue:dispatch_get_main_queue() completion:completionBlock];
}

- (void)loadContactsOnQueue:(dispatch_queue_t)queue completion:(APLoadContactsBlock)completionBlock
{
    NSArray *descriptors = self.sortDescriptors;
    APFilterContactsBlock filterBlock = self.filterBlock;
    APContactField fieldMask = self.fieldsMask;
    [self.thread dispatchAsync:^
    {
        [self.access requestAccessWithCompletion:^(BOOL granted, NSError *error)
        {
            [self.thread dispatchAsync:^
            {
                NSArray *contacts = granted ? [self.contacts allContactsWithContactFieldMask:fieldMask] : nil;
                contacts = [contacts filteredArrayWithBlock:filterBlock sortedWithDescriptors:descriptors];
                dispatch_async(queue, ^
                {
                    completionBlock ? completionBlock(contacts, error) : nil;
                });
            }];
        }];
    }];
}

- (void)loadContactByRecordId:(nonnull NSNumber *)recordID
                   completion:(nonnull APLoadContactBlock)completion
{
    [self loadContactByRecordId:recordID onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)loadContactByRecordId:(nonnull NSNumber *)recordID
                      onQueue:(nonnull dispatch_queue_t)queue
                   completion:(nonnull APLoadContactBlock)completion
{
    [self.thread dispatchAsync:^
    {
        APContact *contact = [self.contacts contactByRecordID:recordID
                                                withFieldMask:self.fieldsMask];
        dispatch_async(queue, ^
        {
            completion ? completion(contact) : nil;
        });
    }];
}

- (void)startObserveChangesWithCallback:(void (^)())callback
{
    [self startObserveChangesOnQueue:dispatch_get_main_queue() callback:callback];
}

- (void)startObserveChangesOnQueue:(dispatch_queue_t)queue callback:(void (^)())callback
{
    self.externalChangeCallback = callback;
    self.externalChangeQueue = queue;
}

- (void)stopObserveChanges
{
    self.externalChangeCallback = nil;
    self.externalChangeQueue = nil;
}

#pragma mark - APAddressBookExternalChangeDelegate

- (void)addressBookDidChange
{
    dispatch_queue_t queue = self.externalChangeQueue ?: dispatch_get_main_queue();
    dispatch_async(queue, ^
    {
        self.externalChangeCallback ? self.externalChangeCallback() : nil;
    });
}

#pragma mark - deprecated

- (nullable APContact *)getContactByRecordID:(NSNumber *)recordID
{
    APContactField fieldMask = self.fieldsMask;
    __block APContact *contact = nil;
    [self.thread dispatchSync:^
    {
        contact = [self.contacts contactByRecordID:recordID withFieldMask:fieldMask];
    }];
    return contact;
}

@end
