//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "MyApp.h"


@interface MyApp()

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


@end


@implementation MyApp

-(void)execute
{
    NSMutableArray *newQuestionsCreatedArray = [NSMutableArray new];
    NSMutableDictionary *questionsAnsweredDictionary = [NSMutableDictionary new];
    
    NSArray *valuesForUserDataDictionary = @[questionsAnsweredDictionary, newQuestionsCreatedArray];
    NSArray *keysForUserDataDictionary = @[@"questions_answered", @"new_questions"];
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjects:valuesForUserDataDictionary forKeys:keysForUserDataDictionary];
    NSMutableDictionary *users = [NSMutableDictionary new];
    
    NSMutableArray *interviewQuestions = [@[@"If you were at Hogwarts, which house would you be in?", @"What is your spirit animal?", @"Do you have any chill?"] mutableCopy];
    
    NSLog(@"Please enter your first name. \nIf you're new, this will become your username!");
    NSString *currentUser = [self requestKeyboardInput];
    
    if ([[users allKeys] containsObject:currentUser]) {
        NSLog(@"Welcome, %@!", currentUser);
        }
    else {
        NSMutableDictionary *currentUserData = [userData mutableCopy];
        [users setObject:currentUserData forKey:currentUser];
        NSLog(@"\nWelcome, %@!", currentUser);
    }

    NSLog(@"\nMenu:\n\nPlease choose from the following three options. \n(Type the number of the corresponding choice)");
    NSLog(@"\n\n1. Be interviewed ");
    NSLog(@"\n2. Write a new interview question");
    NSLog(@"\n3. Read an interview with another student");
    
    NSString *firstChoice = [self requestKeyboardInput];
    
    while([firstChoice isEqualToString:@"1"] == NO &&
        [firstChoice isEqualToString:@"2"] == NO &&
        [firstChoice isEqualToString:@"3"] == NO) {
        NSLog(@"Whoops! Let's try again. Please enter just the number of your choice:");
        firstChoice = [self requestKeyboardInput];
    }

    NSLog(@"\nYou chose number %@.", firstChoice);
    
    if ([firstChoice isEqualToString:@"1"]) {
        NSLog(@"\n1. Choose the question you'll be asked \n2. Be asked a random question");
        NSString *chooseQuestionOrRandomQuestion = [self requestKeyboardInput];
        
        if ([chooseQuestionOrRandomQuestion isEqualToString:@"1"]) {
            NSLog(@"\nWhich question do you want to answer? Please type the number only, for example: 1");
            for (NSUInteger i = 1; i <= [interviewQuestions count]; i++) {
                NSLog(@"\n%lu. %@", i, interviewQuestions[i - 1]);
            }
            
            NSString *chooseWhichQuestionToAnswer = [self requestKeyboardInput];
            NSInteger chooseWhichQuestionToAnswerInteger = [chooseWhichQuestionToAnswer integerValue];
            NSUInteger chooseWhichQuestionToAnswerUnsigned = (NSUInteger)chooseWhichQuestionToAnswerInteger;
            
            NSLog(@"Nice! You chose question %@. What's your answer?", chooseWhichQuestionToAnswer);
            
            NSString *answerToChosenQuestion = [self requestKeyboardInput];
            
            [questionsAnsweredDictionary setValue:answerToChosenQuestion forKey:interviewQuestions[chooseWhichQuestionToAnswerUnsigned - 1]];
        }
        else if ([chooseQuestionOrRandomQuestion isEqualToString:@"2"]) {
            NSUInteger randomNumber = arc4random_uniform((int)[interviewQuestions count]);
            NSString *randomQuestion = interviewQuestions[randomNumber];
            
            NSLog(@"Here's your random question:");
            NSLog(@"\n%@", randomQuestion);
            NSLog(@"\nPlease type your answer:");
            
            NSString *answerToRandomQuestion = [self requestKeyboardInput];
            
            [questionsAnsweredDictionary setValue:answerToRandomQuestion forKey:randomQuestion];
        }
    }
    else if ([firstChoice isEqualToString:@"2"]) {
        NSLog(@"\nPlease write your new interview question:");
        NSString *newInterviewQuestion = [self requestKeyboardInput];
        [newQuestionsCreatedArray addObject:newInterviewQuestion];
        [interviewQuestions addObject:newInterviewQuestion];
        NSLog(@"Great, now other students will be able to answer that!");
    }
    else if ([firstChoice isEqualToString:@"3"]) {
        NSLog(@"\nPlease type the first name (username) of the person whose interview you want to read:");
        NSString *nameOfPersonWhoseInterviewIsWanted = [self requestKeyboardInput];
        NSLog(@"%@", users[nameOfPersonWhoseInterviewIsWanted][@"questions_answered"]);
    }
}


/*
 I need to break this up into methods as well as figure out how the program can continuously run.
 */

// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}

@end
