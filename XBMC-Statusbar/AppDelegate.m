//
//  AppDelegate.m
//  XBMC-Statusbar
//
//  Created by Lennart Hansen on 16.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize username,password,ipAddress,port;
- (void)dealloc
{
    [super dealloc];
}
-(void)awakeFromNib
{
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setImage:[NSImage imageNamed:@"xbmc.png"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"xbmc-inv.png"]];
    [statusItem setHighlightMode:YES];
    [statusItem setAction:@selector(updateFreeSpaceLabels)];
    
    statusMenu.delegate = self;
    
    //DEBUG
    
    self.ipAddress = @"xbmc.local";
    self.username = @"xbmc";
    self.password = @"hb.m,4dc";
    self.port = 8080;
    
}

- (IBAction)button_UpdateLibrary:(id)sender 
{
    
    NSString* Url = [NSString stringWithFormat:@"http://%@:%@@%@:%d/xbmcCmds/xbmcHttp?command=ExecBuiltIn&parameter=XBMC.UpdateLibrary(video)",username,password,ipAddress,port];
    NSURLRequest *myRequest = [[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:Url]];
    [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self] autorelease];

}

- (IBAction)button_CleanLibrary:(id)sender 
{
    NSString* Url = [NSString stringWithFormat:@"http://%@:%@@%@:%d/xbmcCmds/xbmcHttp?command=ExecBuiltIn&parameter=XBMC.CleanLibrary(video)",username,password,ipAddress,port];
    NSURLRequest *myRequest = [[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:Url]];
    [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self] autorelease];
}

- (IBAction)button_WakeOnLan:(id)sender 
{
    
}

- (IBAction)button_Suspend:(id)sender 
{
    
    NSString* Url = [NSString stringWithFormat:@"http://%@:%@@%@:%d/xbmcCmds/xbmcHttp?command=ExecBuiltIn&parameter=XBMC.Suspend",username,password,ipAddress,port];
    NSURLRequest *myRequest = [[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:Url]];
    [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self] autorelease];

}

- (IBAction)button_ShutDown:(id)sender 
{
    NSString* Url = [NSString stringWithFormat:@"http://%@:%@@%@:%d/xbmcCmds/xbmcHttp?command=ExecBuiltIn&parameter=XBMC.Shutdown",username,password,ipAddress,port];
    NSURLRequest *myRequest = [[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:Url]];
    [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self] autorelease];

}

- (IBAction)button_Preferences:(id)sender 
{
    [preferencesWindow makeKeyAndOrderFront:nil];
}

- (IBAction)button_Quit:(id)sender 
{    
    [NSApp terminate: nil]; 
}
@end
