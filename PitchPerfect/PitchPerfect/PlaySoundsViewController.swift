//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Travis Gillespie on 7/20/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetAudioPlayers() -> () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playWithSoundEffect (effect : AnyObject){
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode (effect as! AVAudioNode)
        audioEngine.connect(audioPlayerNode, to: effect as! AVAudioNode, format: nil)
        audioEngine.connect(effect as! AVAudioNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){

        resetAudioPlayers()
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playWithSoundEffect(changePitchEffect)
    }
    
    func playAudio(playbackRate: Float) -> (){
        resetAudioPlayers()
        audioPlayer.rate = playbackRate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        
        resetAudioPlayers()
        
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        changeReverbEffect.wetDryMix = 50
        
        playWithSoundEffect(changeReverbEffect)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        
        resetAudioPlayers()
        
        var changeEchoEffect = AVAudioUnitDistortion()
        changeEchoEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)
        changeEchoEffect.wetDryMix = 50
        
        playWithSoundEffect(changeEchoEffect)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        resetAudioPlayers()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
