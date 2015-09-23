//
//  APContactDataExtractor 
//  AddressBook
//
//  Created by Alexey Belkevich on 22.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import "APContactDataExtractor.h"
#import "APPhoneWithLabel.h"
#import "APEmailWithLabel.h"
#import "APAddress.h"
#import "APSocialProfile.h"
#import "APSocialServiceHelper.h"
#import "APSource.h"
#import "APRelatedPerson.h"

@implementation APContactDataExtractor

#pragma mark - public

- (NSString *)stringProperty:(ABPropertyID)property
{
    return [self stringProperty:property fromRecordRef:self.recordRef];
}

- (NSArray *)arrayProperty:(ABPropertyID)property
{
    return [self mapMultiValueOfProperty:property withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        return (__bridge NSString *)value;
    }];
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
    return [self mapMultiValueOfProperty:kABPersonPhoneProperty withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        APPhoneWithLabel *phoneWithLabel;
        if (value)
        {
            NSString *phone = (__bridge NSString *)value;
            NSString *originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            NSString *localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
            phoneWithLabel = [[APPhoneWithLabel alloc] init];
            phoneWithLabel.phone = phone;
            phoneWithLabel.originalLabel = originalLabel;
            phoneWithLabel.localizedLabel = localizedLabel;
        }
        return phoneWithLabel;
    }];
}

- (NSArray *)emailsWithLabels
{
    return [self mapMultiValueOfProperty:kABPersonEmailProperty withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        APEmailWithLabel *emailWithLabel;
        if (value)
        {
            NSString *email = (__bridge NSString *)value;
            NSString *originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            NSString *localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
            emailWithLabel = [[APEmailWithLabel alloc] init];
            emailWithLabel.email = email;
            emailWithLabel.originalLabel = originalLabel;
            emailWithLabel.localizedLabel = localizedLabel;
        }
        return emailWithLabel;
    }];
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

- (APSource *)source
{
    APSource *source;
    ABRecordRef sourceRef = ABPersonCopySource(self.recordRef);
    if (sourceRef)
    {
        source = [[APSource alloc] init];
        source.sourceType = [self stringProperty:kABSourceNameProperty fromRecordRef:sourceRef];
        source.sourceID =  @(ABRecordGetRecordID(sourceRef));
        CFRelease(sourceRef);
    }
    return source;
}

- (NSArray *)relatedPersons
{
    return [self mapMultiValueOfProperty:kABPersonRelatedNamesProperty withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        APRelatedPerson *relatedPerson;
        if (value)
        {
            relatedPerson = [[APRelatedPerson alloc] init];
            relatedPerson.name = (__bridge NSString *)value;
            relatedPerson.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            relatedPerson.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
        }
        return relatedPerson;
    }];
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

- (NSArray *)mapMultiValueOfProperty:(ABPropertyID)property
                           withBlock:(id (^)(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index))block
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(self.recordRef, property);
    if (multiValue)
    {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++)
        {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, i);
            id object = block(multiValue, value, i);
            if (object)
            {
                [array addObject:object];
            }
            CFRelease(value);
        }
        CFRelease(multiValue);
    }
    return array.count > 0 ? array.copy : nil;
}

- (NSString *)stringProperty:(ABPropertyID)property fromRecordRef:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

@end