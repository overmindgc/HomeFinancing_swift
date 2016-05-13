//
//  GCDBModel.m
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

#import "GCDBModel.h"

@implementation GCDBModel

- (id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    //    NSLog(@"Undefined Key: %@", key);
}

@end
