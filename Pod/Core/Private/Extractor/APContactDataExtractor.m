//
//  APContactDataExtractor 
//  AddressBook
//
//  Created by Alexey Belkevich on 22.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import "APContactDataExtractor.h"
#import "APPhoneWithLabel.h"
#import "APAddress.h"
#import "APSocialProfile.h"
#import "APSocialServiceHelper.h"

@implementation APContactDataExtractor

#pragma mark - public

- (NSString *)stringProperty:(ABPropertyID)property
{
    CFTypeRef valueRef = (ABRecordCopyValue(self.recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

- (NSArray *)arrayProperty:(ABPropertyID)property
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:property withBlock:^(ABMultiValueRef multiValue, CFIndex index)
    {
        CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, index);
        NSString *string = (__bridge_transfer NSString *)value;
        if (string)
        {
            [array addObject:string];
        }
    }];
    return array.copy;
}

- (NSDate *)dateProperty:(ABPropertyID)property
{
    CFDateRef dateRef = ABRecordCopyValue(self.recordRef, property);
    return (__bridge_transfer NSDate *)dateRef;
}

- (UIImage *)imagePropertyFullSize:(BOOL)isFullSize
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
                                 kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(self.recordRef, format);
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

- (NSArray *)phonesWithLabels
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:kABPersonPhoneProperty withBlock:^(ABMultiValueRef multiValue, CFIndex index)
    {
        CFTypeRef rawPhone = ABMultiValueCopyValueAtIndex(multiValue, index);
        NSString *phone = (__bridge_transfer NSString *)rawPhone;
        if (phone)
        {
            NSString *originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            NSString *localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
            APPhoneWithLabel *phoneWithLabel = [[APPhoneWithLabel alloc] init];
            phoneWithLabel.phone = phone;
            phoneWithLabel.originalLabel = originalLabel;
            phoneWithLabel.localizedLabel = localizedLabel;
            [array addObject:phoneWithLabel];
        }
    }];
    return array.copy;
}

- (NSArray *)addresses
{
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    NSArray *array = [self arrayProperty:kABPersonAddressProperty];
    for (NSDictionary *dictionary in array)
    {
        APAddress *address = [[APAddress alloc] init];
        address.street = dictionary[(__bridge NSString *)kABPersonAddressStreetKey];
        address.city = dictionary[(__bridge NSString *)kABPersonAddressCityKey];
        address.state = dictionary[(__bridge NSString *)kABPersonAddressStateKey];
        address.zip = dictionary[(__bridge NSString *)kABPersonAddressZIPKey];
        address.country = dictionary[(__bridge NSString *)kABPersonAddressCountryKey];
        address.countryCode = dictionary[(__bridge NSString *)kABPersonAddressCountryCodeKey];
        [addresses addObject:address];
    }
    return addresses.copy;
}

- (NSString *)compositeName
{
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(self.recordRef);
    return (__bridge_transfer NSString *)compositeNameRef;
}

- (NSArray *)socialProfiles
{
    NSMutableArray *profiles = [[NSMutableArray alloc] init];
    NSArray *array = [self arrayProperty:kABPersonSocialProfileProperty];
    for (NSDictionary *dictionary in array)
    {
        APSocialProfile *profile = [[APSocialProfile alloc] init];
        NSString *socialService = dictionary[(__bridge NSString *)kABPersonSocialProfileServiceKey];
        profile.socialNetwork = [APSocialServiceHelper socialNetworkTypeWithString:socialService];
        profile.url = dictionary[(__bridge NSString *)kABPersonSocialProfileURLKey];
        profile.username = dictionary[(__bridge NSString *)kABPersonSocialProfileUsernameKey];
        profile.userIdentifier = dictionary[(__bridge NSString *)kABPersonSocialProfileUserIdentifierKey];
        [profiles addObject:profile];
    }
    return profiles.copy;
}

- (NSArray *)linkedRecordIDs
{
    NSMutableOrderedSet *linkedRecordIDs = [[NSMutableOrderedSet alloc] init];
    CFArrayRef linkedPeopleRef = ABPersonCopyArrayOfAllLinkedPeople(self.recordRef);
    CFIndex count = CFArrayGetCount(linkedPeopleRef);
    NSNumber *contactRecordID = @(ABRecordGetRecordID(self.recordRef));
    for (CFIndex i = 0; i < count; i++)
    {
        ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleRef, i);
        NSNumber *linkedRecordID = @(ABRecordGetRecordID(linkedRecordRef));
        if (![linkedRecordID isEqualToNumber:contactRecordID])
        {
            [linkedRecordIDs addObject:linkedRecordID];
        }
    }
    CFRelease(linkedPeopleRef);
    return linkedRecordIDs.array;
}

#pragma mark - private

- (NSString *)originalLabelFromMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    NSString *label = (__bridge_transfer NSString *)rawLabel;
    return label;
}

- (NSString *)localizedLabelFromMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    NSString *label;
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    if (rawLabel)
    {
        CFStringRef localizedLabel = ABAddressBookCopyLocalizedLabel(rawLabel);
        if (localizedLabel)
        {
            label = (__bridge_transfer NSString *)localizedLabel;
        }
        CFRelease(rawLabel);
    }
    return label;
}

- (void)enumerateMultiValueOfProperty:(ABPropertyID)property
                            withBlock:(void (^)(ABMultiValueRef multiValue, CFIndex index))block
{
    ABMultiValueRef multiValue = ABRecordCopyValue(self.recordRef, property);
    if (multiValue)
    {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++)
        {
            block(multiValue, i);
        }
        CFRelease(multiValue);
    }
}

@end