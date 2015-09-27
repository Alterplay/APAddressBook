//
//  APSource 
//  AddressBook
//
//  Created by Alexey Belkevich on 23.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APSource : NSObject

@property (nullable, nonatomic, strong) NSString *sourceType;
@property (nullable, nonatomic, strong) NSNumber *sourceID;

@end