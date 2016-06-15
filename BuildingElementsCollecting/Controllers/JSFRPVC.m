//
//  JSBlockCalculateVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/6/2.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSFRPVC.h"
#import "JSReactivePerson.h"
#import "NSObject+JSKVO.h"
#import "ReactiveCocoa.h"
#import "RACReturnSignal.h"
#import "JSFlag.h"
#import "NSObject+RACKVOWrapper.h"
#import "JSTestRacSignal2ndVC.h"

@interface JSFRPVC() {
    JSReactivePerson *_p;
    UIView *_back;
    RACSubject *_btnClickSignal;
    
    NSMutableDictionary *_dict;
    UIButton *_btn;
    UITextField *_textF;
    
    RACSubject *_tempS;
    int i;
}

@property (nonatomic, strong) RACCommand *command;

@end

@implementation JSFRPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    self.titlesArr = @[@"KVO",
                       @"testRac",
                       @"testRac1(取消订阅）",
                       @"testRac2(RACSubject的实践)",
                       @"dicRac(一次次传出字典中的键值对）",
                       @"arrRac(便利数组中的元素一个一个发出来）",
                       @"testRac3（字典转模型？）",
                       @"racReplaceKVOandNotiandDelegate（rac的kvoblock",
                       @"racReplaceDelegateEasyCode页面跳转之间的信号代替代理的实践",
                       @"explainRACReplaySubject先发消息再订阅",
                       @"explainRACSubject先订阅再发送",
                       @"testRACMulticastConnection防止重复发信号？",
                       @"testRACCommand不太懂",
                       @"uniformlyHandleSeveralSignals统一处理信号结果",
                       @"commonMacroOfRAC常用宏",
                       @"coreMethodsBind核心方法",
                       @"coreMethodsMap1简单用法",
                       @"coreMethodsFlattenMap",
                       @"coreMethodsMap",
                       @"combindedCoreMethods组合信号",
                       @"racZipTest夫妻关系所有信号都发送内容才回调用",
                       @"racMergeTest",
                       @"testThen",
                       @"testConcat与上面的相反，可以连接前后信号的数据",
                       @"coreMethodsFilter测试过滤，textF的长度大于3才能获取信号值",
                       @"testIgnore",
                       @"testTake这也是过滤信号,区前面或后面几个或通过信号来中断",
                       @"distinctUntilChanged保证订阅值和之前的不同",
                       @"skipTest跳过前面的几个信号"];
    
    self.selectorsArr = @[@"KVO",
                          @"testRac",
                          @"testRac1",
                          @"testRac2",
                          @"dictRac",
                          @"arrRac",
                          @"testRac3",
                          @"racReplaceKVOandNotiandDelegate",
                          @"racReplaceDelegateEasyCode",
                          @"explainRACReplaySubject",
                          @"explainRACSubject",
                          @"testRACMulticastConnection",
                          @"testRACCommand",
                          @"uniformlyHandleSeveralSignals",
                          @"commonMacroOfRAC",
                          @"coreMethodsBind",
                          @"coreMethodsMap1",
                          @"coreMethodsFlattenMap",
                          @"coreMethodsMap",
                          @"combindedCoreMethods",
                          @"racZipTest",
                          @"racMergeTest",
                          @"testThen",
                          @"testConcat",
                          @"coreMethodsFilter",
                          @"testIgnore",
                          @"testTake",
                          @"distinctUntilChanged",
                          @"skipTest"];
}

- (void)testRac {
    //RACSignal:有数据产生的时候，就用racsignal
    //racsignal使用步骤:1.创建信号 2.订阅信号 3.发送信号
    
    RACDisposable *(^didSubscribe)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber> subscriber) {
        //didSubscribe调用:只要一个信号被订阅就会调用
        //didSubscribe作用：发送数据
        NSLog(@"信号被订阅");
        [subscriber sendNext:@1];
        return nil;
    };
    
    //1.创建信号（冷信号）
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    //没被订阅的信号中block不会调用
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"s1被订阅");
        [subscriber sendNext:@2];
        return nil;
    }];
    
    //2.订阅信号（热信号)
    [signal subscribeNext:^(id x) {
        //这里的block只要订阅者发送数据就会调用
        //这里可以处理数据后展示到UI上面
        
        //x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    //只要订阅者调用sendNext就会执行nextblock
    //订阅racdynamicsignal会执行didsubscribe
    //不同类型信号的订阅，处理订阅的事情不一样
}

- (void)testRac1 {
    RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"hello"];
        
        return [RACDisposable disposableWithBlock:^{
            // 信号取消订阅跳这里
            // 清空资源
            NSLog(@"%@取消订阅了", subscriber);
        }];
    }];
    
    //订阅信号
    RACDisposable *dixposable = [s subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //1.创建订阅者，保存nextblock
    //2.订阅信号
    
    //默认一个信号发送数据完毕会主动取消订阅
    //订阅者在时不会自动取消信号订阅
    
    //取消订阅
    [dixposable dispose];
}

- (void)testRac2 {
    [self addBack];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(50, 70, 200, 140)];
    v.backgroundColor = [UIColor orangeColor];
    [_back addSubview:v];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 160, 30)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"被监听的按钮" forState:UIControlStateNormal];
    [v addSubview:btn];
    if (_btnClickSignal == nil) {
        _btnClickSignal = [RACSubject subject];
    }
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, 160, 30)];
    [_btnClickSignal subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)x;
            NSLog(@"second：Signal：%@", dic[@"signal"]);
        } else {
            NSLog(@"这是按钮点击发出的signal:%@", x);
        }
    }];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"发第二个信号" forState:UIControlStateNormal];
    [v addSubview:btn1];
    btn1.tag = 101;
    [btn1 addTarget:self action:@selector(transmitSignal:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick {
    [_btnClickSignal sendNext:@"按钮点击了呢"];
}
- (void)transmitSignal:(UIButton *)sender {
    NSDictionary *dict = @{@"tag": [NSNumber numberWithLong:sender.tag],
                           @"signal": @"btn1's signal: hello world"};
    [_btnClickSignal sendNext:dict];
}

- (void)dictRac {
    NSDictionary *dic = @{@"account": @"zjs", @"password": @"zonejs"};
    //转成集合
    [dic.rac_sequence.signal subscribeNext:^(id x) {
        NSString *key = x[0];
        NSString *value = x[1];
        NSLog(@"%@: %@", key, value);
        
        //ractupleunpack:用来解析元组
        //宏里面的参数传需要解析出来的变量名
        // 右边放需要解析的元组
        RACTupleUnpack(NSString *k, NSString *v) = x;
        NSLog(@"%@::%@", k, v);
    }];
}
- (void)arrRac {
    NSArray *arr = @[@"1", @"2", @"3"];
    
    //rac集合
    RACSequence *sequence = arr.rac_sequence;
    //集合转成信号
    RACSignal *signal = sequence.signal;
    //订阅集合信号，内部会自动便利所有元素发出来
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //即
//    [arr.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
}
- (void)testRac3 {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    
//    array 把集合转成数组
//    map 映射的意思 把原始值value映射成一个新的值
    NSArray *a = [[arr.rac_sequence map:^id(id value) {
        //value 集合中的元素
        //id 返回对象就是映射的值
//        底层实现：信号被订阅时遍历集合中的原始值，映射成新的值，保存到新的数组里
        return [JSFlag flagWithDict:value];
    }] array];
    NSLog(@"%@", a);
}

- (void)racReplaceKVOandNotiandDelegate {
    [self addBack];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(50, 70, 200, 140)];
    v.backgroundColor = [UIColor orangeColor];
    [_back addSubview:v];
    [v rac_observeKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"value(id): %@\n change(nsdictionary): %@\n causedByDealloc(BOOL): %d\n affectedOnlyLastComponent: %d\n",value, change, causedByDealloc, affectedOnlyLastComponent);
    }];
//    value(id): NSPoint: {60, 110}
//    change(nsdictionary): {
//        kind = 1;
//        new = "NSPoint: {60, 110}";
//    }
//    causedByDealloc(BOOL): 0
//     affectedOnlyLastComponent: 1
    [[v rac_valuesForKeyPath:@"center" observer:nil] subscribeNext:^(id x) {
        //x 修改的值
        NSLog(@"center修改的值：%@", x);
    }];
//    center修改的值：NSPoint: {150, 140}
//    center修改的值：NSPoint: {60, 110}
    
    v.center = CGPointMake(60, 110);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 160, 30)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"被监听的按钮" forState:UIControlStateNormal];
    [btn addTarget:nil action:@selector(btnsClick) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"这里是按钮点击发出的信号");
    }];
    
    //考虑用rac代替代理
    [[v rac_signalForSelector:@selector(btnsClick)] subscribeNext:^(id x) {
        NSLog(@"v知道了btnsClick方法的点击,666");
    }];
    
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, 160, 30)];
    [v addSubview:textF];
    //文本框也可以监听
    [textF.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"这是改变的值吗：%@", x);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"小心：warning：keyboard will show, show time!!!");
    }];

}
- (void)btnsClick {
    i += 1;
        if (_textF) {
            _textF.text = [NSString stringWithFormat:@"变化测试——textf的KVO%d", i];
        }
    if (_tempS) {
        [_tempS sendNext:[NSString stringWithFormat:@"hello%d", i]];
    }
    NSLog(@"controlstate:%lu", (unsigned long)_btn.state);
    return;
}

- (void)racReplaceDelegateEasyCode {
    JSTestRacSignal2ndVC *vc = [JSTestRacSignal2ndVC new];
    vc.delegateSignal = [RACSubject subject];
    [vc.delegateSignal subscribeNext:^(id x) {
        NSLog(@"预计应该在push到2ndvc后出现这段文字");
    }];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)explainRACSubject {
//    RACSubjcet的使用步骤
//    1.创建信号 ［racsubject subject］同signal不同的是创建时没有block
//    2.订阅信号 ［subject subscribenext：］
//    3.发出信号 subject send next：］
    
//    racsubject的底层实现同signal是不同的
//    subscribenext订阅信号 只是把订阅者保存起来 这时订阅者的nextblock已经赋值
//    sendnext发送信号时是遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextblock
    
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"这厮第一个订阅者：%@", x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个？:%@", x);
    }];
    [subject sendNext:@"😄"];
    [subject sendNext:@"😢"];
}

- (void)explainRACReplaySubject {
    //    racreplaysubject使用
    //    差不多吧
    //    他的底层实现和racsubject不一样
    //    调用sendnext发送信号，把值保存起来，遍历刚刚保存的所有订阅者，一个一个调用nextblock
    //    调用subscribenext订阅信号，便利保存的所有值，一个一个调用订阅者的nextblock
    
    //    当一个信号被订阅就播放之前的所有值，就需先发送信号，再订阅信号
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@"第一发子弹"];
    [replaySubject sendNext:@"第二发"];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一发订阅者:%@", x);
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二发订阅者%@", x);
    }];
}

- (void)testRACMulticastConnection {
//    1.创建信号2.创建连接3.订阅信号4.连接
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"创建发送了一个请求哟");
        [subscriber sendNext:@"请求哟"];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"收到1:%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"收到2:%@", x);
    }];
    //结果：2次，每次订阅都会发送一次请求
    
//    用racmulticastconnection可以解决重复请求的问题
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"不重复发送的请求");
        [subscriber sendNext:@"不重复的请求:接下来发生什么呢"];
        return nil;
    }];
    //创建连接
    RACMulticastConnection *connect = [signal1 publish];
    //3.订阅信号，不能激活信号，只是保存订阅者到数组，必须通过连接，当调用连接，就会一次调用所有订阅者的sendnext
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"connect:订阅者1");
    }];
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"connect:订阅者2");
    }];
    //连接激活信号
    [connect connect];
}
- (void)testRACCommand {
    //注意：
    //    signalblock需要传回一个不为nil的signal，不想传递则用［racsignal empty］
    //    raccommand中信号传递完数据的话要调用［subscriber sendcompleted］这时命令就算执行完了，否则永远处于执行中
    //    raccommand需要被强引用，否则收不到raccommand中的信号，raccomand中的信号时延迟发送的
    
    //    raccommand的设计思路－－－－－－－－－－－－－》1
    //    signalblock中返回的信号signal有什么用？
    //    开发中我们常常把网络的请求封装到raccommand，执行某个raccommand就可以发送请求
    //    raccommand内部请求到数据的时候要把请求的数据传递给外界，这时可以通过signalblock返回的信号来传递
    
    //    接收处理raccommand返回信号发出的数据－－－－－－－－－－－》2
    //    通过raccommand的executionsignals，这个是signal of signals（信号的数据（信号））这时信号发出的数据是信号，不是普通的类型
    //    订阅executionsignals就可以拿到raccommand中返回的信号，然后订阅signalblock返回的信号，就可以获取发出的是什么了
    
//    1创建命令2在signalblock中创建racsignal作为signalblock的返回值3.执行命令execute
//    id input 是执行命令传入的参数 如［command execute：@“input”］中的@“input”
//    这里的signalblock会在执行命令（execute）的时候调用
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令如网络请求等--input:%@", input);
        //创建空的信号
//        return [RACSignal empty];
//        创建信号用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"这里是请求的数据，比如网络数据？"];
            //数据传递完毕请使用sendcompleted,命令就会执行完毕
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //执行命令
    RACSignal *signal = [_command execute:@"input"];
    [signal subscribeNext:^(id x) {
        NSLog(@"执行命令拿到的是sendnex：这是请求的数据吧啦吧啦？：%@", x);
    }];
    //订阅raccommand中的信号
    [_command.executionSignals subscribeNext:^(id x) {
        NSLog(@"x: %@", x);
        [x subscribeNext:^(id x) {
            NSLog(@"x:%@", x);
        }];
    }];
    [_command.executing subscribeNext:^(id x) {
        NSLog(@"x: %@", x);
    }];
    
    
//    rac高级用法
//    switchtolates用于signal of signals，获取signal of signals 发出的最新信号，也就是可以直接拿到raccommand中的信号
    [_command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"x: %@", x);
    }];
    
    //监听命令是否执行完毕，默认会来一次，可以直接跳过，skip表示跳过第一次信号
//    [[_command.executing skip:0] subscribeNext:^(id x) {
//        if ([x boolValue] == YES) {
//            NSLog(@"正在执行");
//        } else {
//            NSLog(@"执行完成");
//        }
//    }];
}

//处理多个请求都返回结果的时候统一做处理
- (void)uniformlyHandleSeveralSignals {
    RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"这是%@的s", subscriber);
        [subscriber sendNext:@"s"];
        return nil;
    }];
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"这是%@的s1", subscriber);
        [subscriber sendNext:@"s1"];
        return nil;
    }];
    //有几个信号方法里就有几个参数，它们一一对应
    [self rac_liftSelector:@selector(updateUIWIthR1:r2:) withSignals:s, s1, nil];
}
- (void)updateUIWIthR1:(id)data r2:(id)data1 {
    NSLog(@"通过数据R1:%@, r2: %@来更新UI", data, data1);
}

//常用宏
- (void)commonMacroOfRAC {
    //包装元组 tuple
    RACTuple *tuple = RACTuplePack(@1, @"zjs");
    NSLog(@"tuple: %@, tuple[1]: %@", tuple, tuple[1]);
    
    _dict = [NSMutableDictionary dictionary];
    [self addBack];
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 160, 30)];
    [_back addSubview:textF];
    textF.backgroundColor = [UIColor grayColor];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 160, 30)];
    [_back addSubview:lbl];
    lbl.backgroundColor = [UIColor greenColor];
    
//    给某个类的某个属性绑定一个信号，接收信号就会改变类的属性
//    文本框的文字改变就改lbl的文字，amazing！！！
    RAC(lbl, text) = textF.rac_textSignal;
//    保存文字到字典,这招贼记吧方便啊
    [textF.rac_textSignal subscribeNext:^(id x) {
        _dict[@"1"] = x;
    }];
    
    //监听某个对象的属性转化为信号
    [RACObserve(textF, center) subscribeNext:^(id x) {
        NSLog(@"x :%@", x);
    }];
    textF.center = CGPointMake(130, 100);
}

//核心操作方法
- (void)coreMethodsBind {
    [self addBack];
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 160, 30)];
    [_back addSubview:textF];
    textF.backgroundColor = [UIColor grayColor];
    //目的：监听文本框的内容，在每次输出结果时拼接一段文字“输出”
    
//    method1 返回结果后拼接
    [textF.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"输出: %@", x);
    }];
    
//    method2 返回结果前拼接 bind
//    bind方法参数：传回一个racstreambinblock的block参数
//    racstreambindblock是一个block类型，返回值是信号，参数value stop参数的block返回值也是一个block
    
//    racstreambindblock：
//    value：接受到信号的原始值，没做处理    ＊stop控制绑定block ＊stop＝yes就会结束绑定
//    返回值：信号，做好处理，通过这个信号返回出去，一般用racreturnsignal
    
//    步骤：1.bind：返回值是racstreambindblock的block
//    2.描述一个racstreambindblock类型的bindblock作为block返回值－－－－－》line：478
//    3.描述一个返回结果的信号作为bindblock的返回值
    
//    底层实现
//    1 原信号调用bind，（重新）创建一个绑定信号
//    2.绑定信号被订阅，会调用绑定信号中的didsubscribe，生成一个bindingblock
//    3.原信号有内容发出时，会把内容传到bindingblock处理，调用bindingblock（value， stop）
//    4.bindingblock会处理信号后返回一个处理过的信号
//    5.订阅racreturnsignal，可以拿到bindingblock的信号订阅者，把处理完成的信号发送出来
    
//    不同订阅者保存不同的nextblock，看源码时注意看清订阅者是哪一个
    
    
    [[textF.rac_textSignal bind:^RACStreamBindBlock{
//        什么时候调用：我怎么知道？？
//        block作用：绑定了一个信号
        
        return ^RACStream *(id value, BOOL *stop) {
            //信号有新的值发出时就会来到这个block
//            在这里可以做返回值的处理
//            处理好以后通过信号返回出去
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出1:%@", value]];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"x: %@", x);
    }];
}
- (void)coreMethodsMap1 {//通过订阅映射的型号来加一步中间操作步骤？？
    RACSubject *subject = [RACSubject subject];
    //绑定信号
    RACSignal *bindSignal = [subject map:^id(id value) {
        //返回的类型，即需要映射的值
//        信号没有绑定的话是不会调用
        return [NSString stringWithFormat:@"zjs: %@", value];
    }];
    //订阅绑定信号
//    [bindSignal subscribeNext:^(id x) {
//        NSLog(@"订阅绑定信号: %@", x);
//    }];
    
    [subject sendNext:@"hello"];
    [subject sendNext:@"world"];
}
- (void)coreMethodsFlattenMap {
    RACSubject *subject = [RACSubject subject];
    //绑定信号
    RACSignal *bindSignal = [subject flattenMap:^RACStream *(id value) {
        //block 只要源信号发送内容就会调用 666
        //value 源信号发送的内容
        
        value = [NSString stringWithFormat:@"必须要字符串?: %@", value];
        // 返回信号用来包装成修改内容值
        return [RACReturnSignal return:value];
    }];
//    flattenmap中返回的是什么信号订阅的就是什么信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"bindsignal: %@", x);
    }];
    
    [subject sendNext:@"zjs hello world"];
}
- (void)coreMethodsMap {
//    flattenmap 用于信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    [signalOfsignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"signalofsignals-->x: %@", x);
        }];
    }];
    RACSignal *bindSignal = [signalOfsignals flattenMap:^RACStream *(id value) {
        //value 源信号发送的内容
        return value;
    }];
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"bindsignal : %@", x);
    }];
    
    [signalOfsignals sendNext:signal];
    [signal sendNext:@"subject"];
}
//过滤
- (void)coreMethodsFilter {
    [self addTextF];
    [[_textF.rac_textSignal filter:^BOOL(id value) {
        return [value length] > 3;
        //value 是源信号的内容
//        返回值是过滤的条件，应该是满足这里的返回值的条件的时候才能订阅信号获取信号的内容
        
    }] subscribeNext:^(id x) {
        NSLog(@"这里是给textF的rac_textSignal加了长度大于3才会产生的限制:%@", x);
    }];
    
}
- (void)testIgnore {
    RACSubject *s1 = [RACSubject subject];
    RACSignal *ignoreS = [s1 ignore:@"hello"];
    [ignoreS subscribeNext:^(id x) {
        NSLog(@"忽略策略后的结果: %@", x);
    }];
    [s1 sendNext:@"hello"];
    [s1 sendNext:@"world"];
}
- (void)testTake {
    RACSubject *s1 = [RACSubject subject];
    RACSubject *s2 = [RACSubject subject];
    
//    take 取前面几个值，takelast 取后面多少个值必须要发送完成，takeuntil传入信号发送完成或发送任意数据就不能接受源信号的内容
    [[s1 takeUntil:s2] subscribeNext:^(id x) {
        NSLog(@"takeuntil: %@", x);
    }];//1 2
    [[s1 takeLast:2] subscribeNext:^(id x) {
        NSLog(@"takelast: %@", x);
    }];//3 4
    [[s1 take:1] subscribeNext:^(id x) {
        NSLog(@"take: %@", x);
    }];//1
    
    [s1 sendNext:@"1"];
    [s1 sendNext:@"fuck"];
    [s1 sendNext:@2];
    [s2 sendNext:@"heeh"];
    [s1 sendNext:@3];
    [s1 sendNext:@4];
    [s1 sendCompleted];
}
- (void)distinctUntilChanged {//过滤之－－当上一个值和目前的值相同时就不会被订阅到,不能保证和上上次的不同
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"这里可以保证和上一次的不同哦: %@", x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2];
    [subject sendNext:@1];
    [subject sendNext:@3];
}
- (void)skipTest {
    //跳过前面的某几个信号值
    RACSubject *s  = [RACSubject subject];
    [[s skip:1] subscribeNext:^(id x) {
        NSLog(@"跳过第一个哦耶: %@", x);
    }];
    
    [s sendNext:@2];
    [s sendNext:@"afdas"];
    [s sendNext:@"这是第三个"];
}

//组合
- (void)combindedCoreMethods {
    [self addBack];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 160, 30)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"被监听的按钮" forState:UIControlStateNormal];
    [btn addTarget:nil action:@selector(btnsClick) forControlEvents:UIControlEventTouchUpInside];
    [_back addSubview:btn];
    btn.hidden = YES;
    
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, 200, 30)];
    [_back addSubview:textF];
    textF.backgroundColor = [UIColor grayColor];
    UITextField *textF1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, 200, 30)];
    [_back addSubview:textF1];
    textF1.backgroundColor = [UIColor orangeColor];
//    组合哪些信号 reduce聚合
    RACSignal *combineSignal = [RACSignal combineLatest:@[textF.rac_textSignal, textF1.rac_textSignal] reduce:^id(NSString *text, NSString *text1){
        //源信号发送内容会调用，组合成一个新的值
        NSLog(@"text: %@, text1: %@", text, text1);
//        组合的值就是组合信号的内容
        
        return @(text.length && text1.length);
    }];
    //订阅信号
    [combineSignal subscribeNext:^(id x) {
        btn.hidden = ![x boolValue];
    }];
    
    //同上的
//    RAC(btn, hidden) = combineSignal;
}
//夫妻关系
- (void)racZipTest {
    [self addBtn];
    [self addTextF];
    _btn.enabled = YES;
    RACSubject *signal1 = [RACSubject subject];
    RACSubject *signal2 = [RACSubject subject];
    _tempS = signal2;
    
//    zipwith 一个界面多个请求的时候，等所有请求完成(每个信号都发出过）才能更新UIImage
//    即 所有信号都发送内容的时候才回调用
    RACSignal *zipSignal = [signal1 zipWith:signal2];
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"x会是什么呢： %@", x);
    }];
    
    [signal1 sendNext:@1];
    NSLog(@"controlstate:%lu", (unsigned long)_btn.state);
    [_btn setTitle:@"测试zipwith的btn" forState:UIControlStateNormal];
    [_btn rac_observeKeyPath:@"state" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"\nvalue(id): %@\nchange(nsdict): %@\n causedbydealloc: %d\n, affectedonlyLastcomponet(bool): %d\n", value, change, causedByDealloc, affectedOnlyLastComponent);
    }];
    [_textF rac_observeKeyPath:@"text" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"\nvalue(id): %@\nchange(nsdict): %@\n causedbydealloc: %d\n, affectedonlyLastcomponet(bool): %d\n", value, change, causedByDealloc, affectedOnlyLastComponent);
    }];
//    [_textF.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
}
- (void)racMergeTest {
    RACSubject *s1 = [RACSubject subject];
    RACSubject *s2 = [RACSubject subject];
    RACSignal *mergeS = [s1 merge:s2];
    [mergeS subscribeNext:^(id x) {
        NSLog(@"任意一个请求完成都会来哦：%@", x);
    }];
    
    [s2 sendNext:@"s2"];
    [s1 sendNext:@"s1"];
}
//可以用来做优先的排序，then后面的信号优先
- (void)testThen {
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"发送上部分数据?"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"发送下部分数据"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    //组合信号 then会忽略第一个信号的所有值
    RACSignal *thenS = [s1 then:^RACSignal *{
        return s2;
    }];
    [thenS subscribeNext:^(id x) {
        NSLog(@"then组合s1和s2得到了啥呢啊啊啊：%@", x);
    }];
}
//与上面的相反，是用来连接前后信号的数据的
- (void)testConcat {
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"下部分数据"];
        [subscriber sendCompleted];
        
        return nil;
    }];
//    concat 按顺序去连接，前一个信号必须调sendcompleted后才回连接后面的信号数据
//    组合信号
    RACSignal *concatS = [s1 concat:s2];
    
    //订阅组合的信号
    [concatS subscribeNext:^(id x) {
        NSLog(@"这是利用concat组合的信号，它的结果会是什么呢： %@", x);
    }];
    
//    result：
//    是利用concat组合的信号，它的结果会是什么呢： 上部分数据
//    是利用concat组合的信号，它的结果会是什么呢： 下部分数据
}

- (void)addBack {
    UIView *back = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    back.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [[UIApplication sharedApplication].keyWindow addSubview:back];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct)];
    [back addGestureRecognizer:g];
    _back = back;
}
- (void)addBtn {
    if (!_back) {
        [self addBack];
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 200, 30)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"自定义的的按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnsClick) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
    [_back addSubview:btn];
}
- (void)addTextF {
    if (!_back) {
        [self addBack];
    }
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(70, 100, 160, 30)];
    [_back addSubview:textF];
    _textF = textF;
    textF.backgroundColor = [UIColor grayColor];
}
- (void)tapAct {
    if (_dict) {
        NSLog(@"字典临时保存的数据:%@", _dict[@"1"]);
    }
    [_back removeFromSuperview];
}

- (void)KVO {
    //响应式编程思想－－不考虑调用顺序只需考虑结果，产生一个事件会导致很多影响，这些影响像流一样传播出去，万物皆是流。如KVO
    
    JSReactivePerson *p = [JSReactivePerson new];
    _p = p;
    
    [p js_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@", _p.name);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int i = 0;
    i++;
    _p.name = [NSString stringWithFormat:@"%d", i];
}

@end
