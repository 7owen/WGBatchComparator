//
//  WGCompareUtil.h
//  Comikon
//
//  Created by Wen on 15/4/1.
//

#import <Foundation/Foundation.h>

@interface WGBatchComparator : NSObject

+ (void)leftEnumerator:(NSEnumerator*)leftEnumerator rightEnumerator:(NSEnumerator*)rightEnumerator compare:(NSComparator)compareBlock existOnBoth:(void(^)(id leftObjectBlock, id rightObject))existOnBoth onlyOnLeft:(void(^)(id object))onlyOnLeftBlock onlyOnRight:(void(^)(id object))onlyOnRightBlock;

+ (NSComparator)createCompareWithLeftValueKeys:(NSArray*)leftValueKeys rightValueKeys:(NSArray*)rightValueKeys;
+ (NSComparator)createCompareByLeftPropertys:(NSArray*)leftPropertys rightPropertys:(NSArray*)rightPropertys;

@end