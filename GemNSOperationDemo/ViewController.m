//
//  ViewController.m
//  GemNSOperationDemo
//
//  Created by GemShi on 2017/3/4.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self InvocationOperation];
    
//    [self BlockOperation];
    
//    [self OpertationQueue];
    
    [self addDependency];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 这是添加依赖（最大的特点）
-(void)addDependency
{
    NSInvocationOperation *invo1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test1) object:nil];
    NSInvocationOperation *invo2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test2) object:nil];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [invo1 addDependency:invo2];
    [queue addOperation:invo1];
    [queue addOperation:invo2];
}

-(void)test1
{
    NSLog(@"invo1---%@",[NSThread currentThread]);
}

-(void)test2
{
    NSLog(@"invo2---%@",[NSThread currentThread]);
}

#pragma mark - OpertationQueue
-(void)OpertationQueue
{
    /**
     1.直接add到NSOperationQueue就可以，不需要手动start。NSOperationQueue会在合适的时机自动调用。
     2.add到NSOperationQueue之后，会自动到子线程中
     */
    
    //invocation添加到queue的写法
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSInvocationOperation *invo = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(testInvocation) object:nil];
    [queue addOperation:invo];
    
    //block添加到queue的方法
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation---%@",[NSThread currentThread]);
    }];
    [queue addOperation:blockOperation];
    
    //更简单的方法，直接添加
    [queue addOperationWithBlock:^{
        NSLog(@"addOperationWithBlock---%@",[NSThread currentThread]);
    }];
}

#pragma mark - blockOperation
-(void)BlockOperation
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1---%@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"2---%@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"3---%@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"4---%@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"5---%@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"6---%@",[NSThread currentThread]);
    }];
    [blockOperation start];
}

#pragma mark - invocationOperation
-(void)InvocationOperation
{
    NSInvocationOperation *invo = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(testInvocation) object:nil];
    [invo start];
}

-(void)testInvocation
{
    NSLog(@"%@",[NSThread currentThread]);
}

@end
