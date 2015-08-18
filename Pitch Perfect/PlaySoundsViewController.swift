//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dhaval Nagar on 18/08/15.
//  Copyright (c) 2015 JumpByte. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var engine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        engine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        //if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
        if let soundFile = receivedAudio.filePathUrl {
            //var soundFile = NSURL(fileURLWithPath: filePath);
            var error: NSError?

            audioPlayer = AVAudioPlayer(contentsOfURL: soundFile, error: &error)
            audioPlayer.enableRate = true;
            
            // Plays the audio on speaker or in earphone/headphone depending on what is available
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
            AVAudioSession.sharedInstance().setActive(true, error: nil);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func playAudio(speed: Float){
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        println("play fast sound");
//        audioPlayer.stop()
//        audioPlayer.rate = 2
//        audioPlayer.currentTime = 0.0
//        audioPlayer.play()
        playAudio(2)
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        println("play slow sound");
//        audioPlayer.stop()
//        audioPlayer.rate = 0.5
//        audioPlayer.currentTime = 0.0
//        audioPlayer.play()
        playAudio(0.5)
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop()
    }
    
    
    @IBAction func playChipmunkEffect(sender: UIButton) {
        println("playing chipmunk effect")
        playSound(1000, rateOrPitch: "pitch")
    }
    
    func playSound(value: Float, rateOrPitch: String){
        var audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        engine.stop()
        engine.reset()
        
        engine.attachNode(audioPlayerNode)
        
        var changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (rateOrPitch == "rate") {
            changeAudioUnitTime.rate = value
        } else {
            changeAudioUnitTime.pitch = value
        }
        
        engine.attachNode(changeAudioUnitTime)
        engine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        engine.connect(changeAudioUnitTime, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        
        audioPlayerNode.play()        
    }

    
    @IBAction func playDarthVaderEffect(sender: UIButton) {
        playSound(-1000, rateOrPitch: "pitch")
    }
}
