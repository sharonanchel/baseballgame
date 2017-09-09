//
//  ViewController.swift
//  game3
//
//  Created by CUAUHTEMOC HERNANDEZ on 9/8/17.
//  Copyright © 2017 TheGroup1. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!
  
    var countdownTimer: Timer!
    var totalTime = 3
    var motionManager: CMMotionManager?
    
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
    
    func changeSpeed(speed: Double){
        speedLabel.text = "\(round(speed))"
    }
    
    func startGyroUpdates(manager: CMMotionManager, queue: OperationQueue){
        var arr: [Double] = []
        var sum: Double = 0
        manager.gyroUpdateInterval = 1/60
        manager.startGyroUpdates(to: queue){
            (data: CMGyroData?, error: Error?) in
            if let checkData = data {
                if checkData.rotationRate.z < 3 {
                    if arr.count > 0 {
                        for i in arr {
                            sum += i
                        }
                        print(sum/Double(arr.count))
                        self.changeSpeed(speed: sum/Double(arr.count))
                        sum = 0
                        manager.stopGyroUpdates()
                    }
                    arr = []
                } else if (checkData.rotationRate.z > 3) {
                    arr.append(checkData.rotationRate.z)
                }
            }
        }
    }
    
    func checkIfMotionIsAvailable() -> Bool{
        motionManager = CMMotionManager()
        if let manager = motionManager {
            if manager.isDeviceMotionAvailable{
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myQueue = OperationQueue()
        if checkIfMotionIsAvailable() {
            startGyroUpdates(manager: motionManager!, queue: myQueue)
        } else {
            countdownLabel.text = "No motion sensor detected"
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



