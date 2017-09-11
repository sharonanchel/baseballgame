
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
    @IBOutlet weak var backgroundImage: UIImageView!
  
    var countdownTimer: Timer!
    var totalTime = 3
    var motionManager: CMMotionManager?
    var audioPlayer = AVAudioPlayer()
    var arr: [Double] = []
    var sum: Double = 0
    var batter = Batter()
    var player = Player()
    var strikes: Int = 0
    var hits: Int = 0
    var currentGamePoints: Int = 0
    var leaderboard: [Int] = [100]
    var audioPlayerArray         = [AVAudioPlayer]()
    
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
                player.setHitScore(hitScore: Int((sum/Double(arr.count)*3)))
                DispatchQueue.main.async {
                    print("Batter: \(self.batter.getHitScore()), Player: \(self.player.getHitScore())")
                    if self.batter.checkIfHit(playersNum: self.player.getHitScore()){
                        //here is where you would lose or hit sound
                        self.hits += 1
                    } else {
                        //here is where you would strike the person out once
                        self.currentGamePoints += self.player.getHitScore()
                        self.strikes += 1
                    }
                    self.speedLabel.text = "\(self.player.hitScore) points!"
                }
                sum = 0
                arr = []
                return true
            } else {
                return false
            }
        } else {
            //here is where you would add the swoops sound
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
                    DispatchQueue.main.async {
                        self.checkStrikeOut()
                    }
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
    
    func resetGame(){
        strikes = 0
        hits = 0
        currentGamePoints = 0
    }
    
    // this is where we check the strike out
    func checkStrikeOut(){
        if strikes == 1 {
            countdownLabel.text = "Strike 1"
            playSound("strike1.mp3")
        }
        else if strikes == 2 {
            countdownLabel.text = "Strike 2"
            playSound("strike2.mp3")
        }
        else if strikes == 3 {
            countdownLabel.text = "You WIN!"
            playSound("strike3.mp3")
            playSound("Cheers1.m4a")
            leaderboard.append(currentGamePoints)
            resetGame()
        }
        if hits == 1 {
            countdownLabel.text = "The batter hit the ball, You Lose"
            playSound("metalbat.mp3")
            playSound("Sad Trombone Sound.mp3")
            resetGame()
        }
    }

    
    @IBAction func startButton(_ sender: UIButton) {
        startTimer()
//      audioPlayer.play()
        playSound("3,2,1,Swing.m4a")
        batter.generateHitScore()
    }
    
    func playSound(_ soundName: String)
    {
        var audioPlayer        = AVAudioPlayer()
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: nil)!)
        
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound )
            audioPlayerArray.append(audioPlayer)
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch{
            print("error")
        }
    }
    
    @IBAction func leaderboardButton(_ sender: UIButton) {
        var leadText = ""
        leaderboard.sort{ $0 > $1 }
        for score in leaderboard{
            leadText += "You: \(score) \r\n"
        }
        countdownLabel.text = leadText
    }
    
 

    
//    
//    func accessSoundFiles(){
//        do{
//            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:   Bundle.main.path(forResource: "3,2,1,Swing", ofType: "m4a")!))
//            audioPlayer.prepareToPlay()
//        }
//        catch{
//            print(error)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.layer.zPosition = -1
//        accessSoundFiles()
//        backgroundImage.layer.zPosition = -1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



