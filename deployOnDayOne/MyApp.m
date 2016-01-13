//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "MyApp.h"


@interface MyApp()

@end


@implementation MyApp

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

//Variable to hold the current user
NSString *currentUser;

//Array to hold users, their questions and answers
NSMutableDictionary *interviewInfo;

//Array to hold interview questions
NSMutableDictionary *interviewQuestions;

- (void)execute
{
    interviewInfo = [[NSMutableDictionary alloc] init];
    
    //Initialize some interview questions
    interviewQuestions = [@{@"Gaming"     : @[@"What is your favorite game?",
                                              @"What game have you most recently played?"],
                            @"Sports"     : @[@"What is your favorite sport to play or watch?",
                                              @"What is your favortie sports team?"],
                            @"Employment" : @[@"What was your previous job?",
                                              @"What is your greatest strength?",
                                              @"What is your greatest weakness?",
                                              @"What are your interests?"]}
                           mutableCopy];
    
    //Initial login
    currentUser = [self logIn];
    
    //Start up the Menu
    [self mainMenu];
}

- (NSString *)logIn
{
    NSLog(@"\nWelcome User! Please log in with your name:");
    NSString *logInName = [self requestKeyboardInput];
    
    if ([[interviewInfo allKeys] containsObject:currentUser])
    {
        NSLog(@"\nWelcome back, %@\n", logInName);
    }
    else
    {
        NSLog(@"\nAh, a newbie, welcome!\nLet's warm up by getting you to type in your last name:");
        NSString *lastNameAnswer = [self requestKeyboardInput];
        interviewInfo [logInName] = @{@"Last name" : lastNameAnswer};
    }

    return logInName;
}

- (void)mainMenu
{
    NSLog(@"Please choose from these options:\n\n1. Be interviewed.\n2. Write a new interview question.\n3. Read the interview of another student.\n\nType the number of your selection and press enter:");
    NSString *menuSelection = [self requestKeyboardInput];
    
    //User decides to be interviewed
    if ([menuSelection isEqualToString: @"1"])
    {
        [self interviewUser];
    }
    //User decides to write their own question
    else if ([menuSelection isEqualToString: @"2"])
    {
        [self addQuestion];
    }
    //User decides to read another student's interview
    else if ([menuSelection isEqualToString: @"3"])
    {
        [self displayInterview];
    }
    else
    {
        NSLog(@"Invalid Input\n");
        [self mainMenu];
    }
}

- (void)interviewUser
{
    NSLog(@"Let's ask some questions!\n\n1. Choose the question you will be asked.\n2. Be asked a random question.\n3. Go back to Main Menu.\n\nType the number of your desired option and press enter.");
    
    NSString *menuSelection = [self requestKeyboardInput];
    
    //User decides to choose their questions
    if ([menuSelection isEqualToString: @"1"])
    {
        [self askSelectedQuestion];
    }
    //User decides to get a random question
    else if ([menuSelection isEqualToString: @"2"])
    {
        [self askRandomQuestion];
    }
    //User returns to main menu
    else if ([menuSelection isEqualToString: @"3"])
    {
        [self mainMenu];
    }
    else
    {
        NSLog(@"Invalid Input\n");
        [self interviewUser];
    }
}

- (void)askSelectedQuestion
{
    [self selectCategory];
    
    //User selects which question they'd like to answer and answers it
    NSArray *categories = [interviewQuestions allKeys];
    NSString *categoryNumberSelection = [self requestKeyboardInput];
    NSInteger selectionValue = [categoryNumberSelection integerValue];
    NSString *categoryName = categories[selectionValue - 1];
    
    if (selectionValue > 0 && selectionValue <= [categories count])
    {
        //Selecting the question
        NSArray *questionsInSelectedCategory = interviewQuestions[categoryName];
        NSLog(@"Here are the questions for that category, please select one\n\n");
        
        for (NSString *element in questionsInSelectedCategory)
        {
            NSLog(@"%li. %@\n", [questionsInSelectedCategory indexOfObject:element] + 1, element);
        }
        NSLog(@"\nType the number of your selection and press enter\n");
        
        NSString *selectedQuestion = [self requestKeyboardInput];
        NSInteger selectedQuestionValue = [selectedQuestion integerValue];
        NSString *actualQuestion = questionsInSelectedCategory[selectedQuestionValue - 1];
        
        //Answering it
        NSLog(@"Please provide your answer:\n%@\n", actualQuestion);
        
        NSString *selectedQuestionResponse = [self requestKeyboardInput];
        
        //Recording the answer
        NSMutableDictionary *grabUserInfo = [interviewInfo[currentUser] mutableCopy];
        grabUserInfo[actualQuestion] = selectedQuestionResponse;
        interviewInfo[currentUser] = grabUserInfo;
        
    }
    else
    {
        NSLog(@"Invalid Input\n");
        [self interviewUser];
    }
    
    NSLog(@"\n");
    
    [self interviewUser];
}

- (void)askRandomQuestion
{
    [self selectCategory];
    
    NSMutableDictionary *userInterview = [interviewInfo[currentUser] mutableCopy];
    NSArray *askedQuestions = [userInterview allKeys];
    
    //Grab info about the selected category
    NSArray *categories = [interviewQuestions allKeys];
    NSString *categoryNumberSelection = [self requestKeyboardInput];
    NSInteger selectionValue = [categoryNumberSelection integerValue];
    NSString *categoryName = categories[selectionValue - 1];
    
    //Grab the possible questions
    NSArray *questionsInCategory = interviewQuestions[categoryName];
    NSMutableArray *questionsToCheck = [questionsInCategory mutableCopy];
    NSInteger numQuestionsInCategory;
    
    NSString *questionToAsk;
    BOOL newQuestion = NO;
    
    //Select a random question, skipping any previously asked questions
    while (!newQuestion)
    {
        numQuestionsInCategory = [questionsToCheck count];
        if (0 == numQuestionsInCategory)
        {
            NSLog(@"All questions asked!");
            break;
        }
        //Pick a random question
        NSInteger randomNumber = arc4random_uniform(numQuestionsInCategory);
        questionToAsk = questionsToCheck[randomNumber];
        
        //Check if the user has answered it already
        if (![askedQuestions containsObject:questionToAsk])
        {
            newQuestion = YES;
            
            //Ask the question and record the answer
            NSLog(@"Please provide your answer:\n%@\n", questionToAsk);
            
            NSString *randomQuestionResponse = [self requestKeyboardInput];
            //Recording the answer
            userInterview[questionToAsk] = randomQuestionResponse;
            interviewInfo[currentUser] = userInterview;
        }
        else
        {
            newQuestion = NO;
            [questionsToCheck removeObject:questionToAsk];
        }
    }
    
    NSLog(@"\n");
 
    [self interviewUser];
}

- (void)addQuestion
{
    NSLog(@"Would you like to:\n\n1. Select which category to add your question and then add it.\n2. Add a new category.\n3. See all current categories.\n4. Return to main menu\n\nType the number of your choice and press enter");
    
    NSString *menuSelection = [self requestKeyboardInput];
    
    //User wants to add their question
    if ([menuSelection isEqualToString: @"1"])
    {
        [self addQuestionToCategory];
    }
    //User decides to add a new category
    else if ([menuSelection isEqualToString: @"2"])
    {
        NSLog(@"Type the category you wish to add below:\n")
        NSString *categoryToAdd = [self requestKeyboardInput];
        interviewQuestions[categoryToAdd] = @[];
        
        [self addQuestion];
    }
    //User decides to see all categories
    else if ([menuSelection isEqualToString:@"3"])
    {
        NSLog(@"Current categories:\n");
        for (NSString *element in [interviewQuestions allKeys])
        {
            NSLog(@"%@\n", element);
        }
        
        [self addQuestion];
    }
    //User chooses to return to the main menu
    else if ([menuSelection isEqualToString: @"4"])
    {
        [self mainMenu];
    }
    else
    {
        NSLog(@"Invalid Input");
        [self interviewUser];
    }
}

- (void)addQuestionToCategory
{
    [self selectCategory];
    
    //Grab info about the selected category
    NSArray *categories = [interviewQuestions allKeys];
    NSString *categoryNumberSelection = [self requestKeyboardInput];
    NSInteger selectionValue = [categoryNumberSelection integerValue];
    NSString *categoryName = categories[selectionValue - 1];
    
    NSLog(@"Category selected: %@\nWrite your question below and press enter:\n", categoryName);
    NSMutableArray *questions = [interviewQuestions[categoryName] mutableCopy];
    NSString *questionToAdd = [self requestKeyboardInput];
    
    [questions addObject:questionToAdd];
    interviewQuestions[categoryName] = questions;
    
    NSLog(@"Question added!:\n");
    for (NSString *element in questions)
    {
        NSLog(@"%li. %@", [questions indexOfObject:element] + 1, element);
    }
    
    NSLog(@"\n");
    
    [self addQuestion];
}

- (void)displayInterview
{
    NSArray *allStudents = [interviewInfo allKeys];
    
    NSLog(@"Enter the (first)name of the student whose answers you'd like to see or enter 'Main Menu' to return to the Main Menu:\n");
    NSString *selectedStudent = [self requestKeyboardInput];
    
    if ([allStudents containsObject:selectedStudent]) {
        NSLog(@"%@\n", interviewInfo[selectedStudent]);
        [self displayInterview];
    }
    else if ([selectedStudent isEqualToString:@"Main Menu"])
    {
        [self mainMenu];
    }
    else
    {
        NSLog(@"Student not in database!\n");
        [self displayInterview];
    }
}

- (void)selectCategory
{
    //User chooses the category of the question
    NSArray *categories = [interviewQuestions allKeys];
    NSLog(@"What category would you like?\n\n");
    for (NSString *element in categories)
    {
        NSLog(@"%li. %@\n", [categories indexOfObject:element] + 1, element);
    }
    NSLog(@"\nType the number of your selection and press enter.");
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
