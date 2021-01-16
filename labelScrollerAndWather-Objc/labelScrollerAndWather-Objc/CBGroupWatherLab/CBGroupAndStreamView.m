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
    _defaultSelectIndex = 0;

}

- (void)setContentView:(NSArray *)contenArr titleArr:(NSArray *)titleArr{

    //每次初始化view时，清除保存选择的值
    [self.saveSelButValueArr removeAllObjects];
    [self.saveGroupIndexArr removeAllObjects];

    _contetntArr = contenArr.count > 0 ? contenArr : _contetntArr;
    _titleArr = titleArr.count > 0 ? titleArr : _titleArr;

    if (_isDefaultSel && _defaultSelectIndexArr.count > 0) {
        NSAssert(!(_defaultSelectIndexArr.count < titleArr.count), @"设置默认选择数组，需与 titleArr 元素个数一至");
    }
    //设置rect的初始值
    self.frameRect = CGRectZero;
    //设置内容
    [self.dataSourceArr removeAllObjects];
    [self.dataSourceArr addObjectsFromArray:contenArr];

    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //设置默认的值，使保存值的数组是按照group的顺序来保存，便于后面对相应的group的值进行增改
        [self.saveSelButValueArr addObject:@""];
        [self.saveGroupIndexArr addObject:@""];
        //设置每一组的值，并返回最后一个frame
        @autoreleasepool {
            self.frameRect = [self setSignView:contenArr[idx] andTitle:titleArr[idx] andFrame:self.frameRect andGroupId:idx];
        }
    }];

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

    NSAssert(!(_defaultSelectIndex > dataAr.count - 1), @"groupId = %ld  _defaultSelectIndex = %ld  dataArrCount = %ld defaultSelectIndex 必须小于或等于 dataAr.count - 1",groupId,_defaultSelectIndex,dataAr.count);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, frame.size.height + frame.origin.y + 10, 0, _titleLabHeight)];
    label.font = _titleTextFont;
    label.text = titleStr;
    CGSize size = [self sizeWidthWidth:titleStr font:_titleTextFont maxHeight:_titleLabHeight];
    label.width = size.width;
    label.textColor = _titleTextColor;
    [self.scroller addSubview:label];

    __block CGRect rect = CGRectZero;
    __block CGFloat butHeight = _butHeight;
    __block CGFloat margainY = 5 + label.y + label.height;
    __block CGFloat but_totalHeight = margainY;
    __block CGFloat butorignX = _maragin_x;
    __block CGFloat alineButWidth = 0;
    __block CGRect current_rect;
    NSMutableArray * tempSelArr = [[NSMutableArray alloc] init];

    [dataAr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize contentSize = [self sizeWidthWidth:dataAr[idx] font:_font maxHeight:butHeight];
        //创建按钮
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitleColor:_contentNorColor forState:UIControlStateNormal];
        [but setTitleColor:_contentSelColor forState:UIControlStateSelected];
        [but setTitle:dataAr[idx] forState:UIControlStateNormal];
        [self.scroller addSubview:but];
        but.titleLabel.font = _font;

        // 九宫格算法，每行放三个 margainX+(i%3)*(butWidth + 10)  margainY+(i/3)*(butHeight+10)
        //处理标签流
        CGFloat butWidth = contentSize.width + 20;
        butorignX = alineButWidth + _maragin_x;
        if (butWidth > UIScreen.mainScreen.bounds.size.width - 2 * _maragin_x) {
            // 设置多行
            but.titleLabel.numberOfLines = 0;
            // 设置边距
            but.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
            butWidth = UIScreen.mainScreen.bounds.size.width - 2 * _maragin_x;
            butHeight = [self sizwWithHeight:dataAr[idx] font:_font maxWidth:butWidth - 20];

        }else{
            butHeight = _butHeight;
        }

        alineButWidth = _maragin_x + butWidth + alineButWidth;
        if (alineButWidth >= self.width) {
            butorignX = _maragin_x;
            alineButWidth = butorignX + butWidth;
            but_totalHeight = current_rect.size.height + current_rect.origin.y + _maragin_y;
        }

        but.frame = CGRectMake(butorignX, but_totalHeight, butWidth, butHeight);
        current_rect = but.frame;
        but.backgroundColor = _norColor;
        but.tag = groupId * 100 + idx + 1;
        //按钮样式
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        but.layer.cornerRadius = _radius;
        but.layer.masksToBounds = YES;
        //设置默认选择
        if (_isDefaultSel) {
            NSString *valueStr = [NSString stringWithFormat:@"%ld/%@",idx,dataAr[idx]];
            //设置默认选择以数组形式，则存在多选
            if (_defaultSelectIndexArr.count > 0) {
                //每个组单独设置默认选中值
                NSArray * selIndexArr = nil;
                NSNumber * indexNumber = nil;
                [_defaultSelectIndexArr[groupId] isKindOfClass:[NSArray class]] ? (selIndexArr = _defaultSelectIndexArr[groupId]) : (indexNumber = _defaultSelectIndexArr[groupId]);
                if (selIndexArr.count > 0) {
                    for (NSNumber * selIndex in selIndexArr) {
                        if (idx == [selIndex integerValue]) {
                            but.selected = YES;
                            but.backgroundColor = _selColor;
                            [tempSelArr addObject:valueStr];
                            break;
                        }
                    }
                }else{
                    if (idx == [indexNumber integerValue]) {
                        but.selected = YES;
                        [tempSelArr addObject:valueStr];
                        but.backgroundColor = _selColor;
                    }
                }

            }else{
                //统一设置默认选择值
                if (idx == _defaultSelectIndex) {
                    but.backgroundColor = _selColor;
                    but.selected = YES;
                    //保存默认选中按钮的值
                    if (_singleFlagArr.count > 0) {
                        //为每个组设置单选还是多选
                        [self.saveSelButValueArr replaceObjectAtIndex:groupId withObject:[_singleFlagArr[groupId] isEqual:@0] ? @[valueStr] : valueStr];
                    }else{
                        [self.saveSelButValueArr replaceObjectAtIndex:groupId withObject:_isSingle ? valueStr : @[valueStr]];
                    }
                }
            }
            //保存groupID
            [self.saveGroupIndexArr replaceObjectAtIndex:groupId withObject:[NSNumber numberWithInteger:groupId]];
        }
        if (idx == dataAr.count - 1) {
            //当最后一个按钮时，返回坐标
            rect = but.frame;
        }
    }];

    if (_defaultSelectIndexArr.count > 0 && _isDefaultSel) {
        [self.saveSelButValueArr replaceObjectAtIndex:groupId withObject:tempSelArr];
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
    [self.saveSelButValueArr[sender.tag / 100] isEqualToString:@""] ? [self.saveGroupIndexArr replaceObjectAtIndex:sender.tag / 100 withObject:@""] : [self.saveGroupIndexArr replaceObjectAtIndex:sender.tag / 100 withObject:[NSNumber numberWithInteger:sender.tag / 100]];
    //代理传值
    if ([self.delegate respondsToSelector:@selector(cb_selectCurrentValueWith:index:groupId:)]) {
        [self.delegate cb_selectCurrentValueWith:self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1] index:sender.tag % 100 - 1 groupId:sender.tag / 100];
    }
    //block传值
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

    valueStr = [NSString stringWithFormat:@"%ld/%@",sender.tag % 100 - 1,self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1]];

    if (sender.selected) {
        sender.backgroundColor = _selColor;
        if (![tempSaveArr containsObject:valueStr]) {
            [tempSaveArr addObject:valueStr];
        }
    }else{
        sender.backgroundColor = _norColor;
        [tempSaveArr removeObject:valueStr];
    }

    [self.saveSelButValueArr replaceObjectAtIndex:sender.tag / 100 withObject:tempSaveArr?tempSaveArr:@""];
    //保存groupID
    [self.saveSelButValueArr[sender.tag / 100] count] == 0 ? [self.saveGroupIndexArr replaceObjectAtIndex:sender.tag / 100 withObject:@""] : [self.saveGroupIndexArr replaceObjectAtIndex:sender.tag / 100 withObject:[NSNumber numberWithInteger:sender.tag / 100]];

    //传递当前选中的Value
    if ([self.delegate respondsToSelector:@selector(cb_selectCurrentValueWith:index:groupId:)]) {
        [self.delegate cb_selectCurrentValueWith:self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1] index:sender.tag % 100 - 1 groupId:sender.tag / 100];
    }

    if (_cb_selectCurrentValueBlock) {
        _cb_selectCurrentValueBlock(self.dataSourceArr[sender.tag / 100][sender.tag % 100 - 1],sender.tag % 100 - 1,sender.tag / 100);
    }
}

#pragma mark---确定
- (void)confirm{
    if ([self.delegate respondsToSelector:@selector(cb_confirmReturnValue:groupId:)]) {
        [self.delegate cb_confirmReturnValue:self.saveSelButValueArr groupId:self.saveGroupIndexArr];
    }
    if (_cb_confirmReturnValueBlock) {
        _cb_confirmReturnValueBlock(self.saveSelButValueArr,self.saveGroupIndexArr);
    }
}
#pragma mark---重置
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

- (void)setDefaultSelectIndexArr:(NSArray *)defaultSelectIndexArr{
    _defaultSelectIndexArr = defaultSelectIndexArr;
    //判断是否有数组
    __weak typeof(self) weakself = self;
    [_defaultSelectIndexArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(self) strongself = weakself;
        if ([obj isKindOfClass:[NSArray class]]) {

            if ([strongself.singleFlagArr[idx] isEqual:@1] && strongself.singleFlagArr.count > 0) {
                //当设置默认选中的为一个数组时，但设置分组的为单选，则要将改为多选
                NSMutableArray * arr = [NSMutableArray arrayWithArray:strongself.singleFlagArr];
                [arr replaceObjectAtIndex:idx withObject:@0];
                strongself.singleFlagArr = arr;
            }
        }
        if (!([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSArray class]])) {
            NSAssert(![obj isEqual:@""], @"defaultSelectIndexArr 数组元素只能是 NSNumber 或 NSArray<NSNumber *>");
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

- (CGFloat)sizwWithHeight:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width{

    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
    return size.height + 15;
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}

@end
