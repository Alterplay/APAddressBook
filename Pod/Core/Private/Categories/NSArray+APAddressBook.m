//
//  NSArray(APAddressBook) 
//  AddressBook
//
//  Created by Alexey Belkevich on 21.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import "NSArray+APAddressBook.h"
#import "APContact.h"

@implementation NSArray (APAddressBook)

- (NSArray *)filteredArrayWithBlock:(BOOL (^)(APContact *contact))filterBlock
              sortedWithDescriptors:(NSArray *)descriptors
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (filterBlock)
    {
        for (APContact *contact in self)
        {
            if (filterBlock(contact))
            {
                [result addObject:contact];
            }
        }
    }
    else
    {
        [result addObjectsFromArray:self];
    }
    if (descriptors)
    {
        [result sortUsingDescriptors:descriptors];
    }
    return result.copy;
}

@end