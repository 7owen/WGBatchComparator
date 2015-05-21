//
//  WGCompareUtil.m
//
//
//  Created by 7owen on 15/4/1.
//
//

#import "WGBatchComparator.h"

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

+ (NSComparator)createCompareWithLeftValueKeyPaths:(NSArray*)leftValueKeyPaths rightValueKeyPaths:(NSArray*)rightValueKeyPaths {
    NSComparator compareUtilResult = ^(id leftObject, id rightObject) {
        NSComparisonResult result = NSOrderedSame;
        for (int i = 0; i < leftValueKeyPaths.count || i < rightValueKeyPaths.count; ++i) {
            if (i >= leftValueKeyPaths.count) {
                result = NSOrderedDescending;
            } else if (i >= rightValueKeyPaths.count) {
                result = NSOrderedAscending;
            } else {
                id leftP = [leftObject valueForKeyPath:[leftValueKeyPaths objectAtIndex:i]];
                id rightP = [rightObject valueForKeyPath:[rightValueKeyPaths objectAtIndex:i]];
                
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

+ (NSComparisonResult)compareLeftObj:(id)leftObj rightObj:(id)rightObj {
    BOOL leftCanCompare = [leftObj respondsToSelector:@selector(compare:)];
    BOOL rightCanCompare = [rightObj respondsToSelector:@selector(compare:)];
    if (leftCanCompare && rightCanCompare) {
        return [leftObj compare:rightObj];
    } else {
        if (leftCanCompare) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }
}

@end
