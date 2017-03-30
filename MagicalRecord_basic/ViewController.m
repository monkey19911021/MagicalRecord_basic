//
//  ViewController.m
//  CD
//
//  Created by DONLINKS on 2017/3/28.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "ViewController.h"
#import "MagicalRecord.h"
#import "Model+CoreDataModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
{
    __weak IBOutlet UITableView *perTableView;
    
    NSMutableArray<Person *> *muArray;
}

#pragma mark - 查
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    muArray = [Person MR_findAllSortedBy:@"date" ascending: YES].mutableCopy;
    [perTableView reloadData];
}

#pragma mark - 增
- (IBAction)add:(id)sender {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    Person *per = [Person MR_createEntityInContext: context];
    per.name = @"aaa";
    per.age = 18;
    per.headImg = UIImagePNGRepresentation([UIImage imageNamed: @"delete"]);
    per.date = [NSDate date];
    [context MR_saveToPersistentStoreAndWait];
    
    [muArray addObject: per];
    [perTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return muArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"cell"];
    }
    
    Person *p = muArray[indexPath.row];
    cell.textLabel.text = p.name;
    cell.imageView.image = [UIImage imageWithData: p.headImg];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", p.date];
    
    return cell;
}

#pragma mark - 改
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    Person *person = [muArray objectAtIndex: indexPath.row];
    person.name = @"bbb";
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - 删
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Person *person = [muArray objectAtIndex: indexPath.row];
        [person MR_deleteEntity];//删除实体
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [muArray removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
