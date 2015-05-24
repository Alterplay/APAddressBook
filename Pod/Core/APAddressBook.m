//
//  APAddressBook.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "APAddressBook.h"
#import "APContact.h"

void APAddressBookExternalChangeCallback(ABAddressBookRef addressBookRef, CFDictionaryRef info,
                                         void *context);

@interface APAddressBook ()
@property (nonatomic, readonly) ABAddressBookRef addressBook;
@property (nonatomic, readonly) dispatch_queue_t localQueue;
@property (nonatomic, copy) void (^changeCallback)();
@end

@implementation APAddressBook

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.fieldsMask = APContactFieldDefault;
        NSString *name = [NSString stringWithFormat:@"com.alterplay.addressbook.%ld",
                                   (long)self.hash];
        _localQueue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
        CFErrorRef *error = NULL;
        dispatch_sync(self.localQueue, ^
        {
            _addressBook = ABAddressBookCreateWithOptions(NULL, error);
        });
        if (error)
        {
            NSString *errorReason = (__bridge_transfer NSString *)CFErrorCopyFailureReason(*error);
            NSLog(@"APAddressBook initialization error:\n%@", errorReason);
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    [self stopObserveChanges];
    dispatch_sync(self.localQueue, ^
    {
        if (_addressBook)
        {
            CFRelease(_addressBook);
        }
    });
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_localQueue);
#endif
}

#pragma mark - public

+ (APAddressBookAccess)access
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status)
    {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
            return APAddressBookAccessDenied;

        case kABAuthorizationStatusAuthorized:
            return APAddressBookAccessGranted;

        default:
            return APAddressBookAccessUnknown;
    }
}

- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock
{
    [self loadContactsOnQueue:dispatch_get_main_queue() completion:callbackBlock];
}

- (void)loadContactsOnQueue:(dispatch_queue_t)queue
                 completion:(void (^)(NSArray *contacts, NSError *error))completionBlock
{
    APContactField fieldMask = self.fieldsMask;
    NSArray *descriptors = self.sortDescriptors;
    APContactFilterBlock filterBlock = self.filterBlock;

    dispatch_async(self.localQueue, ^
    {
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef errorRef)
        {
            NSArray *array = nil;
            NSError *error = nil;
            if (granted)
            {
                __block CFArrayRef peopleArrayRef;
                dispatch_sync(self.localQueue, ^
                {
                    peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
                });
                NSUInteger contactCount = (NSUInteger)CFArrayGetCount(peopleArrayRef);
                NSMutableArray *contacts = [[NSMutableArray alloc] init];
                for (NSUInteger i = 0; i < contactCount; i++)
                {
                    ABRecordRef recordRef = CFArrayGetValueAtIndex(peopleArrayRef, i);
                    APContact *contact = [[APContact alloc] initWithRecordRef:recordRef
                                                                    fieldMask:fieldMask];
                    if (!filterBlock || filterBlock(contact))
                    {
                        [contacts addObject:contact];
                    }
                }
                [contacts sortUsingDescriptors:descriptors];
                array = contacts.copy;
                CFRelease(peopleArrayRef);
            }
            else if (errorRef)
            {
                error = (__bridge NSError *)errorRef;
            }

            dispatch_async(queue, ^
            {
                if (completionBlock)
                {
                    completionBlock(array, error);
                }
            });
        });
    });
}

- (void)startObserveChangesWithCallback:(void (^)())callback
{
    if (callback)
    {
        if (!self.changeCallback)
        {
            dispatch_async(self.localQueue, ^
            {
                ABAddressBookRegisterExternalChangeCallback(self.addressBook,
                                                            APAddressBookExternalChangeCallback,
                                                            (__bridge void *)(self));
            });
        }
        self.changeCallback = callback;
    }
}

- (void)stopObserveChanges
{
    if (self.changeCallback)
    {
        self.changeCallback = nil;
        dispatch_async(self.localQueue, ^
        {
            ABAddressBookUnregisterExternalChangeCallback(self.addressBook,
                                                          APAddressBookExternalChangeCallback,
                                                          (__bridge void *)(self));
        });
    }
}

- (APContact *)getContactByRecordID:(NSNumber *)recordID
{
    __block APContact *contact = nil;
    dispatch_sync(self.localQueue, ^
    {
        ABRecordRef ref = ABAddressBookGetPersonWithRecordID(self.addressBook, recordID.intValue);
        if (ref != NULL)
        {
            contact = [[APContact alloc] initWithRecordRef:ref fieldMask:self.fieldsMask];
        }
    });
    return contact;
}

#pragma mark - external change callback

void APAddressBookExternalChangeCallback(ABAddressBookRef __unused addressBookRef,
                                         CFDictionaryRef __unused info,
                                         void *context)
{
    ABAddressBookRevert(addressBookRef);
    APAddressBook *addressBook = (__bridge APAddressBook *)(context);
    addressBook.changeCallback ? addressBook.changeCallback() : nil;
}

@end
