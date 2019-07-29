//
//  ecordsoundsviewcontroller.swift
//  new-pro
//
//  Created by Wael Yazqi on 2019-03-24.
//  Copyright © 2019 Wael Yazqi. All rights reserved.
//

import UIKit
import AVFoundation

class recordsoundsviewcontroller: UIViewController,AVAudioRecorderDelegate  {
   
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var Recordinglabel: UILabel!
     @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stoprecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    stoprecording.isEnabled = false
    
    }

    func configureUI(isRecording: Bool) {
        stoprecording.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        Recordinglabel.text = "Recording in Progress"
        configureUI(isRecording: true)
 
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        print(filePath)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stoprecording(_ sender: Any) {
        configureUI(isRecording: false)
        Recordinglabel.text = "Tab to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag  {
            performSegue(withIdentifier: "stoprecording", sender: audioRecorder.url)
        }else{
        print("Recording Was not successful")
    }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stoprecording" {
            let playsoundVC = segue.destination as! playsoundViewController
            let recordedAudioURL = sender as! URL
            playsoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}
