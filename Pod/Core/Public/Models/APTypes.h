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
    APContactFieldName             = 1 << 0,
    APContactFieldJob              = 1 << 1,
    APContactFieldThumbnail        = 1 << 2,
    APContactFieldPhonesOnly       = 1 << 3,
    APContactFieldPhonesWithLabels = 1 << 4,
    APContactFieldEmailsOnly       = 1 << 5,
    APContactFieldEmailsWithLabels = 1 << 6,
    APContactFieldAddresses        = 1 << 7,
    APContactFieldSocialProfiles   = 1 << 8,
    APContactFieldBirthday         = 1 << 9,
    APContactFieldWebsites         = 1 << 10,
    APContactFieldNote             = 1 << 11,
    APContactFieldRelatedPersons   = 1 << 12,
    APContactFieldLinkedRecordIDs  = 1 << 13,
    APContactFieldSource           = 1 << 14,
    APContactFieldRecordDate       = 1 << 15,
    APContactFieldDefault          = APContactFieldName | APContactFieldPhonesOnly,
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