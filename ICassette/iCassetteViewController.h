//
//  iCassetteViewController.h
//  ICassette
//
//  Created by Claudia Oliva on 14/04/12.
//  Copyright (c) 2012 ASTA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface iCassetteViewController : UIViewController <UIActionSheetDelegate, MPMediaPickerControllerDelegate>{
    
    IBOutlet UIImageView *artworkImageView;
    IBOutlet UIActionSheet *hojaInformacion;
    
    IBOutlet UISlider *volumeSlider;
    IBOutlet UIButton *playPauseButton;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *albumLabel;
    
    MPMusicPlayerController *musicPlayer;
    
    IBOutlet UIImageView *disco;
    IBOutlet UIImageView *disco2;
    
    IBOutlet UIActionSheet *sheet;
    
    IBOutlet UIImageView *portada;
    
}

-(IBAction)MuestraHoja:(id)sender;

@property(nonatomic, retain) MPMusicPlayerController *musicPlayer;


- (IBAction)volumeChanged:(id)sender;
- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void) registerMediaPlayerNotifications;

-(IBAction)Comenzar:(id)sender;

-(IBAction)CambiaPortada:(id)sender;


@end
