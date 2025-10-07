//
//  DropItBehavior.m
//  DropIt
//
//  Created by Azizbek Asadov on 07.10.2025.
//

#import "DropItBehavior.h"

NS_ASSUME_NONNULL_BEGIN

@interface DropItBehavior()

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;

@end

@implementation DropItBehavior

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addChildBehavior:self.gravityBehavior];
        [self addChildBehavior:self.collisionBehavior];
        [self addChildBehavior:self.dynamicItemBehavior];
    }
    
    return self;
}

- (UIDynamicItemBehavior *)dynamicItemBehavior {
    if (!_dynamicItemBehavior) {
        _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] init];
        _dynamicItemBehavior.allowsRotation = NO;
    }
    
    return _dynamicItemBehavior;
}

- (UIGravityBehavior *) gravityBehavior {
    if (!_gravityBehavior) {
        _gravityBehavior = [[UIGravityBehavior alloc] init];
        _gravityBehavior.magnitude = 0.9f;
    }
    
    return _gravityBehavior;
}

- (UICollisionBehavior *) collisionBehavior {
    if (!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc] init];
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    }
    
    return _collisionBehavior;
}

- (void)addItem: (id<UIDynamicItem>) item {
    [self.gravityBehavior addItem: item];
    [self.collisionBehavior addItem: item];
    [self.dynamicItemBehavior addItem: item];
}

- (void)removeItem:(id<UIDynamicItem>) item {
    [self.gravityBehavior removeItem: item];
    [self.collisionBehavior removeItem: item];
    [self.dynamicItemBehavior removeItem: item];
}

@end

NS_ASSUME_NONNULL_END
