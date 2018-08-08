//
//  CBGroupAndStreamView.h
//
//
//  Created by kms on 2017/5/23.
//  Copyright © 2017年 KMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cb_ConfirmReturnValueBlock)(NSArray * valueArr, NSArray * groupIdArr);

typedef void(^cb_SelectCurrentValueBlock)(NSString * value, NSInteger index, NSInteger groupId);

@protocol CBGroupAndStreamDelegate <NSObject>


/**
 传全部选中的选项，以数组形式传出

 @param valueArr 选中的值数组，以选择的 index和title拼接，以 / 分割的字符串
 @param groupIdArr 选中所属组的ID 以 NSNumber 类型 保存
 */
- (void)cb_confirmReturnValue:(NSArray *)valueArr groupId:(NSArray *)groupIdArr;

/**
 当前选择的值

 @param value Value
 @param index index
 @param groupId groupId
 */
- (void)cb_selectCurrentValueWith:(NSString *)value index:(NSInteger)index groupId:(NSInteger)groupId;

@end

@interface CBGroupAndStreamView : UIView

@property (weak,nonatomic) id <CBGroupAndStreamDelegate>delegate;

/**
 是否单选 YES 为单选，默认为YES 在设置了 singleFlagArr 属性后 则该属性无效
 */
@property (assign, nonatomic) BOOL isSingle;

/**
 是否默认选择 ，默认为YES，选中第一个
 */
@property (assign, nonatomic) BOOL isDefaultSel;

/**
 默认颜色
 */
@property (strong, nonatomic) UIColor * norColor;

/**
 选中颜色
 */
@property (strong, nonatomic) UIColor * selColor;

/**
 文字默认颜色
 */
@property (strong, nonatomic) UIColor * contentNorColor;

/**
 文字选中颜色
 */
@property (strong, nonatomic) UIColor * contentSelColor;

/**
 文字字体
 */
@property (strong, nonatomic) UIFont * font;

/**
 按钮高度，默认 30
 */
@property (assign, nonatomic) CGFloat butHeight;

/**
 圆角 默认 radius = 6
 */
@property (assign, nonatomic) CGFloat radius;

/**
 标题颜色
 */
@property (strong, nonatomic) UIColor * titleTextColor;

/**
 标题字体
 */
@property (strong, nonatomic) UIFont * titleTextFont;

/**
 标题高度，默认为 30
 */
@property (assign, nonatomic) CGFloat titleLabHeight;

/**
 两按钮左右之间的距离 默认 为 10
 */
@property (assign, nonatomic) CGFloat maragin_x;

/**
 两按钮上下之间的距离 默认为 10
 */
@property (assign, nonatomic) CGFloat maragin_y;

/**
 block  调用 confirm  传所有选中的选项
 */
@property (copy, nonatomic) cb_ConfirmReturnValueBlock cb_confirmReturnValueBlock;
/**
 block  传当前选中的选项
 */
@property (copy, nonatomic) cb_SelectCurrentValueBlock cb_selectCurrentValueBlock;

/**
 设置改属性 则 isSingle 无效
 为每一个分组单独设置 单选或多选, 为 NSNumber 类型，count 必须设置与数据源的 titleArr.count 一致
 只传 0 和 1， 0 表示 多选， 1 表示 单选
 */
@property (copy, nonatomic) NSArray <NSNumber *> * singleFlagArr;

/**
 设置数据源, 一定要在属性设置完成后在调用，否则只会显示默认的属性

 @param contenArr 内容
 @param titleArr 标题
 */
- (void)setContentView:(NSArray *)contenArr titleArr:(NSArray *)titleArr;


/**
 选择完成-传全部选中的数据，以数组的形式传出，需实现代理接收数据
 */
- (void)confirm;

/**
 重置
 */
- (void)reset;

@end
