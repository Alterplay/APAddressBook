//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class APSource;

@interface APContact : NSObject

@property (nullable, nonatomic, strong) NSString *firstName;
@property (nullable, nonatomic, strong) NSString *middleName;
@property (nullable, nonatomic, strong) NSString *lastName;
@property (nullable, nonatomic, strong) NSString *compositeName;
@property (nullable, nonatomic, strong) NSString *company;
@property (nullable, nonatomic, strong) NSString *jobTitle;
@property (nullable, nonatomic, strong) NSArray *phones;
@property (nullable, nonatomic, strong) NSArray *phonesWithLabels;
@property (nullable, nonatomic, strong) NSArray *emails;
@property (nullable, nonatomic, strong) NSArray *emailsWithLabels;
@property (nullable, nonatomic, strong) NSArray *addresses;
@property (nullable, nonatomic, strong) UIImage *photo;
@property (nullable, nonatomic, strong) UIImage *thumbnail;
@property (nullable, nonatomic, strong) NSNumber *recordID;
@property (nullable, nonatomic, strong) NSDate *creationDate;
@property (nullable, nonatomic, strong) NSDate *modificationDate;
@property (nullable, nonatomic, strong) NSArray *socialProfiles;
@property (nullable, nonatomic, strong) NSString *note;
@property (nullable, nonatomic, strong) NSArray *linkedRecordIDs;
@property (nullable, nonatomic, strong) NSArray *websites;
@property (nullable, nonatomic, strong) NSDate *birthday;
@property (nullable, nonatomic, strong) APSource *source;
@property (nullable, nonatomic, strong) NSArray *relatedPersons;

@end
