//
//  iCassetteViewController.m
//  ICassette
//
//  Created by Claudia Oliva on 14/04/12.
//  Copyright (c) 2012 ASTA. All rights reserved.
//

#import "iCassetteViewController.h"

@interface iCassetteViewController ()

@end

@implementation iCassetteViewController

@synthesize musicPlayer;

NSString *artistName=@"";
NSString *albumName=@"";
NSString *songName=@"";



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [artistLabel setFont:[UIFont fontWithName:@"feltpen_" size:14]];
    [titleLabel setFont:[UIFont fontWithName:@"feltpen_" size:14]];
	
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    [volumeSlider setValue:[musicPlayer volume]];
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        
        [playPauseButton setImage:[UIImage imageNamed:@"pause_.png"] forState:UIControlStateNormal];
        
        [disco startAnimating];
        [disco2 startAnimating];
        
    }
    else {
        [playPauseButton setImage:[UIImage imageNamed:@"play_.png"] forState:UIControlStateNormal];
        
        [disco stopAnimating];
        [disco2 stopAnimating];
        
    }
    
    [self registerMediaPlayerNotifications];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object: musicPlayer];
    
    [musicPlayer endGeneratingPlaybackNotifications];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    
//    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));

    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
    
}

#pragma mark - Metodos Aplicacion

-(IBAction)MuestraHoja:(id)sender{
    
    NSString *artista;
    NSString *titulo;
    NSString *album;
    
    artista = artistName;
    titulo = songName;
    album = albumName;
    
    //NSString *Total = artista, titulo, album; 
    
    
    NSString *Total = [NSString stringWithFormat:@" %@  %@  %@" ,album,artista,titulo];
    
    //    hojaInformacion = [[UIActionSheet alloc] initWithTitle:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Got it.", nil];
    
    hojaInformacion = [[UIActionSheet alloc] initWithTitle:Total delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"oK", nil];
    
    
    [hojaInformacion showInView:self.view];
}

#pragma mark - metodos Reproductor
- (void) registerMediaPlayerNotifications{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(handle_NowPlayingItemChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
    
}

- (void) handle_NowPlayingItemChanged: (id) notification
{
  
    
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    
    if (currentItem != nil) {
        
        UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        
        if (artwork) {
            artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
        }
        
        [artworkImageView setImage:artworkImage];
        
        NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
        if (titleString) {
            titleLabel.text = [NSString stringWithFormat:@"%@",titleString];
            [titleLabel setFont: [UIFont fontWithName: @"Chalkduster" size: titleLabel.font.pointSize]];
            songName = [NSString stringWithFormat:@"Canción: %@",titleString];
            
        } else {
            songName = @"Canción: Unknown title";
        }
        
        NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        if (artistString) {
            artistLabel.text = [NSString stringWithFormat:@"%@",artistString];
            
            artistName = [NSString stringWithFormat:@"Artista: %@",artistString];
            [artistLabel setFont: [UIFont fontWithName: @"Chalkduster" size: artistLabel.font.pointSize]];
            
            //NOMBRE DEL ARTISTA GLOBAL
            //artistName = artistString;
            
        } else {
            artistName = @"Artista: Unknown artist";
        }
        
        NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (albumString) {
            albumName = [NSString stringWithFormat:@"Album: %@",albumString];
            
        } else {
            albumName = @"Album: Unknown album";
        }
        
    }
    else {
        
        artistLabel.text = @"";
        titleLabel.text = @"";
        
        [disco stopAnimating];
        [disco2 stopAnimating];
        
        
    }
    
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playPauseButton setImage:[UIImage imageNamed:@"play_.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"pause_.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        
        [playPauseButton setImage:[UIImage imageNamed:@"play_.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
        
    }
    
}

- (void) handle_VolumeChanged: (id) notification
{
    [volumeSlider setValue:[musicPlayer volume]];
}


- (IBAction)volumeChanged:(id)sender{
    
    [musicPlayer setVolume:[volumeSlider value]];
}

- (IBAction)playPause:(id)sender{
    
    if(musicPlayer.nowPlayingItem!=nil)
    {
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
        
        [disco2 stopAnimating];
        [disco stopAnimating];
    }
    else {
        [musicPlayer play];
        
        disco.animationImages = [NSArray arrayWithObjects:
                                 
                                 [UIImage imageNamed:@"00.png"],
                                 [UIImage imageNamed:@"05.png"],
                                 [UIImage imageNamed:@"10.png"],
                                 [UIImage imageNamed:@"24.png"],
                                 [UIImage imageNamed:@"30.png"],
                                 [UIImage imageNamed:@"38.png"],
                                 [UIImage imageNamed:@"46.png"],
                                 [UIImage imageNamed:@"54.png"],
                                 
                                 [UIImage imageNamed:@"60.png"],
                                 [UIImage imageNamed:@"68.png"],
                                 [UIImage imageNamed:@"78.png"],
                                 
                                 
                                 [UIImage imageNamed:@"97.png"],nil];
        
        
        
        
        
        disco.animationDuration = 2.5;
        disco.animationRepeatCount = 0;
        [disco startAnimating];
        
        
        disco2.animationImages = [NSArray arrayWithObjects:
                                  
                                  [UIImage imageNamed:@"00.png"],
                                  [UIImage imageNamed:@"05.png"],
                                  [UIImage imageNamed:@"10.png"],
                                  [UIImage imageNamed:@"24.png"],
                                  [UIImage imageNamed:@"30.png"],
                                  [UIImage imageNamed:@"38.png"],
                                  [UIImage imageNamed:@"46.png"],
                                  [UIImage imageNamed:@"54.png"],
                                  
                                  [UIImage imageNamed:@"60.png"],
                                  [UIImage imageNamed:@"68.png"],
                                  [UIImage imageNamed:@"78.png"],
                                  
                                  
                                  [UIImage imageNamed:@"97.png"],nil];
        
        
        
        
        
        disco2.animationDuration = 2.5;
        disco2.animationRepeatCount = 0;
        [disco2 startAnimating];
        
        
    }
    }
    
    else 
        if([musicPlayer indexOfNowPlayingItem]!=0)
        {
            
            [musicPlayer play];
            
            disco.animationImages = [NSArray arrayWithObjects:
                                     
                                     [UIImage imageNamed:@"00.png"],
                                     [UIImage imageNamed:@"05.png"],
                                     [UIImage imageNamed:@"10.png"],
                                     [UIImage imageNamed:@"24.png"],
                                     [UIImage imageNamed:@"30.png"],
                                     [UIImage imageNamed:@"38.png"],
                                     [UIImage imageNamed:@"46.png"],
                                     [UIImage imageNamed:@"54.png"],
                                     
                                     [UIImage imageNamed:@"60.png"],
                                     [UIImage imageNamed:@"68.png"],
                                     [UIImage imageNamed:@"78.png"],
                                     
                                     
                                     [UIImage imageNamed:@"97.png"],nil];
            
            
            
            
            
            disco.animationDuration = 2.5;
            disco.animationRepeatCount = 0;
            [disco startAnimating];
            
            
            disco2.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"00.png"],
                                      [UIImage imageNamed:@"05.png"],
                                      [UIImage imageNamed:@"10.png"],
                                      [UIImage imageNamed:@"24.png"],
                                      [UIImage imageNamed:@"30.png"],
                                      [UIImage imageNamed:@"38.png"],
                                      [UIImage imageNamed:@"46.png"],
                                      [UIImage imageNamed:@"54.png"],
                                      
                                      [UIImage imageNamed:@"60.png"],
                                      [UIImage imageNamed:@"68.png"],
                                      [UIImage imageNamed:@"78.png"],
                                      
                                      
                                      [UIImage imageNamed:@"97.png"],nil];
            
            
            
            
            
            disco2.animationDuration = 2.5;
            disco2.animationRepeatCount = 0;
            [disco2 startAnimating];
        }

    
}

- (IBAction)previousSong:(id)sender{
    
    [musicPlayer skipToPreviousItem];
    
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    [artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        titleLabel.text = [NSString stringWithFormat:@"%@",titleString];
        [titleLabel setFont: [UIFont fontWithName: @"Chalkduster" size: titleLabel.font.pointSize]];
        songName = [NSString stringWithFormat:@"Canción: %@",titleString];
        
    } else {
        songName = @"Canción: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"%@",artistString];
        
        artistName = [NSString stringWithFormat:@"Artista: %@",artistString];
        [artistLabel setFont: [UIFont fontWithName: @"Chalkduster" size: artistLabel.font.pointSize]];
        
        //NOMBRE DEL ARTISTA GLOBAL
        //artistName = artistString;
        
    } else {
        artistName = @"Artista: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumName = [NSString stringWithFormat:@"Album: %@",albumString];
        
    } else {
        albumName = @"Album: Unknown album";
    }

    
}

- (IBAction)nextSong:(id)sender{
    
    [musicPlayer skipToNextItem];
    
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    [artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        titleLabel.text = [NSString stringWithFormat:@"%@",titleString];
        [titleLabel setFont: [UIFont fontWithName: @"Chalkduster" size: titleLabel.font.pointSize]];
        songName = [NSString stringWithFormat:@"Canción: %@",titleString];
        
    } else {
        songName = @"Canción: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"%@",artistString];
        
        artistName = [NSString stringWithFormat:@"Artista: %@",artistString];
        [artistLabel setFont: [UIFont fontWithName: @"Chalkduster" size: artistLabel.font.pointSize]];
        
        //NOMBRE DEL ARTISTA GLOBAL
        //artistName = artistString;
        
    } else {
        artistName = @"Artista: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumName = [NSString stringWithFormat:@"Album: %@",albumString];
        
    } else {
        albumName = @"Album: Unknown album";
    }

}

- (IBAction)showMediaPicker:(id)sender {
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
        
        [disco startAnimating];
        [disco2 startAnimating];
    }
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}

-(IBAction)CambiaPortada:(id)sender{
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"Selecciona una Caratula" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Portada Default", @"Portada Roja", @"Portada Negra", @"Portada Purple", @"Portada White", @"Portada Pion", @"Portada Amarilla", @"Portada Verde", nil];
    
    [sheet showInView:self.view];

    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"Revisar %d", buttonIndex);
    
    switch (buttonIndex) {
        case 0:
            portada.image = [UIImage imageNamed:@"portadaDefault.png"];
            NSLog(@"Button 0");
            break;
        case 1:
            NSLog(@"Button 1");
            portada.image = [UIImage imageNamed:@"portada01.png"];
            break;
        case 2:
            portada.image = [UIImage imageNamed:@"portada02.png"];
            NSLog(@"Button 2");
            break;
        case 3:
            portada.image = [UIImage imageNamed:@"purple.png"];
            NSLog(@"Button 3");
            break;
        case 4:
            portada.image = [UIImage imageNamed:@"white.png"];
            NSLog(@"Button 4");
            break;
        
        case 5:
            portada.image = [UIImage imageNamed:@"pioneer.png"];
            NSLog(@"Button 5");
            break;
        case 6:
            portada.image = [UIImage imageNamed:@"yellow.png"];
            NSLog(@"Button 6");
            break;
        case 7:
            portada.image = [UIImage imageNamed:@"green.png"];
            NSLog(@"Button 7");
            break;
            
    }
    
}


-(IBAction)Comenzar:(id)sender{
    
    
    disco.animationImages = [NSArray arrayWithObjects:
                             
                             [UIImage imageNamed:@"00.png"],
                             [UIImage imageNamed:@"05.png"],
                             [UIImage imageNamed:@"10.png"],
                             [UIImage imageNamed:@"24.png"],
                             [UIImage imageNamed:@"30.png"],
                             [UIImage imageNamed:@"38.png"],
                             [UIImage imageNamed:@"46.png"],
                             [UIImage imageNamed:@"54.png"],
                             
                             [UIImage imageNamed:@"60.png"],
                             [UIImage imageNamed:@"68.png"],
                             [UIImage imageNamed:@"78.png"],
                             
                             
                             [UIImage imageNamed:@"97.png"],nil];
    
    
    
    
    
    disco.animationDuration = 2.5;
    disco.animationRepeatCount = 0;
    [disco startAnimating];
    
    
    disco2.animationImages = [NSArray arrayWithObjects:
                              
                              [UIImage imageNamed:@"00.png"],
                              [UIImage imageNamed:@"05.png"],
                              [UIImage imageNamed:@"10.png"],
                              [UIImage imageNamed:@"24.png"],
                              [UIImage imageNamed:@"30.png"],
                              [UIImage imageNamed:@"38.png"],
                              [UIImage imageNamed:@"46.png"],
                              [UIImage imageNamed:@"54.png"],
                              
                              [UIImage imageNamed:@"60.png"],
                              [UIImage imageNamed:@"68.png"],
                              [UIImage imageNamed:@"78.png"],
                              
                              
                              [UIImage imageNamed:@"97.png"],nil];
    
    
    
    
    
    disco2.animationDuration = 2.5;
    disco2.animationRepeatCount = 0;
    [disco2 startAnimating];
    
}


@end
