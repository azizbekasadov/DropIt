//
//  ViewController.m
//  DropIt
//
//  Created by Azizbek Asadov on 07.10.2025.
//

#import "BezierPathView.h"
#import "DropItBehavior.h"
#import "ViewController.h"

@interface ViewController () <UIDynamicAnimatorDelegate>

@property (nonatomic, getter=isStarted) BOOL started;
@property (weak, nonatomic) IBOutlet BezierPathView* gameView;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) DropItBehavior *dropItBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIView *droppingView;

@end

@implementation ViewController

static CGSize const DROP_CGSIZE = { 40, 40 };

- (UIDynamicAnimator *) dynamicAnimator {
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _dynamicAnimator.delegate = self;
    }
    
    return _dynamicAnimator;
}

- (DropItBehavior *) dropItBehavior {
    if (!_dropItBehavior) {
        _dropItBehavior = [[DropItBehavior alloc] init];
        [self.dynamicAnimator addBehavior:_dropItBehavior];
    }
    
    return _dropItBehavior;
}

- (IBAction)handlePanGameViewGesture: (UIPanGestureRecognizer *) sender {
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self attachDropppingViewToPoint: gesturePoint];
            break;
        case UIGestureRecognizerStateChanged:
            self.attachmentBehavior.anchorPoint = gesturePoint;
            break;
        case UIGestureRecognizerStateEnded:
            [self.dynamicAnimator removeBehavior:self.attachmentBehavior];
            self.gameView.path = NULL;
            break;
        default:
            break;
    }
}

- (IBAction)handleTapGameViewGesture: (UITapGestureRecognizer *) sender {
    [self drop];
}

- (void) attachDropppingViewToPoint: (CGPoint) point {
    if (self.droppingView) {
        self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:point];
        
        __weak ViewController *weakSelf = self;
        UIView *droppingView = self.droppingView; // capturing local variable;
        
        self.attachmentBehavior.action = ^{
            if (weakSelf) {
                UIBezierPath *path = [[UIBezierPath alloc] init];
                [path moveToPoint:weakSelf.attachmentBehavior.anchorPoint];
                [path addLineToPoint:droppingView.center];
                weakSelf.gameView.path = path;
            }
        };
        self.droppingView = nil;
    }
}

- (void) drop {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_CGSIZE;
    
    int x = (arc4random() % (int) self.gameView.bounds.size.width) / DROP_CGSIZE.width;
    frame.origin.x = ((CGFloat)x) * DROP_CGSIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    self.droppingView = dropView;
    
    [self.dropItBehavior addItem: dropView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    NSLog(@"A Memory Warning has been received!");
}

- (UIColor *) randomColor {
    switch (arc4random() % 5) {
        case 0: return UIColor.greenColor;
        case 1: return UIColor.blueColor;
        case 2: return UIColor.orangeColor;
        case 3: return UIColor.redColor;
        case 4: return UIColor.purpleColor;
    }
    
    return UIColor.blackColor;
}

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause: (UIDynamicAnimator *) animator
{
    [self removeCompletedRows];
}

- (BOOL) removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height - DROP_CGSIZE.height/2; y > 0; y -= DROP_CGSIZE.height) {
        BOOL rowIsComplete = NO;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        
        for (CGFloat x = DROP_CGSIZE.width/2; x <= self.gameView.bounds.size.width - DROP_CGSIZE.width/2; x += DROP_CGSIZE.width) {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = YES;
                break;
            }
            
        }
        
        if (![dropsFound count]) { break; }
        if (rowIsComplete) {
            [dropsToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropItBehavior removeItem:drop];
        }
        
        [self animateDropsToRemove: dropsToRemove];
    }
    
    return NO;
}

- (void) animateDropsToRemove: (NSArray *) dropsToRemove
{
    [UIView animateWithDuration:1 animations:^{
        for (UIView *drop in dropsToRemove) {
            int x = ((arc4random() % (int) self.gameView.bounds.size.width * 5)) - (int) self.gameView.bounds.size.width * 2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    } completion:^(BOOL finished) {
            NSLog(@"animation performed");
            [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    ];
}

@end
