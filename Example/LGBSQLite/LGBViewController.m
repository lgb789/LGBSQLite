//
//  LGBViewController.m
//  LGBSQLite
//
//  Created by lgb789 on 01/04/2017.
//  Copyright (c) 2017 lgb789. All rights reserved.
//

#import "LGBViewController.h"
#import "LGBSQLite.h"
#import "Test.h"
#import "Test1.h"

@interface LGBViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) LGBSQLiteStorage *storage;
@end

@implementation LGBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.items = [NSArray arrayWithObjects:@"add", @"delete", @"delete by key", @"update", @"get by key", @"get all", @"get by index", nil];
//    Test *t = [Test new];
//    float f = 34.2339;
//    [t setValue:[NSNumber numberWithFloat:f] forKey:@"fff"];
//    [t setValue:[NSNumber numberWithFloat:f] forKey:@"ddd"];
//    [t setValue:[NSNumber numberWithFloat:f] forKey:@"weight"];
//    NSLog(@"t fff:%f,%f,%.4f", t.fff,t.ddd, t.weight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSInteger index = 0;
    NSLog(@"indexpath:%@", indexPath);
    switch (indexPath.row) {
        case 0:{
            Test1 *t = [Test1 new];
            t.name = [NSString stringWithFormat:@"lgb%ld", index++];
            t.age = 34;
            t.weight = 34.3;
            t.fff = 34.33;
            t.ddd = 5.555;
            BOOL addresult = [self.storage insertObj:t];
            NSLog(@"add result:%d", addresult);
        }
            
            break;
        case 1:{
            Test1 *t = [Test1 new];
            t.name = @"lgb0";
            t.age = 34;
            t.weight = 34.3;
            t.fff = 34.33;
            t.ddd = 5.555;
            [self.storage deleteObj:t];
        }
            
            break;
        case 2:{
            [self.storage deleteObjByKey:@"name" value:@"lgb1"];
        }
            break;
        case 3:{
            Test1 *t = [Test1 new];
            t.name = @"lgb2";
            t.age = 999;
            t.weight = 34.3;
            [self.storage updateObj:t key:@"name"];
        }
            break;
        case 4:{
            NSArray *arr = [self.storage getObjsByKey:@"name" value:@"lgb0"];
            for (Test1 *t in arr) {
                NSLog(@"t:%@,%ld,%@,%f,%f", t.name, t.age, @(t.ddd), t.fff,t.weight);
            }
        }
            break;
        case 5:{
            NSArray *arr = [self.storage getObjs];
            for (Test1 *t in arr) {
                NSLog(@"t:%@,%ld,%f,%f,%f,%f", t.name, t.age, t.fff,t.fff,t.ddd,t.weight);
            }
        }
            break;
        case 6:{
            NSArray *arr = [self.storage getObjsFrom:2 count:3];
            for (Test1 *t in arr) {
                NSLog(@"t:%@,%ld,%f,%f,%f,%f", t.name, t.age, t.fff,t.fff,t.ddd,t.weight);
            }
        }
            break;
            
        default:
            break;
    }
}


-(LGBSQLiteStorage *)storage
{
    if (_storage == nil) {
//        _storage = [[LGBSQLiteStorage alloc] initWithClass:[Test class] dbName:@"test.db"];
        _storage = [[LGBSQLiteStorage alloc] initWithClass:[Test1 class]];
    }
    return _storage;
}

@end
