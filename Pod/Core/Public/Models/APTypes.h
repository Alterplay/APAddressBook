//
//  APTypes.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/11/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

typedef NS_ENUM(NSUInteger, APAddressBookAccess)
{
    APAddressBookAccessUnknown = 0,
    APAddressBookAccessGranted = 1,
    APAddressBookAccessDenied  = 2
};

typedef NS_OPTIONS(NSUInteger, APContactField)
{
    APContactFieldFirstName        = 1 << 0,
    APContactFieldLastName         = 1 << 1,
    APContactFieldCompany          = 1 << 2,
    APContactFieldPhones           = 1 << 3,
    APContactFieldEmails           = 1 << 4,
    APContactFieldThumbnail        = 1 << 5,
    APContactFieldPhonesWithLabels = 1 << 6,
    APContactFieldCompositeName    = 1 << 7,
    APContactFieldAddresses        = 1 << 8,
    APContactFieldCreationDate     = 1 << 9,
    APContactFieldModificationDate = 1 << 10,
    APContactFieldMiddleName       = 1 << 11,
    APContactFieldSocialProfiles   = 1 << 12,
    APContactFieldNote             = 1 << 13,
    APContactFieldLinkedRecordIDs  = 1 << 14,
    APContactFieldJobTitle         = 1 << 15,
    APContactFieldWebsites         = 1 << 16,
    APContactFieldBirthday         = 1 << 17,
    APContactFieldSource           = 1 << 18,
    APContactFieldRelatedPersons   = 1 << 19,
    APContactFieldEmailsWithLabels = 1 << 20,
    APContactFieldDefault          = APContactFieldFirstName | APContactFieldLastName |
                                     APContactFieldPhones,
    APContactFieldAll              = 0xFFFFFFFF
};

typedef NS_ENUM(NSUInteger, APSocialNetworkType)
{
    APSocialNetworkUnknown = 0,
    APSocialNetworkFacebook = 1,
    APSocialNetworkTwitter = 2,
    APSocialNetworkLinkedIn = 3,
    APSocialNetworkFlickr = 4,
    APSocialNetworkGameCenter = 5
};