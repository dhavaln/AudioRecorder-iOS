//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dhaval Nagar on 17/08/15.
//  Copyright (c) 2015 JumpByte. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecord: UIButton!
    @IBOutlet weak var startRecord: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // For Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    // For Hide/Show Stuff, Will be called right before the view appears
    override func viewWillAppear(animated: Bool) {
        recordLabel.hidden = true;
        stopRecord.hidden = true;
        startRecord.enabled = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        startRecord.enabled = false;
        recordLabel.hidden = false;
        stopRecord.hidden = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String
//        let currentDate = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss";
//        let recordingName = formatter.stringFromDate(currentDate) + ".wav" ;
        let recordingName = "my_audio.wav";
        
        //let pathArray = [dirPath]
        let filePath = dirPath?.stringByAppendingPathComponent(recordingName);
        println("Record file path \(filePath)");
        
        let fileUrl = NSURL(fileURLWithPath: filePath!);
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: fileUrl, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            //TODO: show error message to user
            println("Error while recording the audio");
            recordLabel.hidden = true;
            stopRecord.hidden = true;
            startRecord.enabled = true;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordLabel.hidden = true;
        stopRecord.hidden = true;
        
        // Stop the recorder
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil);
        
        println("Recording stopped");
    }
}

