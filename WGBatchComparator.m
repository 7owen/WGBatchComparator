//
//  WGCompareUtil.m
//
//
//  Created by 7owen on 15/4/1.
//
//

#import "WGBatchComparator.h"

typedef void(^WGBatchComparatorGetValuesBlock)(NSString *key, id object, id *outValue);

@implementation WGBatchComparator

+ (void)sourceEnumerator:(NSEnumerator*)sourceEnumerator desEnumerator:(NSEnumerator*)desEnumerator compare:(NSComparator)compareBlock existOnDes:(void(^)(id sourceObj, id desObj))existOnDes notExistOnDes:(void(^)(id sourceObj))notExistOnDes {
    id sourceObj = [sourceEnumerator nextObject];
    id desObj = [desEnumerator nextObject];
    while (sourceObj) {
        if (!desObj) {
            if (notExistOnDes) {
                notExistOnDes(sourceObj);
            } else {
                break;
            }
            sourceObj = [sourceEnumerator nextObject];
        } else {
            NSComparisonResult result = compareBlock(sourceObj, desObj);
            if (result == NSOrderedSame) {
                if (existOnDes) {
                    existOnDes(sourceObj, desObj);
                }
                sourceObj = [sourceEnumerator nextObject];
            } else if (result == NSOrderedAscending) {
                if (notExistOnDes) {
                    notExistOnDes(sourceObj);
                }
                sourceObj = [sourceEnumerator nextObject];
            } else {
                desObj = [desEnumerator nextObject];
            }
        }
    }
}

+ (NSComparator)createCompareWithLeftValueKeys:(NSArray*)leftValueKeys rightValueKeys:(NSArray*)rightValueKeys {
    return [self createCompareWithLeftValueKeys:leftValueKeys rightValueKeys:rightValueKeys getValuesBlock:^(NSString *key, id object, __autoreleasing id *outValue) {
        *outValue = [object valueForKey:key];
    }];
}

+ (NSComparator)createCompareWithLeftValueKeyPaths:(NSArray*)leftValueKeyPaths rightValueKeyPaths:(NSArray*)rightValueKeyPaths {
    
    return [self createCompareWithLeftValueKeys:leftValueKeyPaths rightValueKeys:rightValueKeyPaths getValuesBlock:^(NSString *key, id object, __autoreleasing id *outValue) {
        *outValue = [object valueForKeyPath:key];
    }];
}

+ (NSComparator)createCompareByLeftPropertys:(NSArray*)leftPropertys rightPropertys:(NSArray*)rightPropertys {
    typedef id(*aIMP)(id, SEL, ...);
    return [self createCompareWithLeftValueKeys:leftPropertys rightValueKeys:rightPropertys getValuesBlock:^(NSString *key, id object, __autoreleasing id *outValue) {
        SEL aSEL = NSSelectorFromString(key);
        aIMP imp = (aIMP)[object methodForSelector:aSEL];
        *outValue = imp?imp(object, aSEL):nil;
    }];
    
}

+ (NSComparisonResult)compareLeftObj:(id)leftObj rightObj:(id)rightObj {
    BOOL leftCanCompare = [leftObj respondsToSelector:@selector(compare:)];
    BOOL rightCanCompare = [rightObj respondsToSelector:@selector(compare:)];
    if (leftCanCompare && rightCanCompare) {
        if (![leftObj isKindOfClass:[rightObj class]]) {
            leftObj = [leftObj description];
            rightObj = [rightObj description];
        }
        return [leftObj compare:rightObj];
    } else {
        if (leftCanCompare) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }
}

#pragma mark private

+ (NSComparator)createCompareWithLeftValueKeys:(NSArray*)leftValueKeys rightValueKeys:(NSArray*)rightValueKeys getValuesBlock:(WGBatchComparatorGetValuesBlock)getValuesBlock {
    NSComparator compareUtilResult = ^(id leftObject, id rightObject) {
        NSComparisonResult result = NSOrderedSame;
        for (int i = 0; i < leftValueKeys.count || i < rightValueKeys.count; ++i) {
            if (i >= leftValueKeys.count) {
                result = NSOrderedDescending;
            } else if (i >= rightValueKeys.count) {
                result = NSOrderedAscending;
            } else {
                id leftP = nil;
                NSString *leftKey = [leftValueKeys objectAtIndex:i];
                if ([[leftKey lowercaseString] isEqualToString:@"self"]) {
                    leftP = leftObject;
                } else {
                    getValuesBlock(leftKey, leftObject, &leftP);
                }
                
                id rightP = nil;
                NSString *rightKey = [rightValueKeys objectAtIndex:i];
                if ([[rightKey lowercaseString]isEqualToString:@"self"]) {
                    rightP = rightObject;
                } else {
                    getValuesBlock(rightKey, rightObject, &rightP);
                }
                
                result = [self compareLeftObj:leftP rightObj:rightP];
            }
            if ((result != NSOrderedSame)) {
                break;
            }
        }
        return result;
    };
    return compareUtilResult;
}

@end
