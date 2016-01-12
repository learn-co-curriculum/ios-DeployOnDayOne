//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Magfurul Abeer
//

#import "MyApp.h"


@interface MyApp()

@end


@implementation MyApp

#pragma mark - Essential Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *savedDatabase = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"studentDatabase"];
        if ( savedDatabase ) {
            self.database = [savedDatabase mutableCopy];
        } else {
            self.database = [[NSMutableDictionary alloc] init];
        }
        
        NSArray *savedQuestions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"interviewQuestions"];
        if (savedQuestions) {
            self.interviewQuestions = [savedQuestions mutableCopy];
        } else {
            self.interviewQuestions = [[NSMutableArray alloc] init];
        }
        
        self.currentUser = nil;
    }
    return self;
}

-(void)execute
{
    // Begin writing your code here. This method will kick off automatically.
    if (self.currentUser == nil) {
        NSLog(@"Please log in");
        [self logIn];
    }
    [self mainMenu];
}

-(void)logIn {
    NSString *name = [self requestKeyboardInput];
    self.currentUser = name;
    if ( ![ [self.database allKeys] containsObject:name ] ) {
        [self addStudent:name];
    }
}

-(void)logOut {
    self.currentUser = nil;
    NSLog(@"Logged out");
    if (self.currentUser == nil) {
        NSLog(@"Please log in");
        [self logIn];
    }
    [self mainMenu];
}

-(void)mainMenu {
    NSLog(@"Please choose from the following three options:");
    NSLog(@"1. Be interviewed.");
    NSLog(@"2. Write a new interview question.");
    NSLog(@"3. Read an interview with another student.");
    NSLog(@"Simply type in the option number you are interested in, and press enter.");
    NSLog(@"Or enter LOG OUT to log out.");
    NSString *inputString = [self requestKeyboardInput];
    if ([inputString isEqualToString:@"LOG OUT"]) {
        [self logOut];
    } else {
        NSInteger input = [inputString integerValue];
        switch (input) {
            case 1:
                [self beInterviewedMenu];
                break;
            case 2:
                [self newInterviewQuestionMenu];
                break;
            case 3:
                [self readInterviewsMenu];
                break;
            case 0:
                [self developerWarning];
                break;
            default:
                NSLog(@"Error. Please enter a number from 1-3.");
                [self mainMenu];
                break;
        }
    }
    
}

#pragma mark - Developer Methods 

-(void)developerWarning{
    NSLog(@"You are attempting to enter developer mode. Are you sure?");
    NSString *input = [[self requestKeyboardInput] uppercaseString];
    if ([input isEqualToString:@"YES"]) {
        [self developerMode];
    } else if ([input isEqualToString:@"NO"]) {
        [self mainMenu];
    } else {
        NSLog(@"Error. Please type in YES or NO. Input is not case sensitive.");
        [self developerWarning];
    }
}

-(void)developerMode {
    NSLog(@"You are in Developer Mode.");
    NSLog(@"Enter a command");
    NSArray *commands = @[ @"EXIT", @"READ", @"HELP", @"CLEAR DATABASE", @"CLEAR QUESTIONS", @"CLEAR ALL" ];
    NSString *input = [[self requestKeyboardInput] uppercaseString];
    if ( [commands containsObject:input] ) {
        switch ( [commands indexOfObject:input] ) {
            case 0:
                [self developerExit];
                break;
            case 1:
                [self developerRead];
                break;
            case 2:
                [self developerHelp];
                break;
            case 3:
            case 4:
            case 5:
                [self developerClear:input];
                break;
            default:
                break;
        }
    } else {
        NSLog(@"Invalid Command");
        NSLog(@"Enter HELP for a list of commands");
        [self developerMode];
    }
}

-(void)developerExit {
    NSLog(@"You are now exiting Developer Mode");
    [self mainMenu];
}

-(void)developerClear:(NSString *)command {
    if ([command isEqualToString:@"CLEAR ALL"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"studentDatabase"];
        self.database = [@{} mutableCopy];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interviewQuestions"];
        self.interviewQuestions = [@[] mutableCopy];
    } else if ([command isEqualToString:@"CLEAR DATABASE"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"studentDatabase"];
        self.database = [@{} mutableCopy];
    } else if ([command isEqualToString:@"CLEAR QUESTIONS"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interviewQuestions"];
        self.interviewQuestions = [@[] mutableCopy];
    }
    NSLog(@"Cleared!");
    [self developerMode];
}

-(void)developerRead {
    if (self.database == nil) {
        NSLog(@"Database is empty");
    } else {
        for (NSString *student in [self.database allKeys] ) {
            NSLog(@"%@:", student);
            [self printStudentQA:self.database[student]];
        }
        [self developerMode];
    }
}

-(void)developerHelp {
    NSArray *commands = @[ @"EXIT", @"CLEAR DATABASE / CLEAR QUESTIONS / CLEAR ALL", @"READ", @"HELP" ];

    NSLog(@"List of possible Commands:");
    for (NSUInteger i = 0; i < [commands count]; i++) {
        NSLog(@"%lu. %@", i+1, commands[i]);
    }
    [self developerMode];
}

#pragma mark - Be Interviewed Methods

-(void)beInterviewedMenu {
    NSLog(@"You have chosen to be interviewed.");
    NSLog(@"1. Choose the question you will be asked.");
    NSLog(@"2. Be asked a random question.");
    NSLog(@"Simply type in the option number you are interested in, and press enter.");
    NSInteger input = [[self requestKeyboardInput] integerValue];
    switch (input) {
        case 1:
            [self chooseQuestion];
            break;
        case 2:
            [self randomQuestion];
            break;
        default:
            NSLog(@"Error. Please enter a number from 1-2.");
            [self beInterviewedMenu];
            break;
    }

}

-(void)chooseQuestion {
    if ([self.interviewQuestions count] == 0) {
        NSLog(@"There are currently no questions to be asked.");
        NSLog(@"Would you want to write one instead?");
        NSLog(@"Simply type in YES or NO, and press enter.");
        NSString *input = [self requestKeyboardInput];
        if ([input isEqualToString:@"YES"]) {
            [self newInterviewQuestionMenu];
        } else if ([input isEqualToString:@"NO"]) {
            [self mainMenu];
        } else {
            NSLog(@"Error. Please type in YES or NO. Input is case sensitive.");
            [self chooseQuestion];
        }
    } else {
        for (NSUInteger i = 0; i < [self.interviewQuestions count]; i++) {
            NSLog(@"%lu. %@", i+1, self.interviewQuestions[i]);
        }
        NSLog(@"Simply type in the question number you are interested in, and press enter.");
        NSUInteger num = [[self requestKeyboardInput] integerValue];
        [self presentQuestion:num-1 thatIsRandom:NO];
    }
}

-(void)randomQuestion {
    NSUInteger length = [self.interviewQuestions count];
    
    if (length == 0) {
        NSLog(@"There are currently no questions to be asked.");
        NSLog(@"Would you want to write one instead?");
        NSLog(@"Simply type in YES or NO, and press enter.");
        NSString *input = [[self requestKeyboardInput] uppercaseString];
        if ([input isEqualToString:@"YES"]) {
            [self newInterviewQuestionMenu];
        } else if ([input isEqualToString:@"NO"]) {
            [self mainMenu];
        } else {
            NSLog(@"Error. Please type in YES or NO. Input is not case sensitive.");
            [self randomQuestion];
        }
    } else {
        NSArray *questionsAnswered = [self.database[self.currentUser] allKeys];
        NSUInteger randomNumber;
        BOOL doEet = YES;
        while (YES) {
            if ([questionsAnswered count] == [self.interviewQuestions count]) {
                NSLog(@"All questions were answered");
                doEet = NO;
                break;
            }
            randomNumber = arc4random() % length;
            if ( ![questionsAnswered containsObject:self.interviewQuestions[randomNumber]] ) {
                break;
            }
        }
        
        if (doEet) {
            [self presentQuestion:randomNumber thatIsRandom:YES];
        } else {
            [self mainMenu];
        }
    }
}

-(void)presentQuestion:(NSInteger)num thatIsRandom:(BOOL)random {
    NSString *chosenQuestion = self.interviewQuestions[num];
    NSLog(@"%@", chosenQuestion);
    NSString *answer = [self requestKeyboardInput];
    [self addAnswer:answer toQuestion:chosenQuestion forStudent:self.currentUser];
    
    NSLog(@"Would you like to answer another question?");
    NSString *yesOrNO = [[self requestKeyboardInput] uppercaseString];
    
    if ([yesOrNO isEqualToString:@"YES"]) {
        if (random) {
            [self randomQuestion];
        } else {
            [self chooseQuestion];
        }
    } else if ([yesOrNO isEqualToString:@"NO"]) {
        [self mainMenu];
    } else {
        NSLog(@"Error. Please type in YES or NO. Input is case insensitive.");
    }
}


#pragma mark - New Question Methods

-(void)newInterviewQuestionMenu {
    NSLog(@"What question would you like to add?");
    NSString *newQuestion = [self requestKeyboardInput];
    if ([self.interviewQuestions containsObject:newQuestion]) {
        NSLog(@"Question is already part of database.");
        NSLog(@"Do you still want to add a question?");
        NSString *yesOrNO = [[self requestKeyboardInput] uppercaseString];
        
        if ([yesOrNO isEqualToString:@"YES"]) {
            [self newInterviewQuestionMenu];
        } else if ([yesOrNO isEqualToString:@"NO"]) {
            [self mainMenu];
        } else {
            NSLog(@"Error. Please type in YES or NO. Input is case insensitive.");
            [self newInterviewQuestionMenu];
        }
    } else {
        [self addQuestion:newQuestion];
        NSLog(@"Question Added!");
        NSLog(@"Would you like to add another question?");
        NSString *yesOrNO = [[self requestKeyboardInput] uppercaseString];
        
        if ([yesOrNO isEqualToString:@"YES"]) {
            [self newInterviewQuestionMenu];
        } else if ([yesOrNO isEqualToString:@"NO"]) {
            [self mainMenu];
        } else {
            NSLog(@"Error. Please type in YES or NO. Input is case sensitive.");
            [self newInterviewQuestionMenu];
        }
    }
}

#pragma mark - Read Interviews Methods

-(void)readInterviewsMenu {
    if ([[self.database allKeys] count] == 0) {
        NSLog(@"Error. No students");
    } else {
        
        NSArray *students = [self.database allKeys];
        for (NSUInteger i = 0; i < [self.database count]; i++) {
            //NSLog(@"Looping");
            NSLog(@"%lu. %@", i+1, students[i]);
        }
        NSUInteger num = [[self requestKeyboardInput] integerValue];
        NSString *nameOfStudent = students[num - 1];
        NSDictionary *chosenStudent = self.database[nameOfStudent];
        //NSLog(@"%@", [chosenStudent class]);
        if ( [[chosenStudent allKeys] count] == 0 ) {
            NSLog(@"This student has had no interviews yet");
            NSLog(@"Go back to main menu?");
            
            NSString *yesOrNO = [[self requestKeyboardInput] uppercaseString];
            
            if ([yesOrNO isEqualToString:@"YES"]) {
                [self mainMenu];
            } else if ([yesOrNO isEqualToString:@"NO"]) {
                [self readInterviewsMenu];
            } else {
                NSLog(@"Error. Please type in YES or NO. Input is case insensitive.");
                [self readInterviewsMenu];
            }
        } else {
            [self printStudentQA:chosenStudent];
            NSLog(@"Would you like to read someone elses interview?");
            NSString *yesOrNO = [[self requestKeyboardInput] uppercaseString];
            
            if ([yesOrNO isEqualToString:@"YES"]) {
                [self readInterviewsMenu];
            } else if ([yesOrNO isEqualToString:@"NO"]) {
                [self mainMenu];
            } else {
                NSLog(@"Error. Please type in YES or NO. Input is case insensitive.");
            }
        }

    }
}

-(void)printStudentQA:(NSDictionary *)chosenStudent {
    NSArray *keys = [chosenStudent allKeys];
    for (NSString *question in keys) {
        NSString *answer = chosenStudent[question];
        NSLog(@"Q: %@", question);
        NSLog(@"A: %@", answer);
        NSLog(@"-----------------------------------");
    }
}


#pragma mark - Database Methods

-(void)addStudent:(NSString *)student {
    self.database[student] = [[NSMutableDictionary alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:self.database forKey:@"studentDatabase"];
}

-(void)addQuestion:(NSString *)question{
    [self.interviewQuestions addObject:question];
    [[NSUserDefaults standardUserDefaults] setObject:self.interviewQuestions forKey:@"interviewQuestions"];
}

-(void)addAnswer:(NSString *)answer toQuestion:(NSString *)question forStudent:(NSString *)student {
    self.database[student][question] = answer;
    [[NSUserDefaults standardUserDefaults] setObject:self.database forKey:@"studentDatabase"];
}


#pragma mark - Input Method

// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}
@end
