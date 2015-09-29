//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class APPhoneWithLabel;
@class APEmailWithLabel;
@class APAddress;
@class APSocialProfile;
@class APSource;
@class APRelatedPerson;

@interface APContact : NSObject

@property (nullable, nonatomic, strong) NSNumber *recordID;
@property (nullable, nonatomic, strong) NSString *firstName;
@property (nullable, nonatomic, strong) NSString *middleName;
@property (nullable, nonatomic, strong) NSString *lastName;
@property (nullable, nonatomic, strong) NSString *compositeName;
@property (nullable, nonatomic, strong) NSString *company;
@property (nullable, nonatomic, strong) NSString *jobTitle;
@property (nullable, nonatomic, strong) NSArray <NSString *> *phones;
@property (nullable, nonatomic, strong) NSArray <APPhoneWithLabel *> *phonesWithLabels;
@property (nullable, nonatomic, strong) NSArray <NSString *> *emails;
@property (nullable, nonatomic, strong) NSArray <APEmailWithLabel *> *emailsWithLabels;
@property (nullable, nonatomic, strong) NSArray <APAddress *> *addresses;
@property (nullable, nonatomic, strong) UIImage *thumbnail;
@property (nullable, nonatomic, strong) NSDate *creationDate;
@property (nullable, nonatomic, strong) NSDate *modificationDate;
@property (nullable, nonatomic, strong) NSArray <APSocialProfile *> *socialProfiles;
@property (nullable, nonatomic, strong) NSString *note;
@property (nullable, nonatomic, strong) NSArray <NSNumber *> *linkedRecordIDs;
@property (nullable, nonatomic, strong) NSArray <NSString *> *websites;
@property (nullable, nonatomic, strong) NSDate *birthday;
@property (nullable, nonatomic, strong) APSource *source;
@property (nullable, nonatomic, strong) NSArray <APRelatedPerson *> *relatedPersons;

@end
