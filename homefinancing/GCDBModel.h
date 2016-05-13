//
//  GCDBModel.h
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDBModel : NSObject

/**根据字典匹配赋值给属性*/
- (id)initWithDict:(NSDictionary *)dictionary;

/**如果没有某一属性，则自动调用这个方法，子类可以重写这个方法进行处理，不实现这个方法会抛异常*/
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
