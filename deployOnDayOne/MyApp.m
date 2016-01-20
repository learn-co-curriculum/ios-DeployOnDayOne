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
    NSArray *interviewQuestions = @[@" 1. What is your favorite color?", @" 2. Where are you from?", @" 3. how old are you?"];
    NSArray *sportsQuestions = @[@"1. What is your favorite sport? ", @"2. What is your favorite team ?", @"3.Who is your favorite athelete?"];
    NSArray *foodQuestions = @[@"1. What is your favorite food?", @"2. What is your least favorite food?", @"3. What is a food you've been wanting to try?"];
    NSMutableArray *newQuestionsAddedByUser = [[ NSMutableArray alloc]init];
    NSMutableArray *newcategory = [[NSMutableArray alloc]init];
    NSMutableArray *mSportsQuestions = [ sportsQuestions mutableCopy];
    NSMutableArray *mFoodQuestions = [ foodQuestions mutableCopy];
    NSDictionary *mikesInterview = @{ @"What is your favotrite color ?" : @"My favorite color is red.",
                                      @"What is your Favorite Sport ?" : @"My favorite sport is baseball.",
                                      @"What is your favorite food ?" : @"My favorite food is pizza."};
    NSDictionary *jonsInterview = @{ @"Where are you from?": @"I'm from the Bronx",
                                     @"What is your favorite sports team?": @"My favorite sports team is New York Yankee's.",
                                     @"What is your least favorite food?": @"My least favorite food is any kind of soup."};
    NSDictionary *adriansInterview = @{ @"How old are you?" : @"I'm 22 years old.",
                                        @"Who is your favorite athelete?" : @"My favorite athelete is Aryton Senna",
                                        @"What is a food you've been wanting to try?": @"I've been wanting to try Greek food."};
    
    
    
    NSLog(@"Hey, this app is starting.");
    
    NSLog(@"Type your name here:");
    NSString *response = [self requestKeyboardInput];
    
    self.currentUser = response;
    
    
    
    NSLog(@"Your name is: %@", response);
    
    NSLog(@"Please choose from the following three options");
    NSLog(@"1. Be interviewed.");
    NSLog(@"2. Write a new interview question.");
    NSLog(@"3. Read an interview with another student.");
    

    
    NSString *responseToQuestionOne = [ self requestKeyboardInput];

    
    if ([responseToQuestionOne isEqualToString:@"1"]) {
        NSLog(@"You have chosen to be interviewed.");
        NSLog(@"1. Choose the question you will be asked.");
        NSLog(@"2. Be asked a random question.");
        NSString *responseToSubQuestionOne = [ self requestKeyboardInput];
        if ([responseToSubQuestionOne isEqualToString:@"1"]) {
            NSLog(@"Choose from the following interview Questions");
            NSLog(@"%@", interviewQuestions);
            NSString *chosenQuestionFromArray = [ self requestKeyboardInput];
            if ([chosenQuestionFromArray isEqualToString:@"1"]) {
                NSString *firstIndexInArray = [ interviewQuestions objectAtIndex : 0];
                NSLog(@"%@",firstIndexInArray);
                NSString *answerToQuestionOneOfArray = [ self requestKeyboardInput];
                NSLog(@"%@ is your favorite color", answerToQuestionOneOfArray);
            }if ([chosenQuestionFromArray isEqualToString:@"2"]) {
                NSString *secondIndexInArray = [ interviewQuestions objectAtIndex:1];
                NSLog(@"%@", secondIndexInArray);
                NSString *answerToQuestionTwoOfArray = [ self requestKeyboardInput];
                NSLog(@"%@ is where you are from.",answerToQuestionTwoOfArray);
            }if ([chosenQuestionFromArray isEqualToString:@"3"]) {
                NSString *thirdInexOfArray = [ interviewQuestions objectAtIndex: 2];
                NSLog(@"%@",thirdInexOfArray);
                NSString *answerToQuestionThreeOfArray = [ self requestKeyboardInput];
                NSLog(@"You are %@ years old",answerToQuestionThreeOfArray);
            }
            
        }if ([responseToSubQuestionOne isEqualToString:@"2"]) {
            uint32_t rnd = arc4random_uniform([interviewQuestions count]);
            
            NSString *randomObject = [interviewQuestions objectAtIndex:rnd];
            NSLog(@"%@",randomObject);
            NSString *answerToRandomQuestion = [ self requestKeyboardInput];
            NSLog(@"%@ is your answer",answerToRandomQuestion);
        }
        
    }
    if ([responseToQuestionOne isEqualToString: @"2"]) {
        NSLog(@"You have chosen to write an interview question");
        NSLog(@"Pick which category you would like your question to be added to");
        NSLog(@"1. FOOD");
        NSLog(@"2. SPORTS");
        NSLog(@"3. Create new category if your question does not fit provided categories. ");
        NSString *categoryChosen = [self requestKeyboardInput];
        if ([categoryChosen isEqualToString:@"1"]) {
            NSLog(@"You have chosen to add your question to the FOOD Category");
            NSLog(@"To view current questions enter 'VIEW'");
            NSString *viewFoodQuestions = [self requestKeyboardInput ];
            NSLog(@"%@", mFoodQuestions);
            NSLog(@"enter your question below");
            NSString *userAddedQuestion = [ self requestKeyboardInput];
            NSLog(@"Your Question is, %@.", userAddedQuestion);
            NSLog(@"To add question please enter 'add'");
            NSString *userConfirmedQuestionAdded = [ self requestKeyboardInput];
            [mFoodQuestions addObject: newQuestionsAddedByUser ];
            NSLog(@"%@ has been added to FOOD category", userAddedQuestion);
               }
        if ([categoryChosen isEqualToString:@"2"]) {
            NSLog(@"You have chosen to add your question to the SPORTS category. ");
            NSLog(@"To view current questions enter 'VIEW'");
            NSString *viewSportsQuestions = [self requestKeyboardInput];
            NSLog(@"%@",mSportsQuestions);
            NSLog(@"Enter your question below");
            NSString *userAddedQuestion = [ self requestKeyboardInput];
            NSLog(@"Your question is %@", userAddedQuestion);
            NSLog(@"To add question please enter 'add'");
            NSString *userConfirmedQuestion = [ self requestKeyboardInput];
            [mSportsQuestions addObject:userAddedQuestion];
            NSLog(@"%@ has been added to SPORTS category",userAddedQuestion);
            }
        if ([categoryChosen isEqualToString:@"3"]) {
            NSLog(@"You have chosen to create a new category for your category");
            NSLog(@"Enter the name of your categpory");
            NSString *newcategoryName = [self requestKeyboardInput];
    
            
            NSLog(@"Your new category name is %@", newcategoryName);
            NSLog(@"Enter question for %@ below",newcategoryName);
            NSString *userAddedQuestion = [ self requestKeyboardInput];
            NSLog(@"Your question is %@",userAddedQuestion);
            NSLog(@"To add question to new category enter 'add'")
            NSString *questionAdded = [self requestKeyboardInput];
            [newcategory addObject:userAddedQuestion];
            NSLog(@"Your question has been added to %@ category", newcategoryName);
            
        }
        
    }
    if ([responseToQuestionOne isEqualToString:@"3"]) {
        NSLog(@"You have chosen to read an interview with another student")
        NSLog(@"to view student interviews enter 'VIEW'");
        NSString *viewInterviews = [ self requestKeyboardInput];
        NSLog(@"Chose one of the following interviews to read");
        NSLog(@"1. Mike's Interview");
        NSLog(@"2. Jon's Interview");
        NSLog(@"3. Adrian's Interview");
        NSString *interviewChosen = [self requestKeyboardInput];
        if ([interviewChosen isEqualToString:@"1"]) {
            NSLog(@"You have chosen to read Mike's interview");
            NSLog(@"%@",mikesInterview);
        }
        if ([interviewChosen isEqualToString:@"2"]) {
            NSLog(@"You have chosen to read Jon's interview");
            NSLog(@"%@",jonsInterview);
        }
        if ([interviewChosen isEqualToString:@"3"]) {
            NSLog(@"You have chosen to read Adrian's interview");
            NSLog(@"%@",adriansInterview);
        }
    }

    
    // Begin writing your code here. This method will kick off automatically.


}


// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}

@end
