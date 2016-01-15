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

//nsuserdefaults ->read about!


@implementation MyApp

-(void)execute{
    
    NSLog(@"Username: ");
    
    NSArray *temp = @[@"Why do you want to be a student at the Flatiron School?", @"What do you like doing in your spare time?", @"What do you hope to gain from this experience?"];
    
    NSMutableArray *questions = [temp mutableCopy];
    
    NSMutableArray *interviewedStudents = [[NSMutableArray alloc]init];
    
    [interviewedStudents addObject: @[@"John", @"Why do you want to be a student at the Flatiron School?", @"My band is not doing very well. Seeking a career change."] ];
    [interviewedStudents addObject: @[@"Paul", @"What do you like doing in your spare time?", @"I like to sing and occasionally play guitar."]];
    [interviewedStudents addObject: @[@"Ringo", @"What do you hope to gain from this experience?", @"I hope to gain the love and admiration of my peers. Please."] ];
    
    
    NSString * currentUser = [self requestKeyboardInput];
    
    while([currentUser length] < 6 || [currentUser length] > 20) {
        
        NSLog(@"Please enter a username between 6 and 20 characters long.\n");
    
        NSLog(@"Username: ");
        
        currentUser = [self requestKeyboardInput];
        
        [self loginUser:currentUser];
    
    }
    
    [self userMenu];
    
    NSString * userChoice = [self requestKeyboardInput];
    
    while ([self navigateUser: userChoice withPromptQuestions: questions andStudents:interviewedStudents] == false) {
        
        [self userMenu];
        
        userChoice = [self requestKeyboardInput];
        
        [self navigateUser:userChoice withPromptQuestions: questions andStudents:interviewedStudents];
    };
    
}


// login the user ->takes in a string and an array of already registered users

-(void)loginUser:(NSString *)currentUser {
    
    [self createUserWithName: currentUser];
}

//if the user does not exist, register the user ->create a dictionary if they don't alreadt exist
//keys: name, questions

-(NSDictionary *)createUserWithName:(NSString *)name{
    
    NSMutableDictionary *user = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    
    [user setObject: name forKey: @"name"];
    
    [user setObject:questions forKey: @"questions"];
    
    NSLog(@"\nWelcome, %@!\n", user[@"name"]);
    
    return user;
}

-(void)userMenu{
    
    NSLog(@"\nPlease choose from the following three options:\n\n1. Be interviewed \n\n2. Write a new interview question.\n\n3. Read an interview with another student.\n\nSimply type in the option number you are interested in, and press enter.");
}


-(BOOL)navigateUser:(NSString *)userChoice withPromptQuestions:(NSMutableArray *) questions andStudents:(NSMutableArray *)interviewedStudents {
   
        if([userChoice isEqualToString: @"1"]) {
            
            [self beInterviewed: questions];
            
            return true;
        }
        else if ([userChoice isEqualToString: @"2"]){
        
            [self writeANewInterviewQuestion: questions];
            
            return true;
            
        }
        else if ([userChoice isEqualToString: @"3"]){
        
            [self readAnInterviewWithAnotherStudent: interviewedStudents];
            
            return true;
        }
        else {
            NSLog(@"Invalid choice. Please try again.");
            
            return false;
        }
    
    
}

-(void)beInterviewed:(NSMutableArray *)questions{
    
    NSLog(@"You have chosen to be interviewed.\n\n1. Choose the question you will be asked.\n2. Be asked a random question.\n\nSimply type in the option number you are interested in, and press enter.");
    
    NSString *reply = [self requestKeyboardInput];
    
    if ([reply isEqualToString: @"1"]) {
        
        [self chooseQuestion:questions];
        
    }
    else if ([reply isEqualToString: @"2"]) {
        
    }
    else {
        
        NSLog(@"Invalid choice. Please try again.\n");
        
        [self beInterviewed:questions];
    
    }

}


-(void)chooseQuestion:(NSMutableArray *)questions{
    
    NSLog(@"Please choose from the list below:\n");
    
    for(NSUInteger i = 0; i < [questions count]; i++) {
        
        NSLog(@"%lu. %@ \n", i+1, questions[i]);
    }
    
    NSLog(@"Simply type in the option number you are interested in, and press enter.");
    
    NSString *choice = [self requestKeyboardInput];
    
    while([choice integerValue] > [questions count]) {
        
        NSLog(@"Invalid choice.\n Please see the menu above and choose a valid question number.\n");
        
        choice = [self requestKeyboardInput];
        
    }
    
    NSLog(@"You've chosen question %@. Please enter your response below: \n", choice);
    
    [self requestKeyboardInput];
}

-(void)writeANewInterviewQuestion:(NSMutableArray *) questions{
    
    NSLog(@"You have chosen to write a new inerview question.\n\nPlease enter your question below: \n");
    
    NSString *newQuestion = [self requestKeyboardInput];
    
    [questions addObject: newQuestion];
    
    
}

-(void)readAnInterviewWithAnotherStudent:(NSArray *)interviewedStudents{
    
    NSLog(@"You have chosen to read an interview with another student.\n\nPlease select a student from the list below: \n.");
    
    for(NSUInteger i = 0; i < [interviewedStudents count]; i++) {
        
        NSLog(@"%lu. %@ ", i+1, interviewedStudents[i][0]);
    }
    
    NSString *selection = [self requestKeyboardInput];
    while([selection integerValue] > [interviewedStudents count]) {
        
        NSLog(@"Invalid selection. Please see the list above and choose a valid student number. \n\n");
        
        selection = [self requestKeyboardInput];
    }
    
    NSLog(@"You have chosen to read %@'s interview: \n", interviewedStudents[[selection integerValue]-1]);
    
    for(NSInteger i = 1; i < [interviewedStudents count]; i++) {
        
        NSLog(@"%@", interviewedStudents[[selection integerValue]-1][i]);
    }

}

-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}



@end
