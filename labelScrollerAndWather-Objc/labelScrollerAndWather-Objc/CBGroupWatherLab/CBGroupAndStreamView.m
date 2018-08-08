//
//  CBGroupAndStreamView.m
// 
//
//  Created by kms on 2017/5/23.
//  Copyright © 2017年 KMS. All rights reserved.
//

#import "CBGroupAndStreamView.h"
#import "UIView+CBExtension.h"

#define CBColor(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

@interface CBGroupAndStreamView()
//滚动视图
@property (strong,nonatomic) UIScrollView *scroller;
//最后一个按钮的frame
@property (assign,nonatomic) CGRect frameRect;
//数据源数组
@property (strong,nonatomic) NSMutableArray *dataSourceArr;
//保存按钮选中的值
@property (strong,nonatomic) NSMutableArray *saveSelButValueArr;
//保存选中的groupID
@property (strong, nonatomic) NSMutableArray * saveGroupIndexArr;
//传入的组title，共可分成多少组
@property (copy, nonatomic) NSArray * titleArr;
//各按钮title，选项
@property (copy, nonatomic) NSArray * contetntArr;

@end

@implementation CBGroupAndStreamView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {

        [self initDefaultConfign];
        [self addSubview:self.scroller];

    }
    return self;
}

#pragma mark---初始化
- (void)initDefaultConfign{
    _isDefaultSel = YES;
    _isSingle = YES;
    _butHeight = 30;
    _font = [UIFont systemFontOfSize:12];
    _contentNorColor = CBColor(100, 100, 100);
    _contentSelColor = [UIColor whiteColor];
    _norColor = CBColor(228, 228, 228);
    _selColor = CBColor(250, 87, 118);
    _titleTextColor = CBColor(100, 100, 100);
    _titleTextFont = [UIFont systemFontOfSize:14];
    _maragin_x = _maragin_y = 10;
    _titleLabHeight = 30;
    _radius = 6;

}

- (void)setContentView:(NSArray *)contenArr titleArr:(NSArray *)titleArr{
    //每次初始化view时，清除保存选择的值
    [self.saveSelButValueArr removeAllObjects];
    [self.saveGroupIndexArr removeAllObjects];

    _contetntArr = contenArr.count > 0 ? contenArr : _contetntArr;
    _titleArr = titleArr.count > 0 ? titleArr : _titleArr;
    contenArr = _contetntArr.count > 0 ? _contetntArr:contenArr;
    titleArr = _titleArr.count > 0 ? _titleArr : titleArr;

    //设置rect的初始值
    self.frameRect = CGRectZero;
    //设置内容
    [self.dataSourceArr removeAllObjects];
    [self.dataSourceArr addObjectsFromArray:contenArr];
    //设置默认的值，使保存值的数组是按照group的顺序来保存，便于后面对相应的group的值进行增改
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.saveSelButValueArr addObject:@""];
        [self.saveGroupIndexArr addObject:@""];
    }];

    for (NSInteger i = 0 ; i < titleArr.count; ++i) {
        //设置每一组的值，并返回最后一个frame
        self.frameRect = [self setSignView:contenArr[i] andTitle:titleArr[i] andFrame:self.frameRect andGroupId:i];
    }
    //设置滚动视图的滚动范围
    self.scroller.contentSize = CGSizeMake(0, self.frameRect.size.height + self.frameRect.origin.y + 10);
}


/**
 填充内容

 @param dataAr 每一组的内容 数组
 @param titleStr 标题
 @param frame 坐标，为下一组提供坐标计算
 @param groupId 组id
 @return 坐标，为下一组提供坐标计算
 */

- (CGRect)setSignView:(NSArray *)dataAr andTitle:(NSString *)titleStr andFrame:(CGRect)frame andGroupId:(NSInteger)groupId{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, frame.size.height + frame.origin.y + 10, 0, _titleLabHeight)];
    label.font = _titleTextFont;
    label.text = titleStr;
    CGSize size = [self sizeWidthWidth:titleStr font:_titleTextFont maxHeight:_titleLabHeight];
    label.width = size.width;
    label.textColor = _titleTextColor;
    [self.scroller addSubview:label];

    CGRect rect = CGRectZero;
    CGFloat butHeight = _butHeight;
    CGFloat margainY = 5 + label.y + label.height;
    CGFloat but_totalHeight = margainY;
    CGFloat butorignX = _maragin_x;
    CGFloat alineButWidth = 0;
    CGRect current_rect;
    for (NSInteger i = 0; i < dataAr.count; ++i) {
        @autoreleasepool {
            CGSize contentSize = [self sizeWidthWidth:dataAr[i] font:_font maxHeight:butHeight];
            //创建按钮
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setTitleColor:_contentNorColor forState:UIControlStateNormal];
            [but setTitleColor:_contentSelColor forState:UIControlStateSelected];
            [but setTitle:dataAr[i] forState:UIControlStateNormal];
            [self.scroller addSubview:but];
            but.titleLabel.font = _font;
            // 九宫格算法，每行放三个 margainX+(i%3)*(butWidth + 10)  margainY+(i/3)*(butHeight+10)
            //处理标签流
            CGFloat butWidth = contentSize.width + 20;
            butorignX = alineButWidth + _maragin_x;
            alineButWidth = _maragin_x + butWidth + alineButWidth;
            if (alineButWidth >= self.width) {
                butorignX = _maragin_x;
                alineButWidth = butorignX + butWidth;
                but_totalHeight = current_rect.size.height + current_rect.origin.y + _maragin_y;
            }

            but.frame = CGRectMake(butorignX, but_totalHeight, butWidth, butHeight);
            current_rect = but.frame;
            but.backgroundColor = _norColor;
            but.tag = groupId * 100 + i + 1;
            //按钮样式
            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
            but.layer.cornerRadius = _radius;
            but.layer.masksToBounds = YES;
            //默认选中第一个
            if (_isDefaultSel) {
                if (i == 0) {
                    but.backgroundColor = _selColor;
                    but.selected = YES;
                    //默认保存选中第一个按钮的值
                    NSString *valueStr = [NSString stringWithFormat:@"%ld/%@",i,dataAr[i]];

                    if (_singleFlagArr.count > 0) {
                        [self.saveSelButValueArr replaceObjectAtIndex:groupId withObject:[_singleFlagArr[groupId] isEqual:@0] ? @[valueStr] : valueStr];
                    }else{
                        [self.saveSelButValueArr replaceObjectAtIndex:groupId withObject:_isSingle ? valueStr : @[valueStr]];
                    }

                    //保存groupID
                    [self.saveGroupIndexArr replaceObjectAtIndex:groupId withObject:[NSNumber numberWithInteger:groupId]];
                }
            }
            if (i == dataAr.count - 1) {
                //当最后一个按钮时，返回坐标
                rect = but.frame;
            }
        }
    }
    return rect;
}


/**
 按钮点击事件
 @param sender 按钮
 */
- (void)butClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_singleFlagArr.count > 0) {
        [_singleFlagArr[sender.tag / 100] isEqual:@1] ? [self contentSignalWith:sender] : [self contentMultipleWith:sender];
        return;
    }
    _isSingle ? [self contentSignalWith:sender] : [self contentMultipleWith:sender];
}

#pragma mark---单选
- (void)contentSignalWith:(UIButton *)sender{
    NSString * valueStr = @"";
    if (sender.selected) {
        for (NSInteger i = 0; i < [self.dataSourceArr[sender.tag / 100] count]; ++i) {
            @autoreleasepool {
                if (sender.tag % 100 ==  i + 1) {
                    sender.selected = YES;
                    sender.backgroundColor = _selColor;
                    continue;
                }
                UIButton *but = (UIButton *)[self.scroller viewWithTag:(sender.tag / 100) * 100 + i + 1];
                but.selected = NO;
                but.backgroundColor = _norColor;
            }
        }
        //取出当前所在的组的一条数据，因为单选，所以就只有一条数据, 并拼接当前选择的Index
       valueStr = [NSString stringWithFormat:@"%ld/%@",sender.tag % 100 - 1,self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1]];

    }else{
        sender.backgroundColor = _norColor;
        valueStr = @"";
    }
     [self.saveSelButValueArr replaceObjectAtIndex:sender.tag / 100 withObject:valueStr];
    //保存groupID
    [self.saveGroupIndexArr replaceObjectAtIndex:sender.tag / 100 withObject:[NSNumber numberWithInteger:sender.tag / 100]];
    //传递当前选中的Value
    if ([self.delegate respondsToSelector:@selector(cb_selectCurrentValueWith:index:groupId:)]) {
        [self.delegate cb_selectCurrentValueWith:self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1] index:sender.tag % 100 - 1 groupId:sender.tag / 100];
    }
    if (_cb_selectCurrentValueBlock) {
        _cb_selectCurrentValueBlock(self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1],sender.tag % 100 - 1,sender.tag / 100);
    }
}

#pragma mark---多选
- (void)contentMultipleWith:(UIButton *)sender{

    NSString * valueStr = @"";
    NSMutableArray * tempSaveArr = nil;
    if (self.saveSelButValueArr.count > 0) {
        tempSaveArr = [self.saveSelButValueArr[sender.tag / 100] isKindOfClass:[NSArray class]] ? [NSMutableArray arrayWithArray:self.saveSelButValueArr[sender.tag / 100]] : [[NSMutableArray alloc] init];
    }else{
        tempSaveArr = [[NSMutableArray alloc] init];
    }

    if (sender.selected) {
        valueStr = [NSString stringWithFormat:@"%ld/%@",sender.tag % 100 - 1,self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1]];
        sender.backgroundColor = _selColor;

        if (![tempSaveArr containsObject:valueStr]) {
            [tempSaveArr addObject:valueStr];
        }else{
            [tempSaveArr replaceObjectAtIndex:sender.tag % 100 - 1 withObject:valueStr];
        }
    }else{
        sender.backgroundColor = _norColor;
        valueStr = [NSString stringWithFormat:@"%ld/%@",sender.tag % 100 - 1,self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1]];;
        [tempSaveArr removeObject:valueStr];
    }

    [self.saveSelButValueArr replaceObjectAtIndex:sender.tag / 100 withObject:tempSaveArr?tempSaveArr:@""];
    //保存groupID
    [self.saveGroupIndexArr replaceObjectAtIndex:sender.tag / 100 withObject:[NSNumber numberWithInteger:sender.tag / 100]];
    //传递当前选中的Value
    if ([self.delegate respondsToSelector:@selector(cb_selectCurrentValueWith:index:groupId:)]) {
        [self.delegate cb_selectCurrentValueWith:self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1] index:sender.tag % 100 - 1 groupId:sender.tag / 100];
    }

    if (_cb_selectCurrentValueBlock) {
        _cb_selectCurrentValueBlock(self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1],sender.tag % 100 - 1,sender.tag / 100);
    }
}

#pragma mark---确定重置
- (void)confirm{
    if ([self.delegate respondsToSelector:@selector(cb_confirmReturnValue:groupId:)]) {
        [self.delegate cb_confirmReturnValue:self.saveSelButValueArr groupId:self.saveGroupIndexArr];
    }
    if (_cb_confirmReturnValueBlock) {
        _cb_confirmReturnValueBlock(self.saveSelButValueArr,self.saveGroupIndexArr);
    }
}

- (void)reset{
    //重置，回到初始默认状态
    for (UIButton *but in self.scroller.subviews) {
        //移除旧的视图，从scroller的视图
        [but removeFromSuperview];
    }
    for (UILabel *lab in self.scroller.subviews) {
        [lab removeFromSuperview];
    }
    [self setContentView:_contetntArr titleArr:_titleArr];
}

#pragma mark---set
- (void)setSingleFlagArr:(NSArray<NSNumber *> *)singleFlagArr{
    _singleFlagArr = singleFlagArr;
    [singleFlagArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([obj isEqual:@0] || [obj isEqual:@1])) {
            NSAssert([obj isEqual:@""], @"singleFlagArr 数组元素只能是 0 和 1");
            *stop = YES;
        }
    }];
}

#pragma mark---lazy

- (UIScrollView *)scroller{
    if (!_scroller) {
        _scroller =  [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scroller.backgroundColor = [UIColor whiteColor];
        _scroller.showsVerticalScrollIndicator = NO;
        _scroller.showsHorizontalScrollIndicator = NO;
    }
    return _scroller;
}

-(NSMutableArray *)dataSourceArr{

    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

-(NSMutableArray *)saveSelButValueArr{
    if (!_saveSelButValueArr) {
        _saveSelButValueArr = [[NSMutableArray alloc] init];
    }
    return _saveSelButValueArr;
}

- (NSMutableArray *)saveGroupIndexArr{
    if (!_saveGroupIndexArr) {
        _saveGroupIndexArr = [[NSMutableArray alloc] init];
    }
    return _saveGroupIndexArr;
}

#pragma mark---根据指定文本,字体和最大高度计算尺寸
- (CGSize)sizeWidthWidth:(NSString *)text font:(UIFont *)font maxHeight:(CGFloat)height{

    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
    return size;
}

@end
