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

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *compositeName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) NSArray *phonesWithLabels;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSArray *emailsWithLabels;
@property (nonatomic, strong) NSArray *addresses;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSNumber *recordID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *modificationDate;
@property (nonatomic, strong) NSArray *socialProfiles;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSArray *linkedRecordIDs;
@property (nonatomic, strong) NSArray *websites;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) APSource *source;
@property (nonatomic, strong) NSArray *relatedPersons;

@end
