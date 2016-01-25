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

-(void)execute;

-(NSString *)login;

-(NSString *)requestKeyboardInput;

-(NSString *)mainMenu;

-(NSString *)interviewMenu;

-(NSDictionary *)addQuestion;

-(NSDictionary *)printQuestions: (NSMutableArray *)listOfQuestions :(NSMutableArray *)questionAlreadyAnswered;

-(BOOL)isQuestionAnswered: (NSMutableArray *)questionAlreadyAnswered :(NSString *)q;

-(NSDictionary *)beAskedARandomQuestion :(NSMutableArray *)listofQuestions;

-(void)setUpUser: (NSString *)userName :(NSMutableDictionary *)userInfo;

-(void)readInterview :(NSMutableDictionary *)differentUsers;

-(void)logout;

@end
