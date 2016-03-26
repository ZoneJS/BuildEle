//
//  JSFMDBVC.m
//  BuildingElementsCollecting
//
//  Created by 张军帅 on 16/3/22.
//  Copyright © 2016年 zjs. All rights reserved.
//

#import "JSFMDBVC.h"

#import "FMDB.h"

typedef NS_ENUM(NSInteger, JSBtnTag) {
    JSBtnTagAdd = 100,
    JSBtnTagDelete = 101,
    JSBtnTagChange,
    JSBtnTagQuery,
    JSBtnTagTask
};

@interface JSFMDBVC () {
    /**
     *  一个FMDatabase对象就代表一个单独的SQLite数据库用来执行SQL语句,FMDatabase这个类是线程不安全的，如果在多 个线程中同时使用一个FMDatabase实例，会造成数据混乱等问题
     */
    FMDatabase *database;
    FMResultSet *set;//使用FMDatabase执行查询后的结果集
    FMDatabaseQueue *dbQueue;//用于在多线程中执行多个查询或更新，它是线程安全的
    NSString *dbPath;
}

@end

@implementation JSFMDBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"fmdb测试(JSFMDBVC)";
    [self.view setBackgroundColor:[UIColor blueColor]];
    NSArray *btnTitles = @[@"增",
                           @"删除所有",
                           @"多线程操作",
                           @"查",
                           @"事物（保证block中多个操作成功，一个失败时回滚）"];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 70  + 60 * i, kScreenWidth - 60, 40)];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        btn.backgroundColor = [UIColor yellowColor];
        [btn addTarget:self action:@selector(dbAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    [self fmdbTest];
    //testadfadsf
}

- (void)fmdbTest {
    //沙盒目录
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    dbPath = [documentDir stringByAppendingString:@"/Test.db"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        NSString *sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
        BOOL res = [database executeUpdate:sql];
        if (res) {
            NSLog(@"success to create table!");
        }
        [database close];
    }
}

- (void)dbAction:(UIButton *)sender {
    switch (sender.tag) {
        case JSBtnTagAdd: {
            [self insertData];
            break;
        }
        case JSBtnTagDelete: {
            [self clearAll];
            break;
        }
        case JSBtnTagChange: {
            [self multiThread];
            break;
        }
        case JSBtnTagQuery: {
            [self queryData];
            break;
        }
        case JSBtnTagTask: {
            [self taskData];
            break;
        }
    }
}

- (void)insertData {
    static int idx = 1;
    database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        NSString *sql = @"insert into user (name, password) values(?, ?) ";
        NSString *name = [NSString stringWithFormat:@"ZJS%d",idx++];
        BOOL res = [database executeUpdate:sql, name, @"lsq"];
        if (res) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"shibai");
        }
        [database close];
    }
}

- (void)queryData {
    database = [FMDatabase databaseWithPath:dbPath];
    NSString *sql = @"select * from user";
    if ([database open]) {
        FMResultSet *rs = [database executeQuery:sql];
        while ([rs next]) {
            int userId = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *password = [rs stringForColumn:@"password"];
            NSLog(@"%d %@ %@",userId, name, password);
        }
        [database close];
    }
}

- (void)clearAll {
    database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        NSString *sql = @"delete from user";
        BOOL rs = [database executeUpdate:sql];
        if (rs) {
            NSLog(@"删除所有");
        }
        [database close];
    }
}

- (void)multiThread {
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 100; i++) {
            [dbQueue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"insert into user (name, password) values(?, ?) ";
                NSString *name = [NSString stringWithFormat:@"queue1&%d", i];
                BOOL rs = [db executeUpdate:sql ,name, @"pass"];
                if (rs) {
                    NSLog(@"succ to add Data: %@",name);
                }
            }];
        }
    });
    dispatch_async(q2, ^{//TODO:   失败！原因未知
        for (int i = 0; i < 100; i++) {
            [dbQueue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"insert into user (name, password) values(?, ?) ";
                NSString *name = [NSString stringWithFormat:@"queue2&%d",i];
                BOOL rs = [db executeUpdate:sql, name ,@"pass"];
                if (rs) {
                    NSLog(@"succ to add data: %@",name);
                } else {
                    NSLog(@"q2失败！！！！！！");
                }
            }];
        }
    });
}

- (void)taskData {
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];//开启事物
        
        [db executeUpdate:@"insert into user (name, password) values(?, ?)",@"adfadsf", @"adf"];
        [db executeUpdate:@"insert into user (name, password) values(?, ?)",@"adfadsf", @"adf"];
        [db executeUpdate:@"insert into user (name, password) values(?, ?)",@"adfadsf", @"adf"];
        
        if (YES) {
            [db rollback];
        }
        
        //做些个操作
        [db commit];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
