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
    var arr: [Double] = []
    var sum: Double = 0
    
    let myQueue = OperationQueue()
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime() {
        countdownLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            totalTime = 3
            countdownLabel.text = "Swing!"
            if checkIfMotionIsAvailable() {
                startGyroUpdates(manager: motionManager!, queue: myQueue)
            } else {
                countdownLabel.text = "No motion sensor detected"
            }
            countdownTimer.invalidate()
        }
    }
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%2d", seconds)
    }
    
    
    func getZrotation(data: CMGyroData!) -> Bool{
        if data.rotationRate.z < 3 {
            if arr.count > 0 {
                for i in arr {
                    sum += i
                }
                print(arr)
                print(sum/Double(arr.count))
                DispatchQueue.main.async {
                    self.speedLabel.text = "\(Int(self.sum/Double(self.arr.count))*3) points!"
                }
                sum = 0
                arr = []
                return true
            } else {
                return false
            }
        } else {
            arr.append(data.rotationRate.z)
            return false
        }
    }
    
    
    func startGyroUpdates(manager: CMMotionManager, queue: OperationQueue){
        manager.gyroUpdateInterval = 1/60
        manager.startGyroUpdates(to: queue){
            (data: CMGyroData?, error: Error?) in
            if let checkData = data {
                if self.getZrotation(data: checkData) {
                    manager.stopGyroUpdates()
                }
            } else if let errors = error{
                print(errors)
            }
        }
    }
    
    func checkIfMotionIsAvailable() -> Bool{
        motionManager = CMMotionManager()
        if let manager = motionManager {
            if manager.isDeviceMotionAvailable {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        startTimer()
        audioPlayer.play()
        
        
    }
    
    func accessSoundFiles(){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:   Bundle.main.path(forResource: "3,2,1,Swing", ofType: "m4a")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessSoundFiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



