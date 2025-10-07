//
//  BezierPathView.m
//  DropIt
//
//  Created by Azizbek Asadov on 07.10.2025.
//

#import "BezierPathView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BezierPathView

- (void)setPath:(UIBezierPath *) path {
    _path = path;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.path stroke];
}

@end

NS_ASSUME_NONNULL_END
