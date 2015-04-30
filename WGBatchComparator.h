//
//  WGCompareUtil.h
//
//
//  Created by 7owen on 15/4/1.
//

#import <Foundation/Foundation.h>

@interface WGBatchComparator : NSObject

+ (void)leftEnumerator:(NSEnumerator*)leftEnumerator rightEnumerator:(NSEnumerator*)rightEnumerator compare:(NSComparator)compareBlock existOnBoth:(void(^)(id leftObject, id rightObject))existOnBoth onlyOnLeft:(void(^)(id leftObject))onlyOnLeft onlyOnRight:(void(^)(id rightObject))onlyOnRight;

+ (NSComparator)createCompareWithLeftValueKeys:(NSArray*)leftValueKeys rightValueKeys:(NSArray*)rightValueKeys;
+ (NSComparator)createCompareWithLeftValueKeyPaths:(NSArray*)leftValueKeyPaths rightValueKeyPaths:(NSArray*)rightValueKeyPaths;
+ (NSComparator)createCompareByLeftPropertys:(NSArray*)leftPropertys rightPropertys:(NSArray*)rightPropertys;

@end