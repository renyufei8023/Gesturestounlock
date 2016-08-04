//
//  RYFLockView.m
//  Gesturestounlock
//
//  Created by 任玉飞 on 16/8/4.
//  Copyright © 2016年 任玉飞. All rights reserved.
//

#import "RYFLockView.h"

@interface RYFLockView ()
@property (nonatomic, strong) NSMutableArray *selectBtn;
@property (nonatomic , assign) CGPoint moveP;

@end
@implementation RYFLockView

- (NSMutableArray *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [NSMutableArray array];
    }
    return _selectBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addButton];
    }
    return self;
}

- (void)addButton
{
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat col = 0;
    CGFloat row = 0;
    
    CGFloat btnW = 74;
    CGFloat btnH = 74;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    CGFloat tolCol = 3;
    CGFloat margin = (self.bounds.size.width - tolCol * btnW) / (tolCol + 1);
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        
        col = i % 3;
        row = i / 3;
        
        btnX = margin + (margin +btnW) * col;
        btnY = (margin + btnH) * row;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}

/**
 *  获得触摸点
 *
 *  @param touches <#touches description#>
 *
 *  @return <#return value description#>
 */
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    return [[touches anyObject]locationInView:self];
}

- (UIButton *)buttonWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [self pointWithTouches:touches];
    
    UIButton *btn = [self buttonWithPoint:pos];
    
    if (btn && btn.isSelected == NO) {
        btn.selected = YES;
        [self.selectBtn addObject:btn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [self pointWithTouches:touches];
    
    _moveP = pos;
    
    UIButton *btn = [self buttonWithPoint:pos];
    
    if (btn && btn.isSelected == NO) {
        btn.selected = YES;
        [self.selectBtn addObject:btn];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < _selectBtn.count; i++) {
        UIButton *btn = _selectBtn[i];
        
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    
    //两个按钮中间的线
    [path addLineToPoint:_moveP];
    
    [[UIColor redColor]set];
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    
    [path stroke];
}
@end
