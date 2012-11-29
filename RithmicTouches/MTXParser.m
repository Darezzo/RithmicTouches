//
//  MtxParser.m
//  DisneyChristmasApp
//
//  Created by Pedro Muiños Tortajada on 02/11/11.
//  Copyright (c) 2011 Genera Interactive. All rights reserved.
//

#import "MTXParser.h"

#define LF					@"\n"
#define LFLF				@"\n\n"
#define START_OF_TRACK      @"0 Meta TrkName "
#define ON                  @"On"
#define OFF                 @"Off"
#define END_OF_TRACK        @"TrkEnd"

@implementation MTXParser

- (NSArray*)parseFile:(NSString*)filePath{
    NSMutableArray  *result         = [NSMutableArray array];
    NSError	*error					= nil;
	NSString *srtString				= [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	srtString						= [srtString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    if (!error) {
        NSString	*buffer		= nil;
		NSScanner	*fileScanner	= [[NSScanner alloc] initWithString:srtString];

        // Guarda en buffer la primera línea del MTX.
        [fileScanner scanUpToString:LF intoString:&buffer];
        NSInteger timeResolution    = [[[buffer componentsSeparatedByString:@" "] lastObject] intValue];

        // Ignora la segunda y tercera línea del MTX.
        [fileScanner scanUpToString:LF intoString:nil];
        [fileScanner scanUpToString:LF intoString:nil];

        // Guarda en buffer la cuarta línea que contiene el Tempo del MTX.
        [fileScanner scanUpToString:LF intoString:&buffer];
        NSInteger tempoMTX    = [[[buffer componentsSeparatedByString:@" "] lastObject] intValue];

        // Calcula el tempo.
        NSTimeInterval tempo = 60000000 / tempoMTX;
        
        [fileScanner setScanLocation:[fileScanner scanLocation] + [LF length]];
        [fileScanner scanUpToString:START_OF_TRACK intoString:nil];
        [fileScanner scanUpToString:LF intoString:nil];
        [fileScanner setScanLocation:[fileScanner scanLocation] + [LF length]];
        
        while (![fileScanner isAtEnd]){
            [fileScanner scanUpToString:LF intoString:&buffer];
            NSArray *components = [buffer componentsSeparatedByString:@" "];
            
            if ([[components lastObject] isEqualToString:END_OF_TRACK]) {
                break;
            }else{
                NSTimeInterval t = ([[components objectAtIndex:0] doubleValue] / timeResolution) * (60 / tempo);
                NSArray *noteParts = [[components objectAtIndex:3] componentsSeparatedByString:@"="];
                NSString *note = [noteParts lastObject];
                NSInteger noteIndex = 2 == [note length]?1:2;
                NSInteger octave  = [[note substringFromIndex:noteIndex]intValue];
                note = [[note substringToIndex:noteIndex]uppercaseString];
                if ([[components objectAtIndex:1]isEqualToString:ON]){
                    
                    MtxNote *mtxNote    = [[MtxNote alloc]init];
                    mtxNote.initTime    = t;
                    mtxNote.endTime     = -1;
                    mtxNote.note        = note;
                    mtxNote.octave      = octave;
                    
                    [result addObject:mtxNote];
                    [mtxNote release];
                    
                }else{
                    for (MtxNote* mtxNote in [result reverseObjectEnumerator]) {
                        if (mtxNote.endTime == -1 && [mtxNote.note isEqualToString:note] && mtxNote.octave == octave) {
                            mtxNote.endTime = t;
                            break;
                        }
                    }
                }
                
                buffer  = nil;
                [fileScanner setScanLocation:[fileScanner scanLocation] + [LF length]];
            }
        }
        
        [fileScanner release];
	}else {
		NSLog(@"Error opening srt file %@: %@",filePath,error.userInfo);
	}
    return [NSArray arrayWithArray:result];
}

@end

@implementation MtxNote

@synthesize initTime    = _initTime;
@synthesize endTime     = _endTime;
@synthesize note        = _note;
@synthesize octave      = _octave;

- (void)dealloc{
    [_note release];
    [super dealloc];
}

@end
