//
//  MtxParser.h
//  DisneyChristmasApp
//
//  Created by Pedro Muiños Tortajada on 02/11/11.
//  Copyright (c) 2011 Genera Interactive. All rights reserved.
//


@interface MTXParser : NSObject{
    
}

- (NSArray*)parseFile:(NSString*)filePath;

@end

@interface MtxNote : NSObject {
    NSTimeInterval  _initTime;
    NSTimeInterval  _endTime;
    NSString        *_note;
    NSInteger       _octave;
}

@property (nonatomic,assign)NSTimeInterval initTime;
@property (nonatomic,assign)NSTimeInterval endTime;
@property (nonatomic,copy)NSString   *note;
@property (nonatomic,assign)NSInteger octave;

@end
