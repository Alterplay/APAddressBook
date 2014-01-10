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

+ (BOOL)isPermissionsDetermined
{
    return ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusNotDetermined;
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
                ABMultiValueRef phonesValueRef = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
                NSUInteger phonesCount = (NSUInteger)ABMultiValueGetCount(phonesValueRef);
                NSMutableArray *phones = [[NSMutableArray alloc] init];
                for (NSUInteger j = 0; j < phonesCount; j++)
                {
                    CFTypeRef value = ABMultiValueCopyValueAtIndex(phonesValueRef, j);
                    NSString *number = (__bridge_transfer NSString *)value;
                    if (number)
                    {
                        [phones addObject:number];
                    }
                };
                CFRelease(phonesValueRef);
                CFTypeRef valueRef = (ABRecordCopyValue(recordRef, kABPersonFirstNameProperty));
                NSString *firstName = (__bridge_transfer NSString *)valueRef;
                valueRef = (ABRecordCopyValue(recordRef, kABPersonLastNameProperty));
                NSString *lastName = (__bridge_transfer NSString *)valueRef;
                APContact *contact = [[APContact alloc] init];
                contact.phones = phones;
                contact.firstName = firstName;
                contact.lastName = lastName;
                [contacts addObject:contact];
            }
            array = [NSArray arrayWithArray:contacts];
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

@end
