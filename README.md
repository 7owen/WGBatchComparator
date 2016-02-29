# WGBatchComparator
Efficient way to perform bulk INSERT/UPDATE/DELETE in CoreData.

Have a look at <a href="https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdImporting.html#//apple_ref/doc/uid/TP40003174-SW4">Implementing Find-or-Create Efficiently</a> in the "Core Data Programming Guide".

# Another usage:
Before:
```Objective-C
    NSArray *array1 = @[@"1",@"4",@"6"];
    NSArray *array2 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *obj1 in array1) {
        for (NSString *obj2 in array2) {
            if ([obj1 isEqualToString:obj2]) {
                [result addObject:obj1]; //or [result addObject:obj2];
            }
        }
    }
```
After:
```Objective-C
    NSArray *array1 = @[@"1",@"4",@"6"];
    NSArray *array2 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableArray *result = [NSMutableArray array];
    
    //array1 and array2 must be in ascending order
    array1 = [array1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    array2 = [array2 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSComparator comparator = [WGBatchComparator createCompareWithLeftValueKeyPaths:@[@"self"] rightValueKeyPaths:@[@"self"]]; //if UIView object, like @"layer.frame"
    [WGBatchComparator sourceEnumerator:array1.objectEnumerator desEnumerator:array2.objectEnumerator compare:comparator existOnDes:^(id sourceObj, id desObj) {
        [result addObject:sourceObj];
    } notExistOnDes:^(id sourceObj) {
        
    }];
```
