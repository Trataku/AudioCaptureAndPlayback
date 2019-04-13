//
//  AudioPlayerViewController.swift
//  Audio Capture and Playback
//
//  Created by Dylan Mouser on 4/12/19.
//  Copyright © 2019 Dylan Mouser. All rights reserved.
//

import UIKit
import AVKit

class AudioPlayerViewController: UIViewController, AVAudioRecorderDelegate {
    
    let playImage = UIImage(named: "play")
    let pauseImage = UIImage(named: "pause")
    let recordImage = UIImage(named: "record")
    let stopImage = UIImage(named: "stop")
    
    @IBOutlet weak var PlayButton: UIBarButtonItem!
    @IBOutlet weak var RecordButton: UIBarButtonItem!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    let recordingSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
         AVEncoderBitRateKey: 16,
         AVNumberOfChannelsKey: 2,
         AVSampleRateKey: 44100.0] as [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission(){
            [unowned self] allowed in
            if allowed {
                self.EnableRecording()
                self.CheckForAndEnablePlay()
            }
            else{
                self.DisplayAlert(alertMessage: "You must allow recording to access functionality of this app", alertTitle: "Permission Error")
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func EnableRecording(){
        RecordButton.isEnabled = true
    }
    
    func GetDirectory() -> URL{
        let documentDirectoryPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryURL = documentDirectoryPaths[0]
        
        return documentDirectoryURL
    }
    
    func GetAudioURL() -> URL{
        let audioFileName = "audio.caf"
        let audioFileURL = GetDirectory().appendingPathComponent(audioFileName)
        return audioFileURL
    }
    
    func CheckForAndEnablePlay(){
        let fileManager = FileManager.default
        
        if(fileManager.fileExists(atPath: GetAudioURL().path)){
            PlayButton.isEnabled = true
        }
    }
    
    func DisplayAlert(alertMessage: String, alertTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func RecordButtonPressed(_ sender: UIBarButtonItem) {
        
        if(audioRecorder == nil){
            do{
                audioRecorder = try AVAudioRecorder(url: GetAudioURL(), settings: recordingSettings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                RecordButton.image = stopImage
                PlayButton.isEnabled = false
            }catch{
                DisplayAlert(alertMessage: "Could not Record", alertTitle: "Recording Error")
            }
        }
        else{
            audioRecorder.stop()
            audioRecorder = nil
            
            RecordButton.image = recordImage
            CheckForAndEnablePlay()
        }
    }
    
    @IBAction func PlayButtonPressed(_ sender: UIBarButtonItem) {
        if(audioPlayer == nil){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: GetAudioURL())
                audioPlayer.play()
                
                PlayButton.image = stopImage
                RecordButton.isEnabled = false
            }catch{
                DisplayAlert(alertMessage: "Audio Could not be Played", alertTitle: "Audio Playback Error")
            }
        }
        else{
            if(audioPlayer.isPlaying){
                audioPlayer.stop()
            }
            audioPlayer = nil
            PlayButton.image = playImage
            RecordButton.isEnabled = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
