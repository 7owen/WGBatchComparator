//
//  WGCompareUtil.m
//
//
//  Created by 7owen on 15/4/1.
//
//

#import "WGBatchComparator.h"

@implementation WGBatchComparator

+ (void)leftEnumerator:(NSEnumerator*)leftEnumerator rightEnumerator:(NSEnumerator*)rightEnumerator compare:(NSComparator)compareBlock existOnBoth:(void(^)(id leftObjectBlock, id rightObject))existOnBoth onlyOnLeft:(void(^)(id object))onlyOnLeftBlock onlyOnRight:(void(^)(id object))onlyOnRightBlock {
    
    id leftObj = [leftEnumerator nextObject];
    id rightObj = [rightEnumerator nextObject];
    while (leftObj || rightObj) {
        if (!rightObj) {
            if (onlyOnLeftBlock) {
                onlyOnLeftBlock(leftObj);
            } else {
                break;
            }
            leftObj = [leftEnumerator nextObject];
        } else if (!leftObj) {
            if (onlyOnRightBlock) {
                onlyOnRightBlock(rightObj);
            } else {
                break;
            }
            rightObj = [rightEnumerator nextObject];
        } else {
            NSComparisonResult result = compareBlock(leftObj, rightObj);
            if (result == NSOrderedSame) {
                if (existOnBoth) {
                    existOnBoth(leftObj, rightObj);
                }
                leftObj = [leftEnumerator nextObject];
                rightObj = [rightEnumerator nextObject];
            } else if (result == NSOrderedAscending) {
                if (onlyOnLeftBlock) {
                    onlyOnLeftBlock(leftObj);
                }
                leftObj = [leftEnumerator nextObject];
            } else {
                if (onlyOnRightBlock) {
                    onlyOnRightBlock(rightObj);
                }
                rightObj = [rightEnumerator nextObject];
            }
        }
    }
}

+ (NSComparator)createCompareWithLeftValueKeys:(NSArray*)leftValueKeys rightValueKeys:(NSArray*)rightValueKeys {
    NSComparator compareUtilResult = ^(id leftObject, id rightObject) {
        NSComparisonResult result = NSOrderedSame;
        for (int i = 0; i < leftValueKeys.count || i < rightValueKeys.count; ++i) {
            if (i >= leftValueKeys.count) {
                result = NSOrderedDescending;
            } else if (i >= rightValueKeys.count) {
                result = NSOrderedAscending;
            } else {
                id leftP = [leftObject valueForKey:[leftValueKeys objectAtIndex:i]];
                id rightP = [rightObject valueForKey:[rightValueKeys objectAtIndex:i]];
                
                if (leftP && rightP) {
                    result = [leftP compare:rightP];
                } else {
                    if (leftP) {
                        result = NSOrderedDescending;
                    } else {
                        result = NSOrderedAscending;
                    }
                }
            }
            if ((result != NSOrderedSame)) {
                break;
            }
        }
        return result;
    };
    return compareUtilResult;
}

+ (NSComparator)createCompareByLeftPropertys:(NSArray*)leftPropertys rightPropertys:(NSArray*)rightPropertys {
    NSComparator compareUtilResult = ^(id leftObject, id rightObject) {
        NSComparisonResult result = NSOrderedSame;
        for (int i = 0; i < leftPropertys.count || i < rightPropertys.count; ++i) {
            if (i >= leftPropertys.count) {
                result = NSOrderedDescending;
            } else if (i >= rightPropertys.count) {
                result = NSOrderedAscending;
            } else {
                typedef id(*aIMP)(id, SEL, ...);
                SEL leftSEL = NSSelectorFromString([leftPropertys objectAtIndex:i]);
                aIMP imp = (aIMP)[leftObject methodForSelector:leftSEL];
                id leftP = imp?imp(leftObject, leftSEL):nil;
                
                SEL rightSEL = NSSelectorFromString([rightPropertys objectAtIndex:i]);
                imp = (aIMP)[rightObject methodForSelector:rightSEL];
                id rightP = imp?imp(rightObject, rightSEL):nil;

                if (leftP && rightP) {
                    result = [leftP compare:rightP];
                } else {
                    if (leftP) {
                        result = NSOrderedDescending;
                    } else {
                        result = NSOrderedAscending;
                    }
                }
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
