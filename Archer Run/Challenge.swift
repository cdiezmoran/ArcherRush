//
//  Challenge.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/25/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

enum ChallengeType: String {
    case Orc = "orc"
    case Run = "run"
    case Target = "target"
    case Coin = "coin"
    case Shoot = "shoot"
    case Undead = "undead"
}

enum ChallengeState: String {
    case Active = "activeChallengeState"
    case Completed = "completedChallengeState"
}

enum GoalType: String {
    case SingleGame = "singleGame"
    case Times = "times"
    case Overall = "overall"
}

class Challenge {
    
    var didCompleteChallenge: Bool = false
    var goal: Int
    var goalType: GoalType
    var progress: Int
    var state: ChallengeState
    var type: ChallengeType
    var times: Int
    var timesFlag: Bool = false
    var timesProgress: Int
    
    init(goal: Int, type: ChallengeType, goalType: GoalType) {
        self.goal = goal
        self.goalType = goalType
        self.progress = 0
        self.state = .Active
        self.type = type
        self.times = 1
        self.timesProgress = 0
    }
    
    init(withTimes times: Int, goal: Int, type: ChallengeType) {
        self.goal = goal
        self.goalType = .Times
        self.progress = 0
        self.state = .Active
        self.type = type
        self.times = times
        self.timesProgress = 0
    }
    
    init(withProgress progress: Int, goal: Int, type: ChallengeType, goalType: GoalType, state: ChallengeState, times: Int, timesProgress: Int) {
        self.goal = goal
        self.goalType = goalType
        self.progress = progress
        self.state = state
        self.type = type
        self.times = times
        self.timesProgress = timesProgress
    }
    
    func description() -> String {
        var descriptionString: String
        
        switch type {
        case .Orc:
            if self.goal == 1 { descriptionString = "Kill \(self.goal) Orc" }
            else { descriptionString = "Kill \(self.goal) Orcs" }
            break
        case .Run:
            if self.goal == 1 { descriptionString = "Run \(self.goal) meter" }
            else { descriptionString = "Run \(self.goal) meters" }
            break
        case .Target:
            if self.goal == 1 { descriptionString = "Hit \(self.goal) target" }
            else { descriptionString = "Hit \(self.goal) targets" }
            break
        case .Coin:
            if self.goal == 1 { descriptionString = "Collect \(self.goal) coin" }
            else { descriptionString = "Collect \(self.goal) coins" }
            break
        case .Shoot:
            if self.goal == 1 { descriptionString = "Shoot \(self.goal) arrow" }
            else { descriptionString = "Shoot \(self.goal) arrows" }
            break
        case .Undead:
            if self.goal == 1 { descriptionString = "Kill \(self.goal) Undead" }
            else { descriptionString = "Kill \(self.goal) Undeads" }
            break
        }
        
        if  goalType == .Times {
            descriptionString += " \(times)x in a row"
        }
        
        if goalType == .SingleGame {
            descriptionString += " in a single run"
        }
        
        return descriptionString
    }
    
    func progressDescription() -> String {
        var progressString: String
        
        if goalType == .Times {
            if times - timesProgress <= 0 {
                return "Complete"
            }
            
            let timesToGo =  times - timesProgress
            if timesToGo == 1 {
                progressString = "\(timesToGo) time to go"
            }
            else {
                progressString = "\(timesToGo) times to go"
            }
        }
        else {
            if goal - progress <= 0 {
                return "Complete"
            }
            
            let toGo = goal - progress
            switch type {
            case .Orc:
                if toGo == 1 { progressString = "\(toGo) orc to go" }
                else { progressString = "\(toGo) orcs to go" }
                break
            case .Run:
                if toGo == 1 { progressString = "\(toGo) meter to go" }
                else { progressString = "\(toGo) meters to go" }
                break
            case .Target:
                if toGo == 1 { progressString = "\(toGo) target to go" }
                else { progressString = "\(toGo) targets to go" }
                break
            case .Coin:
                if toGo == 1 { progressString = "\(toGo) coin to go" }
                else { progressString = "\(toGo) coins to go" }
                break
            case .Shoot:
                if toGo == 1 { progressString = "\(toGo) arrow to go" }
                else { progressString = "\(toGo) arrows to go" }
                break
            case .Undead:
                if toGo == 1 { progressString = "\(toGo) undead to go" }
                else { progressString = "\(toGo) undeads to go" }
                break
            }
        }
        
        return progressString
    }
    
    func getTexture() -> SKTexture {
        switch type {
        case .Orc:
            return SKTexture(imageNamed: "challengeOrc")
        case .Run:
            return SKTexture(imageNamed: "challengeRun")
        case .Target:
            return SKTexture(imageNamed: "challengeTarget")
        case .Coin:
            return SKTexture(imageNamed: "challengeCoin")
        case .Shoot:
            return SKTexture(imageNamed: "challengeArrows")
        case .Undead:
            return SKTexture(imageNamed: "challengeUndead")
        }
    }
    
    func getBGColor() -> UIColor {
        switch type {
        case .Orc:
            //Red
            return UIColor.flatRedColor()
        case .Run:
            //Green
            return UIColor.flatGreenColor()
        case .Target:
            //Orange
            return UIColor.flatOrangeColor()
        case .Coin:
            //Yellow
            return UIColor.flatYellowColor()
        case .Shoot:
            //Blue
            return UIColor.flatSkyBlueColor()
        case .Undead:
            //Purple
            return UIColor.flatPurpleColor()
        }
    }
}
