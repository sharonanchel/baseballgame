//
//  ViewController.swift
//  game3
//
//  Created by CUAUHTEMOC HERNANDEZ on 9/8/17.
//  Copyright © 2017 TheGroup1. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!
  
    var countdownTimer: Timer!
    var totalTime = 3
    var motionManager: CMMotionManager?
    var audioPlayer = AVAudioPlayer()
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime() {
        countdownLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            totalTime = 3
            countdownLabel.text = "Swing!"
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%2d", seconds)
    }
    
    func checkIfMotionIsAvailable(){
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have motion! \(manager)")
            if manager.isDeviceMotionAvailable{
                print("We have motion")
            }
        } else {
            print("We dont have motion")
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        startTimer()
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfMotionIsAvailable()
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:   Bundle.main.path(forResource: "3,2,1,Swing", ofType: "m4a")!))
            audioPlayer.prepareToPlay()
        }
            
            
        catch{
            print(error)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



