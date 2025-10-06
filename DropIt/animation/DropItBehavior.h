//
//  DropItBehavior.h
//  DropIt
//
//  Created by Azizbek Asadov on 07.10.2025.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DropItBehavior : UIDynamicBehavior

- (void) addItem: (id <UIDynamicItem>) item;
- (void) removeItem: (id <UIDynamicItem>) item;

@end

NS_ASSUME_NONNULL_END
