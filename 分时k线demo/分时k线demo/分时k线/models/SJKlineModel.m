//
//  SJKlineModel.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/18.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "SJKlineModel.h"

@implementation SJKlineModel

- (void)initData {
    [self sumOfLastClose];
    [self sumOfLastVolume];
    [self MA_5];
    [self MA_10];
    [self MA_20];
    [self MA_30];
    [self volumeMA_5];
    [self volumeMA_10];
    [self volumeMA_20];
}

- (NSNumber *)sumOfLastClose
{
    if(!_sumOfLastClose) {
        _sumOfLastClose = @(self.previousKlineModel.sumOfLastClose.floatValue + self.close.floatValue);
    }
    
    return _sumOfLastClose;
}

- (NSNumber *)sumOfLastVolume {
    if (!_sumOfLastVolume) {
        _sumOfLastVolume = @(self.previousKlineModel.sumOfLastVolume.floatValue + self.volume.floatValue);
    }
    
    return _sumOfLastVolume;
}

- (NSNumber *)MA_5 {
    if (!_MA_5) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 4) {
            if (index > 4 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 5];
                _MA_5 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 5);
            } else {
                _MA_5 = @(self.sumOfLastClose.floatValue / 5);
            }
        }
    }
    
    return _MA_5;
}

- (NSNumber *)MA_10
{
    if (!_MA_10) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 9) {
            if (index > 9 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 10];
                _MA_10 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 10);
            } else {
                _MA_10 = @(self.sumOfLastClose.floatValue / 10);
            }
        }
    }
    
    return _MA_10;
}

- (NSNumber *)MA_20
{
    if (!_MA_20) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 19) {
            if (index > 19 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 20];
                _MA_20 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 20);
            } else {
                _MA_20 = @(self.sumOfLastClose.floatValue / 20);
            }
        }
    }
    
    return _MA_20;
}

- (NSNumber *)MA_30
{
    if (!_MA_30) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 29 && index < self.mainKLineModels.count) {
            if (index > 29) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 30];
                _MA_30 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 30);
            } else {
                _MA_30 = @(self.sumOfLastClose.floatValue / 30);
            }
        }
    }
    
    return _MA_30;
}

- (NSNumber *)volumeMA_5
{
    if (!_volumeMA_5) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 4) {
            if (index > 4 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 5];
                _volumeMA_5 = @((self.sumOfLastVolume.floatValue - tempModel.sumOfLastVolume.floatValue) / 5);
            } else {
                _volumeMA_5 = @(self.sumOfLastVolume.floatValue / 5);
            }
        }
    }
    
    return _volumeMA_5;
}

- (NSNumber *)volumeMA_10
{
    if (!_volumeMA_10) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 9) {
            if (index > 9 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 10];
                _volumeMA_10 = @((self.sumOfLastVolume.floatValue - tempModel.sumOfLastVolume.floatValue) / 10);
            } else {
                _volumeMA_10 = @(self.sumOfLastVolume.floatValue / 10);
            }
        }
    }
    
    return _volumeMA_10;
}

- (NSNumber *)volumeMA_20
{
    if (!_volumeMA_20) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 19) {
            if (index > 19 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 20];
                _volumeMA_20 = @((self.sumOfLastVolume.floatValue - tempModel.sumOfLastVolume.floatValue) / 20);
            } else {
                _volumeMA_20 = @(self.sumOfLastVolume.floatValue / 20);
            }
        }
    }
    
    return _volumeMA_20;
}

@end
