//
//  APRecordDate
//  AddressBook
//
//  Created by Alexey Belkevich on 05.10.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APRecordDate : NSObject

@property (nullable, nonatomic, strong) NSDate *creationDate;
@property (nullable, nonatomic, strong) NSDate *modificationDate;

@end