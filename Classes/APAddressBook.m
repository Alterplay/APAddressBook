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

@interface APAddressBook ()
@property (nonatomic, readonly) ABAddressBookRef addressBook;
@end

@implementation APAddressBook

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        CFErrorRef *error = NULL;
        _addressBook = ABAddressBookCreateWithOptions(NULL, error);
        if (error)
        {
            NSLog(@"%@", CFErrorCopyFailureReason(*error));
        }
    }
    return self;
}

- (void)dealloc
{
    if (_addressBook)
    {
        CFRelease(_addressBook);
    }
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
    __weak __typeof (self) weakSelf = self;
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef errorRef)
    {
        NSArray *array = nil;
        NSError *error = nil;
        if (granted)
        {
            CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(weakSelf.addressBook);
            NSUInteger contactCount = (NSUInteger)CFArrayGetCount(peopleArrayRef);
            NSMutableArray *contacts = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < contactCount; i++)
            {
                ABRecordRef recordRef = CFArrayGetValueAtIndex(peopleArrayRef, i);
                APContact *contact = [[APContact alloc] init];
                contact.firstName = [APAddressBook firstNameFromRecord:recordRef];
                contact.lastName = [APAddressBook lastNameFromRecord:recordRef];
                contact.phones = [APAddressBook phonesFromRecord:recordRef];
                [contacts addObject:contact];
            }
            array = contacts.copy;
        }
        else if (errorRef)
        {
            error = (__bridge NSError *)errorRef;
        }

        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (callbackBlock)
            {
                callbackBlock(array, error);
            }
        });
    });
}

#pragma mark - private

+ (NSString *)firstNameFromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, kABPersonFirstNameProperty));
    return (__bridge_transfer NSString *)valueRef;
}

+ (NSString *)lastNameFromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, kABPersonLastNameProperty));
    return (__bridge_transfer NSString *)valueRef;
}

+ (NSArray *)phonesFromRecord:(ABRecordRef)recordRef
{
    ABMultiValueRef phonesValueRef = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
    NSUInteger phonesCount = (NSUInteger)ABMultiValueGetCount(phonesValueRef);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < phonesCount; i++)
    {
        CFTypeRef value = ABMultiValueCopyValueAtIndex(phonesValueRef, i);
        NSString *number = (__bridge_transfer NSString *)value;
        if (number)
        {
            [phones addObject:number];
        }
    }
    CFRelease(phonesValueRef);
    return phones.copy;
}

@end
