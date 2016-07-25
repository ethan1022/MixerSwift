//
//  ViewController.swift
//  混音
//
//  Created by Bruce on 16/7/25.
//  Copyright © 2016年 Bruce. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    lazy var engine = AVAudioEngine()
    lazy var mixer = AVAudioMixerNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        输入
        let input = engine.inputNode!
        //        输出
        let output = engine.outputNode
        
        //        音效
        let delay = AVAudioUnitDelay()
        delay.wetDryMix = 30
        delay.feedback = 30
        delay.delayTime = 0.3
        engine.attach(delay)
        
        //        混音
        engine.attach(mixer)
        
        //        要写入到的文件
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        path = path.appendingPathComponent("finish.aiff")
        
        let audioFile = try! AVAudioFile.init(forWriting: NSURL.fileURL(withPath: path as String), settings: [:])
        
        mixer.installTap(onBus: 0, bufferSize: 8192, format: input.inputFormat(forBus: 0)) { (buffer, when) in
            try! audioFile.write(from: buffer)
        }
        
        engine.connect(input, to: delay, format: input.inputFormat(forBus: 0))
        engine.connect(delay, to: mixer, format: input.inputFormat(forBus: 0))
        engine.connect(mixer, to: output, format: input.inputFormat(forBus: 0))
    }
    
    func start() {
        try! engine.start()
    }
    
    func stop() {
        mixer.removeTap(onBus: 0)
        engine.stop()
    }
    
    @IBAction func control(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected == true ? start() : stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

