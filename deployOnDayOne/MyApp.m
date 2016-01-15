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


//structure of the dictionary name (string for currentUser)  :  => (seperate dicitonary) @nameOfCurrentInterview#  (with number) : => another dictionary for questions and answers

-(void)execute
{
    BOOL exitProgram = NO;
    NSString *inputCurrentUser = @"";
    NSString *currentUser = nil;
    NSUInteger currentUserNumberInput;
    NSMutableDictionary *usersInterviewQuestionsAndAnswers = [[NSMutableDictionary alloc] init];
    //interview question list....
    NSMutableDictionary *interviewQuestions = [ @{ @"Sports": [ @[@"What is your favorite team?",
                                                               @"Who is your favorite athlete?",
                                                               @"What is your favorite sport?"] mutableCopy ] ,
                                              @"Technology": [ @[@"What is your favorite programming language?",
                                                             @"What current tech trend are you following?",
                                                            @"What is your favorite device?",
                                                             @"What is your favorite brand?"] mutableCopy] } mutableCopy ];
    
    NSString *currentInterview = @"";
    
    do {
        
        if (!currentUser) {
            
            currentUser = [self login: inputCurrentUser fromDictionary: usersInterviewQuestionsAndAnswers]; //login new user
        }
        
        currentInterview = [ self makeNewAndCurrentInterview: usersInterviewQuestionsAndAnswers
                                                               forUser: currentUser ];
        currentUserNumberInput = [self menu];
        
        switch (currentUserNumberInput)
        {
            case 0:
                [self beInterviewedSubmenuWithQuestions: interviewQuestions
                                           inDictionary: usersInterviewQuestionsAndAnswers
                                    withInterviewNumber: currentInterview
                                                forUser: (NSString *)currentUser];
                break;
            case 1:
                [self writeANewQuestionSubmenuInQuestions: interviewQuestions];
                break;
            case 2:
                [self readAnInterviewWithAnotherStudentSubmenuFromDictionary: usersInterviewQuestionsAndAnswers withCurrentUser:currentUser];
                break;
            case 3:
                NSLog(@"You have logged out. Goodbye!");
                currentUser = nil;
                break;
            case 4:
                NSLog(@"exiting program....");
                exitProgram = YES;
                break;
            default:
                //nothing to see here.......
                break;
        }

        
    } while (!exitProgram);
    

}


// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}

-(NSString *)login:(NSString *)currentUser fromDictionary: (NSMutableDictionary *)usersInterviewQuestionsAndAnswers{

    //make new entry for currentUser if currentUser doesn't exsist
    if( ![ [usersInterviewQuestionsAndAnswers allKeys] containsObject: currentUser ]){
        
        NSLog(@"Hi there, let's take a second to login...");
        currentUser = [self requestKeyboardInput];
        
        usersInterviewQuestionsAndAnswers[currentUser] = [[NSMutableDictionary alloc] init];
        usersInterviewQuestionsAndAnswers[currentUser][@"Interview1"] = [[NSMutableDictionary alloc] init];
        
        NSLog(@"Welcome %@!!", currentUser);
        
    }
    else{
        
        NSLog(@"Welcome back %@!!", currentUser);
    }
 
    return currentUser;
}

-(NSInteger )menu{
    
    while(YES){
        NSArray *options = @[@"1", @"2", @"3", @"4", @"5"];
        NSString *userOption;
        NSUInteger userNumberOption;
        
        NSLog(@"Please choose from the following three options:\n\n");
        NSLog(@"1. Be interviewed. \n");
        NSLog(@"2. Write a new interview question. \n");
        NSLog(@"3. Read an interview with another student. \n\n\n");
        NSLog(@"4. Logout");
        NSLog(@"5. Exit");
        
        NSLog(@"Simply type in the option number you are interested in, and press enter.");
        userOption = [self requestKeyboardInput];
        
        if ([options containsObject: userOption] ) {
            
            userNumberOption = [userOption integerValue] - 1; //correct for zero index
            
            return userNumberOption;
        }
     else
         NSLog(@"Invalid option, please try again!");
        
    }
  
    
}

-(void)beInterviewedSubmenuWithQuestions:(NSMutableDictionary *) interviewQuestions
                            inDictionary: (NSMutableDictionary *) usersInterviewQuestionsAndAnswers withInterviewNumber: (NSString *) currentInterview  forUser: (NSString *)currentUser {
    
    NSArray *options = @[@"1", @"2"];
    NSString *userOption;
    NSString *currentQuestion = @"";
    NSString *answer = @"";
    NSString *currentUserCategory  = @"";
    
    while (YES) {
        NSLog(@"You have chosen to be interviewed.\n\n");
        NSLog(@"1. Choose the question you will be asked.\n");
        NSLog(@"2. Be asked a random question.\n\n\n");
        
        NSLog(@"Simply type in the option number you are interested in, and press enter.");
        userOption = [self requestKeyboardInput];
        
        if ( [options containsObject: userOption] )
            break;
    }

    if([userOption isEqualToString: @"1"]){
        [self displayCurrentQuestionCategoriesInQuestions: (NSMutableDictionary *)interviewQuestions];
        
        currentUserCategory = [self requestKeyboardInput];
        
        NSLog(@"\nChoose a question from the list below\n");
        NSLog(@"Simply type the option number you are interested in for the question below and press enter.\n\n");
        
        NSArray *currentQuestions = interviewQuestions[currentUserCategory];
        
        for (NSUInteger n = 0; n < [currentQuestions count]; n++) {
            NSLog(@"%lu. %@\n", n + 1, currentQuestions[n]);
        }

        userOption = [self requestKeyboardInput];
        
        NSLog(@"You have selected the following question: \n");
        NSLog(@"%@\n",currentQuestions[ [userOption integerValue ] - 1]);
        
        currentQuestion = currentQuestions[ [userOption integerValue] ];
        
        NSLog(@"Please enter your response here:");
        
        answer = [self requestKeyboardInput];
        
        usersInterviewQuestionsAndAnswers[currentUser][currentInterview][currentQuestion] = answer;
    }
    
    else if ([userOption isEqualToString: @"2"]){
        
        
        //find a random category and then use a random question from it
        
        NSArray *currentCategories = [interviewQuestions allKeys];
        
        NSInteger randomIdxForCategory = arc4random() % [currentCategories count]; //random number between 0 and count - 1
        
        currentUserCategory = currentCategories[randomIdxForCategory];
        
        NSInteger randomIdxForQuestion = arc4random() % [ interviewQuestions[currentUserCategory] count];
    
        currentQuestion = interviewQuestions[currentUserCategory][randomIdxForQuestion];
        
        NSLog(@"\n%@", currentQuestion);
        
        NSLog(@"Please type your response here ");
        
        answer = [self requestKeyboardInput];
        
        usersInterviewQuestionsAndAnswers[currentUser][currentInterview][currentQuestion] = answer;
    }

    
}

-(void)writeANewQuestionSubmenuInQuestions: (NSMutableDictionary *)interviewQuestions{
    
    NSArray *options = @[@"1", @"2"];
    NSString *userOption;
    NSUInteger currentNumberUserOption;
    
    while (YES) {
        NSLog(@"Welcome to the questions submenu\n\n");
        NSLog(@"Please choose one of the following options:\n");
        NSLog(@"1. Enter a new question. \n");
        NSLog(@"2. Add a new category\n");
        
        userOption = [self requestKeyboardInput];
        
        if ([options containsObject: userOption])
            break;
        
        else{
                NSLog(@"Invalid option, please try again.");
            }
    }
        currentNumberUserOption = [userOption integerValue] - 1; //adjust for off by 1
        
    [self displayCurrentQuestionCategoriesInQuestions: (NSMutableDictionary *)interviewQuestions];
    
 //---------------------------------------------
    NSString *currentUserCategory = @"";
    
        switch (currentNumberUserOption) {
            case 0:
                NSLog(@"Enter a category from above");
                currentUserCategory = [self requestKeyboardInput];
                [self addNewCategory: currentUserCategory
                         ToQuestions: interviewQuestions]; //check to see if category exsists
                NSLog(@"Please enter a question");
                interviewQuestions[currentUserCategory] = [self requestKeyboardInput];
                
                break;
            case 1:
                NSLog(@"Enter the category you would like to add:");
                currentUserCategory = [self requestKeyboardInput];
                [self addNewCategory: currentUserCategory
                         ToQuestions: interviewQuestions]; //check to see if category exsists or add it otherwise
                break;
            default:
                //wish I could write something clever here....but let's keep it pushin
                break;
        }
    
}

-(void)readAnInterviewWithAnotherStudentSubmenuFromDictionary: usersInterviewQuestionsAndAnswers withCurrentUser: (NSString *)currentUser{
    
//    When reading interviews of other students, the user should be able to choose which student's interview they want to read, and which question they would like to see the answer to from the chosen user (student).
//    usersInterviewQuestionsAndAnswers[currentUser] = [[NSMutableDictionary alloc] init];
//    usersInterviewQuestionsAndAnswers[currentUser][@"Interview1"] = [[NSMutableDictionary alloc] init]
//
    NSString *currentUserInterview = @"";
    NSArray *allInterviewsForSelectedUser = @[];
    NSString *currentSelectedUserInterviewString = @"";
    NSArray *allQuestionsForSelectedUserInterview = @[];
    NSString *currentSelectedQuestion = @"";
    NSString *currentAnswerToQuestion = @"";
    BOOL viewAnotherQuestion = YES;
    
    NSMutableArray *allUserInterviewStrings = [[usersInterviewQuestionsAndAnswers allKeys] mutableCopy];
    if ( [allUserInterviewStrings containsObject: currentUser]) {
        [allUserInterviewStrings removeObject: currentUser];
    }

    
    NSLog(@"Please select an interviewee from the list below:\n\n");
    for (NSString *currentInterview in allUserInterviewStrings) {
        NSLog(@"%@\n", currentInterview);
    }
    
    currentUserInterview = [self requestKeyboardInput];
    
    do {
        allInterviewsForSelectedUser = [usersInterviewQuestionsAndAnswers[currentUserInterview] allKeys];
        NSLog(@"Which interview would you like to review?");
        for (NSString *currentInterview in allInterviewsForSelectedUser) {
            NSLog(@"%@", currentInterview);
        }
        
        currentSelectedUserInterviewString = [self requestKeyboardInput];
        
        NSLog(@"Here are the questions for the current interview... \n");
        NSLog(@"Select the number for the corresponding question to view the answer.");
        allQuestionsForSelectedUserInterview = [usersInterviewQuestionsAndAnswers[currentUserInterview][currentSelectedUserInterviewString] allKeys ];
        
        for (NSUInteger n = 0; n < [allQuestionsForSelectedUserInterview count]; n++ ) {
            NSLog(@"%lu. %@",n, allQuestionsForSelectedUserInterview[n]);
        }
        
        currentSelectedQuestion = [self requestKeyboardInput];
        currentSelectedQuestion = [ NSString stringWithFormat: @"%lu", [currentSelectedQuestion integerValue] - 1  ]; //correct for off by 1
        
        currentAnswerToQuestion = usersInterviewQuestionsAndAnswers[currentUserInterview][currentSelectedUserInterviewString][currentSelectedQuestion];
        NSLog(@"Answer: %@\n", currentAnswerToQuestion);
        
        NSLog(@"View another question?\n (y/n)");
        
        viewAnotherQuestion = [ [ [self requestKeyboardInput] lowercaseString ]  isEqualToString: @"y"] ? YES : NO;

    } while (viewAnotherQuestion);
}

-(void)addNewCategory: (NSString *)currentUserCategory
          ToQuestions: (NSMutableDictionary *)interviewQuestions{
    
    if ( !( [ [interviewQuestions allKeys] containsObject: currentUserCategory ]) )
        interviewQuestions[currentUserCategory] = [ [NSMutableArray alloc]init ];

}

-(void)displayCurrentQuestionCategoriesInQuestions: (NSMutableDictionary *)interviewQuestions {
    
    NSLog(@"Here are the current categories: ");
    for ( NSArray *currentCategory in [interviewQuestions allKeys] ) {
        NSLog(@"%@,\n", currentCategory);
    }
}

-(NSString *)makeNewAndCurrentInterview: (NSMutableDictionary *) usersInterviewQuestionsAndAnswers
                                forUser: (NSString *)currentUser{
    
    NSUInteger lastInterviewNumber = [usersInterviewQuestionsAndAnswers count];
    NSString *lastInterviewString = [NSString stringWithFormat: @"%@,%lu", @"Interview", lastInterviewNumber];
    
    return lastInterviewString;
}



@end
