//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Travis Gillespie on 7/19/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var microphoneStatus: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pauseStatus: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    func toggles(bool1 : Bool, bool2 : Bool, bool3 : Bool) -> () {
        stopButton.hidden = bool1
        pauseButton.hidden = bool2
        pauseStatus.hidden = bool3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        toggles(true, bool2: true, bool3: true)
        resumeButton.hidden = true
        self.pauseStatus.text = "tap to pause"

    }

    @IBAction func recordAudio(sender: UIButton) {
        
        self.microphoneStatus.text = "recording"
        recordButton.enabled = false
        toggles(false, bool2: false, bool3: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    

    @IBAction func pauseAudio(sender: UIButton) {
            audioRecorder.pause()
            self.pauseStatus.text = "tap to resume"
            pauseButton.hidden = true
            resumeButton.hidden = false
    }
    
    @IBAction func resumeAudio(sender: UIButton) {
            audioRecorder.record()
            self.pauseStatus.text = "tap to pause"
            pauseButton.hidden = false
            resumeButton.hidden = true
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            let recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        self.microphoneStatus.text = "tap to record"
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

