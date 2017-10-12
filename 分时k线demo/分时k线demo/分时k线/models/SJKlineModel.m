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
    [self MA_7];
    [self MA_12];
    [self MA_26];
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

- (NSNumber *)MA_7 {
    if (!_MA_7) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 6) {
            if (index > 6 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 7];
                _MA_7 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 7);
            } else {
                _MA_7 = @(self.sumOfLastClose.floatValue / 7);
            }
        }
    }
    
    return _MA_7;
}

- (NSNumber *)MA_12
{
    if (!_MA_12) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 11) {
            if (index > 11 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 12];
                _MA_12 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 12);
            } else {
                _MA_12 = @(self.sumOfLastClose.floatValue / 12);
            }
        }
    }
    
    return _MA_12;
}

- (NSNumber *)MA_26
{
    if (!_MA_26) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 25) {
            if (index > 25 && index < self.mainKLineModels.count) {
                SJKlineModel *tempModel = self.mainKLineModels[index - 26];
                _MA_26 = @((self.sumOfLastClose.floatValue - tempModel.sumOfLastClose.floatValue) / 26);
            } else {
                _MA_26 = @(self.sumOfLastClose.floatValue / 26);
            }
        }
    }
    
    return _MA_26;
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
