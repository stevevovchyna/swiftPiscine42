//
//  SpeechRecognition.swift
//  Siri
//
//  Created by Steve Vovchyna on 29.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import Speech
import AVFoundation
import UIKit

class SpeechRecognizer {
    var audioEngine: AVAudioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    func stopRecording(with recordButtonView: UIView) {
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            recognitionTask.finish()
            self.recognitionTask = nil
        }
        recordButtonView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func recordAndRecognizeSpeech(in textInput: UITextField, with recordButtonView: UIView, for view: UIViewController) {
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            recordButtonView.layer.backgroundColor = UIColor.lightGray.cgColor
            presentAlert(alertTitle: "Problem recognizing the speech", alertMessage: "Please try again later", in: view)
        }
        guard let myRecognizer = SFSpeechRecognizer(), myRecognizer.isAvailable else { return }
        recordButtonView.layer.backgroundColor = UIColor.red.cgColor
        recordButtonView.layer.cornerRadius = recordButtonView.frame.size.height / 2
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if result != nil {
                if let result = result {
                    let finalString = result.bestTranscription.formattedString
                    if self.audioEngine.isRunning { textInput.text = finalString }
                } else if let error = error {
                    recordButtonView.layer.backgroundColor = UIColor.lightGray.cgColor
                    presentAlert(alertTitle: "Problem recognizing the speech", alertMessage: error.localizedDescription, in: view)
                }
            }
        }
    }
}
