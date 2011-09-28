//
//  Document.m
//  Strawberry
//
//  Created by Chris Marrin on 9/8/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "Document.h"

#import "DocumentWindowController.h"

@implementation Document

@synthesize content, encoding;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)updateTextView
{
    if (![[self windowControllers] count])
        return;
        
    NSAttributedString* string = [[NSAttributedString alloc]initWithString:self.content ? self.content : @""];
    [[((WindowController*) [[self windowControllers] objectAtIndex:0]).textView textStorage] setAttributedString:string];
}

- (void)makeWindowControllers
{
    // FIXME: For now just make a DocumentWindowController. Later on we need to deal with ProjectWindowControllers
    DocumentWindowController* controller = [[DocumentWindowController alloc] initWithWindowNibName:@"Document"];
    [self addWindowController:controller];
    [self updateTextView];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)controller
{
    [super windowControllerDidLoadNib:controller];
    
    // FIXME: For now assume a single WindowController
    if (self.content)
        [self updateTextView];

    [super windowControllerDidLoadNib:controller];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
    NSError* error;
    self.content = [NSMutableString stringWithContentsOfURL:absoluteURL usedEncoding:&encoding error:&error];
    [self updateTextView];
    return true;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.content = [data bytes];
    [self updateTextView];
    return YES;
}
 
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // FIXME: Make sure file is ready to save (get text from TextView, call breakUndoCoalescing)
    return [self.content dataUsingEncoding:self.encoding];
}

@end
