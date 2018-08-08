# labelGroupAndStream

### 属性介绍
```
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

```

### 使用方法
```
 NSArray * titleArr = @[@"关系",@"花",@"节日",@"枝数"];
    NSArray *contentArr = @[
    @[@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他"],
    @[@"玫",@"百合",@"康乃馨",@"郁金香",@"扶郎",@"马蹄莲"],
    @[@"情人节",@"母亲节",@"圣诞节",@"元旦节",@"春节",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他"],
    @[@"9枝",@"100000000枝",@"11枝",@"21枝",@"33枝",@"99枝",@"99999999枝以上",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他"]];
    
CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    silde.delegate = self; //设置代理
    silde.isDefaultSel = NO; //是否默认选中
    silde.isSingle = YES; // 是否单选
    silde.radius = 10; //设置圆角
    silde.font = [UIFont systemFontOfSize:12]; //设置字体
    silde.titleTextFont = [UIFont systemFontOfSize:18]; //设置标题的字体
    silde.singleFlagArr = @[@0,@1,@1,@0]; //设置每个分组的单选或多选
    [silde setContentView:contentArr titleArr:titleArr]; // 设置数据
    [self.view addSubview:silde];
```

<iframe height=500 width=500 src="http://ww4.sinaimg.cn/mw690/e75a115bgw1f3rrbzv1m8g209v0diqv7.gif">
