//
//  MyApp.h
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyApp : NSObject

@property (strong, nonatomic) NSString *currentUser;

@property (strong, nonatomic) NSMutableDictionary *interviewInfo;

@property (strong, nonatomic) NSMutableDictionary *interviewQuestions;

- (void)execute;

- (NSString *)logIn;

- (void)mainMenu;

- (void)interviewUser;

- (void)askSelectedQuestion;

- (void)askRandomQuestion;

- (void)selectCategory;

- (void)addQuestion;

- (void)addQuestionToCategory;

- (void)displayInterview;

- (NSString *)requestKeyboardInput;

@end
