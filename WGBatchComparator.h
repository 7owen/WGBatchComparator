//
//  WGCompareUtil.h
//
//
//  Created by 7owen on 15/4/1.
//

#import <Foundation/Foundation.h>

@interface WGBatchComparator : NSObject

+ (void)sourceEnumerator:(NSEnumerator*)sourceEnumerator desEnumerator:(NSEnumerator*)desEnumerator compare:(NSComparator)compareBlock existOnDes:(void(^)(id sourceObj, id desObj))existOnDes notExistOnDes:(void(^)(id sourceObj))notExistOnDes;

+ (NSComparator)createCompareWithLeftValueKeys:(NSArray*)leftValueKeys rightValueKeys:(NSArray*)rightValueKeys;
+ (NSComparator)createCompareWithLeftValueKeyPaths:(NSArray*)leftValueKeyPaths rightValueKeyPaths:(NSArray*)rightValueKeyPaths;
+ (NSComparator)createCompareByLeftPropertys:(NSArray*)leftPropertys rightPropertys:(NSArray*)rightPropertys;

@end