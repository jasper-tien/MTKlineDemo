//
//  QSKlineModel.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSKlineModel.h"

@implementation QSKlineModel

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

- (CGFloat)sumOfLastClose
{
    if(!_sumOfLastClose) {
        _sumOfLastClose = self.previousKlineModel.sumOfLastClose + self.close;
    }
    
    return _sumOfLastClose;
}

- (CGFloat)sumOfLastVolume {
    if (!_sumOfLastVolume) {
        _sumOfLastVolume = self.previousKlineModel.sumOfLastVolume + self.volume;
    }
    
    return _sumOfLastVolume;
}

- (CGFloat)MA_5 {
    if (!_MA_5) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 4) {
            if (index > 4 && index < self.mainKLineModels.count) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 5];
                _MA_5 = (self.sumOfLastClose - tempModel.sumOfLastClose) / 5;
            } else {
                _MA_5 = self.sumOfLastClose / 5;
            }
        }
    }
    
    return _MA_5;
}

- (CGFloat)MA_10
{
    if (!_MA_10) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 9) {
            if (index > 9 && index < self.mainKLineModels.count) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 10];
                _MA_10 = (self.sumOfLastClose - tempModel.sumOfLastClose) / 10;
            } else {
                _MA_10 = self.sumOfLastClose / 10;
            }
        }
    }
    
    return _MA_10;
}

- (CGFloat)MA_20
{
    if (!_MA_20) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 19) {
            if (index > 19 && index < self.mainKLineModels.count) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 20];
                _MA_20 = (self.sumOfLastClose - tempModel.sumOfLastClose) / 20;
            } else {
                _MA_20 = self.sumOfLastClose / 20;
            }
        }
    }
    
    return _MA_20;
}

- (CGFloat)MA_30
{
    if (!_MA_30) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 29 && index < self.mainKLineModels.count) {
            if (index > 29) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 30];
                _MA_30 = (self.sumOfLastClose - tempModel.sumOfLastClose) / 30;
            } else {
                _MA_30 = self.sumOfLastClose / 30;
            }
        }
    }
    
    return _MA_30;
}

- (CGFloat)volumeMA_5
{
    if (!_volumeMA_5) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 4) {
            if (index > 4 && index < self.mainKLineModels.count) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 5];
                _volumeMA_5 = (self.sumOfLastVolume - tempModel.sumOfLastVolume) / 5;
            } else {
                _volumeMA_5 = self.sumOfLastVolume / 5;
            }
        }
    }
    
    return _volumeMA_5;
}

- (CGFloat)volumeMA_10
{
    if (!_volumeMA_10) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 9) {
            if (index > 9 && index < self.mainKLineModels.count) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 10];
                _volumeMA_10 = (self.sumOfLastVolume - tempModel.sumOfLastVolume) / 10;
            } else {
                _volumeMA_10 = self.sumOfLastVolume / 10;
            }
        }
    }
    
    return _volumeMA_10;
}

- (CGFloat)volumeMA_20
{
    if (!_volumeMA_20) {
        NSInteger index = [self.mainKLineModels indexOfObject:self];
        if (index >= 19) {
            if (index > 19 && index < self.mainKLineModels.count) {
                QSKlineModel *tempModel = self.mainKLineModels[index - 20];
                _volumeMA_20 = (self.sumOfLastVolume - tempModel.sumOfLastVolume) / 20;
            } else {
                _volumeMA_20 = self.sumOfLastVolume / 20;
            }
        }
    }
    
    return _volumeMA_20;
}

@end
