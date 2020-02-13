//
//  CaucusReportTests.swift
//  CaucusReportTests
//
//  Created by Darrell Root on 2/12/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import XCTest

class CaucusReportTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
// test cases are from https://nvdems.com/wp-content/uploads/2020/02/Caucus-Memo_-Delegate-Count-Scenarios-and-Tie-Breakers.pdf
    
    func test1a() {
        let model = Model()
        
        model.precinctDelegates = 7
        model.totalAttendees = 79
        model.attendeeVote2["Bennet"] = 14
        model.attendeeVote2["Biden"] = 19
        model.attendeeVote2["Bloomberg"] = 18
        model.attendeeVote2["Booker"] = 12
        model.attendeeVote2["Buttigieg"] = 16

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 1)
        XCTAssert(delegates["Biden"] == 2)
        XCTAssert(delegates["Bloomberg"] == 2)
        XCTAssert(delegates["Booker"] == 1)
        XCTAssert(delegates["Buttigieg"] == 1)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 1.2405)
        XCTAssert(model.delegateFactor(candidate: "Biden") == 1.6835)
        XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 1.5949)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 1.0633)
        XCTAssert(model.delegateFactor(candidate: "Buttigieg") == 1.4177)
        XCTAssert(coinToss == "No card draws\n")
    }
    
    func test1b() {
        let model = Model()
        
        model.precinctDelegates = 6
        model.totalAttendees = 26
        model.attendeeVote2["Delaney"] = 8
        model.attendeeVote2["Gabbard"] = 4
        model.attendeeVote2["Kloubuchar"] = 5
        model.attendeeVote2["Patrick"] = 5
        model.attendeeVote2["Sanders"] = 4

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Delaney"] == 2)
        XCTAssert(delegates["Gabbard"] == 1)
        XCTAssert(delegates["Kloubuchar"] == 1)
        XCTAssert(delegates["Patrick"] == 1)
        XCTAssert(delegates["Sanders"] == 1)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Delaney") == 1.8462)
        XCTAssert(model.delegateFactor(candidate: "Gabbard") == 0.9231)
        XCTAssert(model.delegateFactor(candidate: "Kloubuchar") == 1.1538)
        XCTAssert(model.delegateFactor(candidate: "Patrick") == 1.1538)
        XCTAssert(model.delegateFactor(candidate: "Sanders") == 0.9231)
        XCTAssert(coinToss == "No card draws\n")
    }

    func test2Uncommitted() {
        let model = Model()
        
        model.precinctDelegates = 4
        model.totalAttendees = 76
        model.attendeeVote2["Steyer"] = 13
        model.attendeeVote2["Warren"] = 13
        model.attendeeVote2["Williamson"] = 13
        model.attendeeVote2["Yang"] = 13
        model.attendeeVote2["Uncommitted"] = 24

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Steyer"] == 1)
        XCTAssert(delegates["Warren"] == 1)
        XCTAssert(delegates["Williamson"] == 1)
        XCTAssert(delegates["Yang"] == 1)
        XCTAssert(delegates["Uncommitted"] == 0)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Steyer") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Warren") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Williamson") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Yang") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Uncommitted") == 1.2632)
        XCTAssert(coinToss == "No card draws\n")
    }

    func test2WriteIn() {
        let model = Model()
        model.precinctDelegates = 4
        model.totalAttendees = 76
        model.attendeeVote2["Steyer"] = 13
        model.attendeeVote2["Warren"] = 13
        model.attendeeVote2["Williamson"] = 13
        model.attendeeVote2["Yang"] = 13
        model.attendeeVote2["Write-ins"] = 24
        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(model.validResult == false)
    }
    
    func test2a() {
        let model = Model()
        
        model.precinctDelegates = 4
        model.totalAttendees = 76
        model.attendeeVote2["Steyer"] = 13
        model.attendeeVote2["Warren"] = 13
        model.attendeeVote2["Williamson"] = 13
        model.attendeeVote2["Yang"] = 13
        model.attendeeVote2["Bennet"] = 24

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Steyer"] == 1)
        XCTAssert(delegates["Warren"] == 1)
        XCTAssert(delegates["Williamson"] == 1)
        XCTAssert(delegates["Yang"] == 1)
        XCTAssert(delegates["Bennet"] == 1)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Steyer") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Warren") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Williamson") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Yang") == 0.6842)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 1.2632)
        XCTAssert(coinToss == "No card draws\n")
    }
    
    func test2b() {
        let model = Model()
        
        model.precinctDelegates = 5
        model.totalAttendees = 73
        model.attendeeVote2["Bennet"] = 12
        model.attendeeVote2["Biden"] = 14
        model.attendeeVote2["Bloomberg"] = 22
        model.attendeeVote2["Booker"] = 25
        model.attendeeVote2["Buttigieg"] = 0

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 1)
        XCTAssert(delegates["Biden"] == 1)
        XCTAssert(delegates["Bloomberg"] == 1)
        XCTAssert(delegates["Booker"] == 2)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 0.8219)
        XCTAssert(model.delegateFactor(candidate: "Biden") == 0.9589)
        XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 1.5068)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 1.7123)
        XCTAssert(model.delegateFactor(candidate: "Buttigieg") == 0.0)
        XCTAssert(coinToss == "No card draws\n")
    }

    func test3a() {
        let model = Model()
        
        model.precinctDelegates = 6
        model.totalAttendees = 100
        model.attendeeVote2["Bennet"] = 38
        model.attendeeVote2["Biden"] = 24
        model.attendeeVote2["Bloomberg"] = 22
        model.attendeeVote2["Booker"] = 16
        model.attendeeVote2["Buttigieg"] = 0

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 2)
        XCTAssert(delegates["Biden"] == 2)
        XCTAssert(delegates["Bloomberg"] == 1)
        XCTAssert(delegates["Booker"] == 1)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 2.2800)
        XCTAssert(model.delegateFactor(candidate: "Biden") == 1.4400)
        XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 1.3200)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 0.9600)
        XCTAssert(model.delegateFactor(candidate: "Buttigieg") == 0.0)
        XCTAssert(coinToss == "No card draws\n")
    }
    func test3b() {
        let model = Model()
        
        // delegate factor for non-viable candidates irrelevant
        // votes should not have been allowed for non-viable in alignment 2
        // but still testing that no delegates awarded to non-viables
        model.precinctDelegates = 10
        model.totalAttendees = 75
        model.attendeeVote2["Bennet"] = 10
        model.attendeeVote2["Biden"] = 5
        model.attendeeVote2["Bloomberg"] = 10
        model.attendeeVote2["Booker"] = 23
        model.attendeeVote2["Buttigieg"] = 27

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 0)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(delegates["Bloomberg"] == 0)
        XCTAssert(delegates["Booker"] == 5)
        XCTAssert(delegates["Buttigieg"] == 5)
        XCTAssert(model.viabilityPercentage == 0.15)
        //XCTAssert(model.delegateFactor(candidate: "Bennet") == 0.00)
        //XCTAssert(model.delegateFactor(candidate: "Biden") == 0.0)
        //XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 0.0)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 3.0667)
        XCTAssert(model.delegateFactor(candidate: "Buttigieg") == 3.600)
        XCTAssert(coinToss == "No card draws\n")
    }
    
    func test4a() {
        let model = Model()
        
        model.precinctDelegates = 5
        model.totalAttendees = 60
        model.attendeeVote2["Bennet"] = 0
        model.attendeeVote2["Biden"] = 20
        model.attendeeVote2["Bloomberg"] = 20
        model.attendeeVote2["Booker"] = 20
        model.attendeeVote2["Buttigieg"] = 0

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 0)
        XCTAssert(delegates["Biden"] == 1)
        XCTAssert(delegates["Bloomberg"] == 1)
        XCTAssert(delegates["Booker"] == 1)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 0.0)
        XCTAssert(model.delegateFactor(candidate: "Biden") == 1.6667)
        XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 1.6667)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 1.6667)
        XCTAssert(model.delegateFactor(candidate: "Buttigieg") == 0.0)
        XCTAssert(coinToss == "Draw cards for 2 delegates between Biden Bloomberg Booker\n")
    }

    func test4b() {
        let model = Model()
        
        model.precinctDelegates = 5
        model.totalAttendees = 14
        model.attendeeVote2["Bennet"] = 0
        model.attendeeVote2["Biden"] = 0
        model.attendeeVote2["Bloomberg"] = 7
        model.attendeeVote2["Booker"] = 7
        model.attendeeVote2["Buttigieg"] = 0

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 0)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(delegates["Bloomberg"] == 2)
        XCTAssert(delegates["Booker"] == 2)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 0.0)
        XCTAssert(model.delegateFactor(candidate: "Biden") == 0.0)
        XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 2.5000)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 2.5000)
        XCTAssert(model.delegateFactor(candidate: "Buttigieg") == 0.0)
        XCTAssert(coinToss == "Draw cards for 1 delegates between Bloomberg Booker\n")
    }

    func test4c() {
        let model = Model()
        
        model.precinctDelegates = 8
        model.totalAttendees = 100
        model.attendeeVote2["Bennet"] = 15
        model.attendeeVote2["Biden"] = 45
        model.attendeeVote2["Bloomberg"] = 20
        model.attendeeVote2["Booker"] = 20

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 1)
        XCTAssert(delegates["Biden"] == 3)
        XCTAssert(delegates["Bloomberg"] == 1)
        XCTAssert(delegates["Booker"] == 1)
        XCTAssert(model.viabilityPercentage == 0.15)
        XCTAssert(model.delegateFactor(candidate: "Bennet") == 1.2)
        XCTAssert(model.delegateFactor(candidate: "Biden") == 3.6)
        XCTAssert(model.delegateFactor(candidate: "Bloomberg") == 1.6)
        XCTAssert(model.delegateFactor(candidate: "Booker") == 1.6)

        XCTAssert(coinToss == "Draw cards for 2 delegates between Biden Bloomberg Booker\n")
        
    }

    func test1delegateA() {
        let model = Model()
        
        model.precinctDelegates = 1
        model.totalAttendees = 79
        model.attendeeVote2["Bennet"] = 14
        model.attendeeVote2["Biden"] = 19
        model.attendeeVote2["Bloomberg"] = 18
        model.attendeeVote2["Booker"] = 12
        model.attendeeVote2["Buttigieg"] = 16

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 0)
        XCTAssert(delegates["Biden"] == 1)
        XCTAssert(delegates["Bloomberg"] == 0)
        XCTAssert(delegates["Booker"] == 0)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(coinToss == "No card draws\n")
    }
    
    func test1delegateTie() {
        let model = Model()
        
        model.precinctDelegates = 1
        model.totalAttendees = 79
        model.attendeeVote2["Bennet"] = 14
        model.attendeeVote2["Biden"] = 19
        model.attendeeVote2["Bloomberg"] = 19
        model.attendeeVote2["Booker"] = 12
        model.attendeeVote2["Buttigieg"] = 16

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 0)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(delegates["Bloomberg"] == 0)
        XCTAssert(delegates["Booker"] == 0)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(coinToss == "Draw cards for 1 delegate between Biden Bloomberg\n")
    }
    
    func test1delegateTie3() {
        let model = Model()
        
        model.precinctDelegates = 1
        model.totalAttendees = 79
        model.attendeeVote2["Bennet"] = 14
        model.attendeeVote2["Biden"] = 19
        model.attendeeVote2["Bloomberg"] = 19
        model.attendeeVote2["Booker"] = 19
        model.attendeeVote2["Buttigieg"] = 16

        let (delegates, coinToss) = model.calculateDelegates()
        XCTAssert(delegates["Bennet"] == 0)
        XCTAssert(delegates["Biden"] == 0)
        XCTAssert(delegates["Bloomberg"] == 0)
        XCTAssert(delegates["Booker"] == 0)
        XCTAssert(delegates["Buttigieg"] == 0)
        XCTAssert(coinToss == "Draw cards for 1 delegate between Biden Bloomberg Booker\n")
    }


}
