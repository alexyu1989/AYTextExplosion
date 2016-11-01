//
//  AYLabelCollectionViewCell.m
//  TextExplosion
//
//  Created by Alex Yu on 30/10/2016.
//  Copyright © 2016 Alex Yu. All rights reserved.
//

#import "AYLabelCollectionViewCell.h"

@interface AYLabelCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation AYLabelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:_titleLabel];
        
        _backgroundLayer = [CAShapeLayer layer];
        [self.contentView.layer insertSublayer:_backgroundLayer below:_titleLabel.layer];
        
        [self setSelected:NO];
    }
    
    return self;
}

- (NSString *)text {
    return self.titleLabel.text;
}

- (void)setText:(NSString *)text {
    [self.titleLabel setText:text];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
    self.backgroundLayer.frame = self.contentView.bounds;
    
    CGFloat cornerRadius = 4.0;
    
    CGRect pathRect = CGRectInset(self.contentView.bounds, cornerRadius/2, cornerRadius/2);
    CGPathRef path = [self jonathanRectWithRect:pathRect andCornerRadius:cornerRadius];
    [self.backgroundLayer setPath:path];
}

- (CGSize)intrinsicContentSize
{
    return self.titleLabel.intrinsicContentSize;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundLayer.strokeColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
        self.backgroundLayer.fillColor = [UIColor colorWithWhite:0.23 alpha:1].CGColor;
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    } else {
        self.backgroundLayer.strokeColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.backgroundLayer.fillColor = [UIColor colorWithWhite:0.92 alpha:1].CGColor;
        self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
    }
}

#pragma mark - Geometry

#define TOP_LEFT(X, Y)\
CGPointMake(rect.origin.x + X * limitedRadius,\
rect.origin.y + Y * limitedRadius)
#define TOP_RIGHT(X, Y)\
CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
rect.origin.y + Y * limitedRadius)
#define BOTTOM_RIGHT(X, Y)\
CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
rect.origin.y + rect.size.height - Y * limitedRadius)
#define BOTTOM_LEFT(X, Y)\
CGPointMake(rect.origin.x + X * limitedRadius,\
rect.origin.y + rect.size.height - Y * limitedRadius)

- (CGPathRef)jonathanRectWithRect:(CGRect)rect andCornerRadius:(CGFloat)radius
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGFloat limit = MIN(rect.size.width, rect.size.height) / 2 / 1.52866483;
    CGFloat limitedRadius = MIN(radius, limit);
    
    [path moveToPoint: TOP_LEFT(1.52866483, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(1.52866471, 0.00000000)];
    [path addCurveToPoint: TOP_RIGHT(0.66993427, 0.06549600)
            controlPoint1: TOP_RIGHT(1.08849323, 0.00000000)
            controlPoint2: TOP_RIGHT(0.86840689, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(0.63149399, 0.07491100)];
    [path addCurveToPoint: TOP_RIGHT(0.07491176, 0.63149399)
            controlPoint1: TOP_RIGHT(0.37282392, 0.16905899)
            controlPoint2: TOP_RIGHT(0.16906013, 0.37282401)];
    [path addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483)
            controlPoint1: TOP_RIGHT(0.00000000, 0.86840701)
            controlPoint2: TOP_RIGHT(0.00000000, 1.08849299)];
    [path addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.06549569, 0.66993493)
            controlPoint1: BOTTOM_RIGHT(0.00000000, 1.08849323)
            controlPoint2: BOTTOM_RIGHT(0.00000000, 0.86840689)];
    [path addLineToPoint: BOTTOM_RIGHT(0.07491111, 0.63149399)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.63149399, 0.07491111)
            controlPoint1: BOTTOM_RIGHT(0.16905883, 0.37282392)
            controlPoint2: BOTTOM_RIGHT(0.37282392, 0.16905883)];
    [path addCurveToPoint: BOTTOM_RIGHT(1.52866471, 0.00000000)
            controlPoint1: BOTTOM_RIGHT(0.86840689, 0.00000000)
            controlPoint2: BOTTOM_RIGHT(1.08849323, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(1.52866483, 0.00000000)];
    [path addCurveToPoint: BOTTOM_LEFT(0.66993397, 0.06549569)
            controlPoint1: BOTTOM_LEFT(1.08849299, 0.00000000)
            controlPoint2: BOTTOM_LEFT(0.86840701, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(0.63149399, 0.07491111)];
    [path addCurveToPoint: BOTTOM_LEFT(0.07491100, 0.63149399)
            controlPoint1: BOTTOM_LEFT(0.37282401, 0.16905883)
            controlPoint2: BOTTOM_LEFT(0.16906001, 0.37282392)];
    [path addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471)
            controlPoint1: BOTTOM_LEFT(0.00000000, 0.86840689)
            controlPoint2: BOTTOM_LEFT(0.00000000, 1.08849323)];
    [path addLineToPoint: TOP_LEFT(0.00000000, 1.52866483)];
    [path addCurveToPoint: TOP_LEFT(0.06549600, 0.66993397)
            controlPoint1: TOP_LEFT(0.00000000, 1.08849299)
            controlPoint2: TOP_LEFT(0.00000000, 0.86840701)];
    [path addLineToPoint: TOP_LEFT(0.07491100, 0.63149399)];
    [path addCurveToPoint: TOP_LEFT(0.63149399, 0.07491100)
            controlPoint1: TOP_LEFT(0.16906001, 0.37282401)
            controlPoint2: TOP_LEFT(0.37282401, 0.16906001)];
    [path addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000)
            controlPoint1: TOP_LEFT(0.86840701, 0.00000000)
            controlPoint2: TOP_LEFT(1.08849299, 0.00000000)];
    [path closePath];
    return path.CGPath;
}

@end
