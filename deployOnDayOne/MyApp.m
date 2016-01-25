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

-(NSString *)login {
    
    if (self.currentUser) {
        NSLog(@"Welcome %@", self.currentUser);
        return self.currentUser;
    }
    //ask user name
    NSLog(@"What's your name?");
    return [self requestKeyboardInput];
    
}


-(NSString *) mainMenu {
    
    //ask user to pick an option first
    
    NSLog(@"Please choose from the following three options:");
    
    NSLog(@"1. Be interviewed.");
    
    NSLog(@"2. Write a new interview question.");
    
    NSLog(@"3. Read an interview with another student.");
    
    NSLog(@"4. Log out");
    
    NSLog(@"5. Quit");
    
    NSLog(@"Please type in the option number you are interested in, and press enter.");
    
    return [self requestKeyboardInput];
    
}

-(NSString *)interviewMenu {
    
    //if user chooses option 1, list the 2 sub option
    
    NSLog(@"You have chosen to be interviewd.");
    
    NSLog(@"1. Choose the question you will be asked.");
    
    NSLog(@"2. Be asked a random question.");
    
    NSLog(@"Simply type in the option number you are interested in, and press enter.");
    
    
    return [self requestKeyboardInput];
    
}

-(NSDictionary *)addQuestion {
    //add interview question and category
    
    NSLog(@"Enter a category");
    NSMutableDictionary *questions = [[NSMutableDictionary alloc] init];
    
    NSString *category = [self requestKeyboardInput];
    [questions setObject:category forKey:@"category"];
    
    NSLog(@"Add your own question.");
    NSString *question = [self requestKeyboardInput];
    [questions setObject:question forKey:@"question"];
    
    return questions;
}

-(NSDictionary *)printQuestions:(NSMutableArray *)listOfQuestions :(NSMutableArray *)questionAlreadyAnswered {
    //dictionary of questions and answers
    
    for (NSUInteger i = 0; i < [listOfQuestions count]; i++) {
        NSMutableDictionary *q = listOfQuestions[i];
        
        //NSLog(@"%lu, %@", i, q[@"question"]);
        
        if ([self isQuestionAnswered:questionAlreadyAnswered:q[@"question"]]) {
            //don't return anything
        }else {
            NSLog(@"%lu, %@", i, q[@"question"]);
            //compare user question with list of questions
        }
    }
    NSString *option = [self requestKeyboardInput];
    NSUInteger optionInteger = [option integerValue];
    NSMutableDictionary *q = listOfQuestions[optionInteger];
    NSLog(@"%lu, %@", optionInteger, q[@"question"]);
    NSMutableDictionary *answer = [q mutableCopy];
    
    NSString *savedAnswer = [self requestKeyboardInput];
    [answer setObject:savedAnswer forKey:@"answer"];
    
    return answer;
    
}

-(BOOL)isQuestionAnswered:(NSMutableArray *)questionAlreadyAnswered :(NSString *)q {
    //user name to associate answers with questions with a specific person, check if question has been asked
    
    NSPredicate *matchedQuestions = [NSPredicate predicateWithFormat:@"question BEGINSWITH q"];
    
    NSArray *reult = [questionAlreadyAnswered filteredArrayUsingPredicate:matchedQuestions];
    
    if ([reult count] > 0) {
        
        return true;
    } else{
        
        return false;
    }
    
}

-(NSDictionary *)beAskedARandomQuestion :(NSMutableArray *)listofQuestions {
    //be asked a random question from the list of questions, make sure the question hasn't been asked before and then put it in the execution function
    
    NSMutableDictionary *q = listofQuestions[arc4random()% [listofQuestions count]];
    
    NSLog(@"%@", q[@"question"]);
    
    NSMutableDictionary *answerNow = [q mutableCopy];
    
    NSString *answerFromUser = [self requestKeyboardInput];
    
    [answerNow setObject:answerFromUser forKey:@"answer"];
    
    return answerNow;
    
    
}

-(void)setUpUser:(NSString *)userName :(NSMutableDictionary *)userInfo {
    
    if (!userInfo[userName]) {
        [userInfo setObject:[[NSMutableArray alloc] init] forKey:userName];
    }
    
}

-(void)readInterview :(NSMutableDictionary *)differentUsers {
    //tell the person to select a student (key value), print out the questions and answers that student gave
    
    for (NSString *student in [differentUsers allKeys]) {
        NSLog(@"%@", student);
    }
    
    NSString *studentName = [self requestKeyboardInput];
    
    for (NSMutableDictionary *q in differentUsers[studentName]) {
        NSLog(@"%@", q[@"question"]);
        NSLog(@"%@", q[@"answer"]);
    }
    
}
-(void)logout {
    
    self.currentUser = nil;
}


-(void)execute
{
    self.currentUser = [self login];
   
    NSMutableArray *listOfQuestions = [[NSMutableArray alloc] init];
    
    //NSMutableArray *questionAlreadyAnswered = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *differentUsers = [[NSMutableDictionary alloc] init];
    
    //calls the setupuser function which allocates a mutable array for the user in the dictionary
    
    [self setUpUser:self.currentUser :differentUsers];
    
    //reference to the mutable array with the key that is the current user
    NSMutableArray *questionAlreadyAnswered = differentUsers[self.currentUser];
    
    
    while (1) {
        
        NSString *choice = [self mainMenu];
        
        
        if ([choice isEqualToString:@"1"] && [listOfQuestions count]) {
            
            NSString *option = [self interviewMenu];
            
            if ([option isEqualToString:@"1"]) {
                
                NSDictionary *userAnswer = [self printQuestions: listOfQuestions :questionAlreadyAnswered];//added the 2nd parameter later
                
                [questionAlreadyAnswered addObject: userAnswer];
            }
            
            else if([option isEqualToString:@"2"]) {
                
                NSDictionary *userAnswer = [self beAskedARandomQuestion:listOfQuestions];
                [questionAlreadyAnswered addObject:userAnswer];
                
            }
        }
        
        else if([choice isEqualToString:@"2"]) {
            
            [listOfQuestions addObject:[self addQuestion]];
        }
            
        else if ([choice isEqualToString:@"4"]) {
            
            [self logout];
            self.currentUser = [self login];
            [self setUpUser:self.currentUser :differentUsers];
        }
        
        else if ([choice isEqualToString:@"3"]) {
        //print out names, questions and answers
            
            [self readInterview: differentUsers];
            
    
        }
        
        else if ([choice isEqualToString:@"5"]) {
            
            
            break;
        }

    }
    
    
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
