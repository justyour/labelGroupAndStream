//
//  ViewController.m
//  labelScrollerAndWather-Objc
//
//  Created by kms on 2018/8/7.
//  Copyright © 2018年 KMS. All rights reserved.
//

#import "ViewController.h"
#import "CBGroupAndStreamView.h"
@interface ViewController ()<CBGroupAndStreamDelegate>

@property (strong, nonatomic) CBGroupAndStreamView * menueView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"GroupAndStream";

    UIButton * leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBut setTitle:@"重置" forState:UIControlStateNormal];
    [leftBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [leftBut setFrame:CGRectMake(0, 0, 40, 40)];
    leftBut.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    [leftBut addTarget:self action:@selector(resetSelt) forControlEvents:UIControlEventTouchUpInside];

    UIButton * rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setTitle:@"确定" forState:UIControlStateNormal];
    [rightBut setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightBut.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    [rightBut addTarget:self action:@selector(confirmSelt) forControlEvents:UIControlEventTouchUpInside];


    NSArray * titleArr = @[@"关系",@"花",@"节日",@"枝数"];
    NSArray *contentArr = @[@[@"绝代有佳人，幽居在空谷。自云良家子，零落依草木。关中昔丧败，兄弟遭杀戮。官高何足论，不得收骨肉。世情恶衰歇，万事随转烛。夫婿轻薄儿，新人美如玉。合昏尚知时，鸳鸯不独宿。但见新人笑，那闻旧人哭。在山泉水清，出山泉水浊。侍婢卖珠回，牵萝补茅屋。摘花不插发，采柏动盈掬。天寒翠袖薄，日暮倚修竹",@"岱宗夫如何，齐鲁青未了。造化钟神秀，阴阳割昏晓。  荡胸生层云，决眦入归鸟。会当凌绝顶，一览众山小",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他"],@[@"玫",@"百合",@"康乃馨",@"郁金香",@"扶郎",@"马蹄莲"],@[@"人生不相见，动如参与商。今夕复何夕，共此灯烛光。少壮能几时，鬓发各已苍。访旧半为鬼，惊呼热中肠。焉知二十载，重上君子堂。昔别君未婚，儿女忽成行。怡然敬父执，问我来何方。问答乃未已，驱儿罗酒浆。主称会面难，一举累十觞。十觞亦不醉，感子故意长。明日隔山岳，世事两茫茫。",@"母亲节",@"圣诞节",@"元旦节",@"春节",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他"],@[@"9枝",@"100000000枝",@"11枝",@"21枝",@"33枝",@"99枝",@"99999999枝以上",@"恋人",@"燕草如碧丝，秦桑低绿枝。当君怀归日，是妾断肠时。春风不相识，何事入罗帏。",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他",@"恋人",@"朋友朋友朋友朋友朋友朋友",@"亲人恩师恩师",@"恩师恩师",@"病人",@"其他",@"恋人",@"常恨言语浅，不如人意深。今朝两相视，脉脉万重心",@"亲人恩师恩师",@"恩师恩师",@"病人",@"绝代有佳人，幽居在空谷。自云良家子，零落依草木。关中昔丧败，兄弟遭杀戮。官高何足论，不得收骨肉。世情恶衰歇，万事随转烛。夫婿轻薄儿，新人美如玉。合昏尚知时，鸳鸯不独宿。但见新人笑，那闻旧人哭。在山泉水清，出山泉水浊。侍婢卖珠回，牵萝补茅屋。摘花不插发，采柏动盈掬。天寒翠袖薄，日暮倚修竹"]];

    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    silde.delegate = self;
    silde.isDefaultSel = YES;
    silde.isSingle = YES;
    silde.radius = 10;
    silde.font = [UIFont systemFontOfSize:12];
    silde.titleTextFont = [UIFont systemFontOfSize:18];
    silde.singleFlagArr = @[@1,@0,@1,@0];
    silde.defaultSelectIndex = 5;
    silde.defaultSelectIndexArr = @[@0,@[@1,@3],@0,@[@1,@9,@4]];
    silde.selColor = [UIColor orangeColor];
    [silde setContentView:contentArr titleArr:titleArr];
    [self.view addSubview:silde];
    _menueView = silde;
    silde.cb_confirmReturnValueBlock = ^(NSArray *valueArr, NSArray *groupIdArr) {
         NSLog(@"valueArr = %@ \ngroupIdArr = %@",valueArr,groupIdArr);
    };
    silde.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
        NSLog(@"value = %@----index = %ld------groupId = %ld",value,index,groupId);
    };

}

- (void)resetSelt{
    [_menueView reset];
}

- (void)confirmSelt{
    [_menueView confirm];
}


#pragma mark---delegate
- (void)cb_confirmReturnValue:(NSArray *)valueArr groupId:(NSArray *)groupIdArr{
     NSLog(@"valueArr = %@ \ngroupIdArr = %@",valueArr,groupIdArr);
}

- (void)cb_selectCurrentValueWith:(NSString *)value index:(NSInteger)index groupId:(NSInteger)groupId{
    NSLog(@"value = %@----index = %ld------groupId = %ld",value,index,groupId);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
