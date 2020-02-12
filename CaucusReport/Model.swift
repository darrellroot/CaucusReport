//
//  Model.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import Foundation

class Model: ObservableObject, Codable {
    static let originalCandidates = ["Bennet","Biden","Bloomberg","Booker","Buttigieg","Delaney","Gabbard","Kloubuchar","Patrick","Sanders","Steyer","Warren","Williamson","Yang","Uncommitted","Write-Ins"]
    
    @Published var realMode = false
    @Published var county: String = ""
    @Published var precinct: String = ""
    @Published var precinctDelegates: Int = 2 {
        didSet {
            if precinctDelegates < 2 {
                precinctDelegates = 2
            }
        }
    }
    @Published var totalAttendees = 0 {
        didSet {
            if totalAttendees < 0 {
                totalAttendees = 0
            }
        }
    }
    @Published var totalEarlyVoters = 0 {
        didSet {
            if totalEarlyVoters < 0 {
                totalEarlyVoters = 0
            }
        }
    }
    
    @Published var candidates = Model.originalCandidates
    
    @Published var earlyVote1: [String: Int] = [:] {
        didSet {
            for key in earlyVote1.keys {
                if earlyVote1[key]! < 0 {
                    earlyVote1[key] = 0
                }
            }
        }
    }
    @Published var attendeeVote1: [String: Int] = [:] {
        didSet {
            for key in attendeeVote1.keys {
                if attendeeVote1[key]! < 0 {
                    attendeeVote1[key] = 0
                }
            }
        }
    }
    @Published var earlyVote2: [String: Int] = [:] {
        didSet {
            for key in earlyVote2.keys {
                if earlyVote2[key]! < 0 {
                    earlyVote2[key] = 0
                }
            }
        }
    }
    @Published var attendeeVote2: [String: Int] = [:] {
        didSet {
            for key in attendeeVote2.keys {
                if attendeeVote2[key]! < 0 {
                    attendeeVote2[key] = 0
                }
            }
        }
    }
    

    init() {
        for candidate in candidates {
            earlyVote1[candidate] = 0
            attendeeVote1[candidate] = 0
            earlyVote2[candidate] = 0
            attendeeVote2[candidate] = 0
        }
    }
    
    enum CodingKeys: CodingKey {
        case realMode
        case county
        case precinct
        case precinctDelegates
        case candidates
        case totalAttendees
        case totalEarlyVoters
        case earlyVote1
        case earlyVote2
        case attendeeVote1
        case attendeeVote2
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        realMode = try container.decode(Bool.self, forKey: .realMode)
        county = try container.decode(String.self, forKey: .county)
        precinct = try container.decode(String.self, forKey: .precinct)
        precinctDelegates = try container.decode(Int.self, forKey: .precinctDelegates)
        candidates = try container.decode([String].self, forKey: .candidates)
        totalAttendees = try container.decode(Int.self, forKey: .totalAttendees)
        totalEarlyVoters = try container.decode(Int.self, forKey: .totalEarlyVoters)
        earlyVote1 = try container.decode([String: Int].self, forKey: .earlyVote1)
        earlyVote2 = try container.decode([String: Int].self, forKey: .earlyVote2)
        attendeeVote1 = try container.decode([String: Int].self, forKey: .attendeeVote1)
        attendeeVote2 = try container.decode([String: Int].self, forKey: .attendeeVote2)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(realMode, forKey: .realMode)
        try container.encode(county, forKey: .county)
        try container.encode(precinct, forKey: .precinct)
        try container.encode(precinctDelegates, forKey: .precinctDelegates)
        try container.encode(totalAttendees, forKey: .totalAttendees)
        try container.encode(totalEarlyVoters, forKey: .totalEarlyVoters)
        try container.encode(candidates, forKey: .candidates)
        try container.encode(earlyVote1, forKey: .earlyVote1)
        try container.encode(earlyVote2, forKey: .earlyVote2)
        try container.encode(attendeeVote1, forKey: .attendeeVote1)
        try container.encode(attendeeVote2, forKey: .attendeeVote2)
        
    }
}

extension Model { // everything below here are calculated properties
    
    func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedModel")
            debugPrint("saved model")
        } else {
            debugPrint("failed to save model")
        }
    }

    var totalRegistrations: Int {
        return totalAttendees + totalEarlyVoters
    }
    
    var viability: Int {
        let doubleViability = (Double(totalAttendees + totalEarlyVoters) * viabilityPercentage).rounded(.up)
        return Int(doubleViability)
    }

    func align1Total(candidate: String) -> Int {
        return (earlyVote1[candidate] ?? 0) + (attendeeVote1[candidate] ?? 0)
    }
    
    func align2Total(candidate: String) -> Int {
        return (earlyVote2[candidate] ?? 0) + (attendeeVote2[candidate] ?? 0)
    }
    
    var early1GrandTotal: Int {
        var grandTotal = 0
        for candidate in self.candidates {
            if candidate != "Uncommitted" {
                grandTotal = grandTotal + (earlyVote1[candidate] ?? 0)
            }
        }
        return grandTotal
    }
    
    var early2GrandTotal: Int {
        var grandTotal = 0
        for candidate in self.candidates {
            if candidate != "Uncommitted" {
                grandTotal = grandTotal + (earlyVote2[candidate] ?? 0)
            }
        }
        return grandTotal
    }
    
    
    var viableCandidates: [String] {
        var result: [String] = []
        for candidate in candidates {
            if viable2(candidate: candidate) {
                result.append(candidate)
            }
        }
        return result
    }
    
    var attendee1GrandTotal: Int {
        var grandTotal = 0
        for candidate in self.candidates {
            grandTotal = grandTotal + (attendeeVote1[candidate] ?? 0)
        }
        return grandTotal
    }
    
    var attendee2GrandTotal: Int {
        var grandTotal = 0
        for candidate in self.candidates {
            grandTotal = grandTotal + (attendeeVote2[candidate] ?? 0)
        }
        return grandTotal
    }
    
    
    var align1GrandTotal: Int {
        return early1GrandTotal + attendee1GrandTotal
    }
    
    var align2GrandTotal: Int {
        return early2GrandTotal + attendee2GrandTotal
    }
    
    var viabilityPercentage: Double {
        switch self.precinctDelegates {
        case 2:
            return 0.25
        case 3:
            return 0.166667
        case 4...:
            return 0.15
        default:
            debugPrint("should not get here")
            return 0.25
        }
    }
    
    func viable1(candidate: String) -> Bool {
        if align1Total(candidate: candidate) >= viability {
            return true
        } else {
            return false
        }
    }
    func viable2(candidate: String) -> Bool {
        if align2Total(candidate: candidate) >= viability {
            return true
        } else {
            return false
        }
    }
    
    
    func reset() {
        realMode = false
        county = ""
        precinct = ""
        precinctDelegates = 2
        totalAttendees = 0
        totalEarlyVoters = 0
        candidates = Model.originalCandidates
        earlyVote1 = [:]
        attendeeVote1 = [:]
        earlyVote2 = [:]
        attendeeVote2 = [:]
        for candidate in candidates {
            earlyVote1[candidate] = 0
            attendeeVote1[candidate] = 0
            earlyVote2[candidate] = 0
            attendeeVote2[candidate] = 0
        }
        
    }
    
    func addCandidate(name: String) {
        if candidates.contains(name) {
            debugPrint("already added")
        } else {
            candidates.append(name)
            earlyVote1[name] = 0
            attendeeVote1[name] = 0
            earlyVote2[name] = 0
            attendeeVote2[name] = 0
        }
    }
    
    var align1Tweet: String? {
        var output: String = ""
        if self.realMode {
            output += "#NevadaCaucus Align1\n"
        } else {
            output += "#NevadaCaucusTest Align1\n"
        }
        output += "County \(county) precinct \(precinct) Delegates \(precinctDelegates)\n"
        for candidate in candidates {
            if align1Total(candidate: candidate) == 0 {
                continue
            }
            output += "\(candidate) \(align1Total(candidate: candidate))"
            if viable1(candidate: candidate) {
                output += " viable\n"
            } else {
                output += "\n"
            }
        }
        output += "#CaucusReportApp\n"
        debugPrint("tweet characters \(output.count)")
        return output.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var align2Tweet: String? {
        var output: String = ""
        if self.realMode {
            output += "#NevadaCaucus Align2\n"
        } else {
            output += "#NevadaCaucusTest Align2\n"
        }
        output += "County \(county) Precinct \(precinct) Delegates \(precinctDelegates)\n"
        output += "VOTES\n"
        for candidate in viableCandidates {
            output += "\(candidate) \(align2Total(candidate: candidate))\n"
        }
        output += delegateMessage()
        output += "#CaucusReportApp\n"
        
        debugPrint("tweet characters \(output.count)")
        return output.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func delegateFactor(candidate: String) -> Double {
        guard totalRegistrations > 0 else { return 0.0 }
        return (Double(align2Total(candidate: candidate)) * Double(precinctDelegates) / Double(totalRegistrations)).rounded(toPlaces: 4)
    }
    
    func calculateDelegates() -> (delegates: [String:Int], coinToss: String) {
        var usedDelegates = 0
        var candidateDelegates: [String: Int] = [:]
        var coinToss: String = "No coin tosses\n"
        guard viableCandidates.count > 0 else {
            coinToss = "No viable candidates"
            return (delegates: candidateDelegates, coinToss: coinToss)
        }
        func remainingFactor(candidate: String) -> Double {
            return delegateFactor(candidate: candidate) - Double(candidateDelegates[candidate]!)
        }

        func findHighestRemainingFactor() -> [String] {
            var largestFactor =  -1000.0 // initially set to low value
            var highestCandidates: [String] = []
            for candidate in viableCandidates {
                if remainingFactor(candidate: candidate) > largestFactor {
                    largestFactor = remainingFactor(candidate: candidate)
                    highestCandidates = [candidate]
                } else if remainingFactor(candidate: candidate) == largestFactor {
                    highestCandidates.append(candidate)
                }
            }
            return highestCandidates
        }

        // initially set delegates to 0
        for candidate in candidates {
            candidateDelegates[candidate] = 0
        }
        
        // all viable candidates get 1 delegate even if that
        // requires more delegates than assigned to precinct
        for candidate in viableCandidates {
            candidateDelegates[candidate] = candidateDelegates[candidate]! + 1
            usedDelegates = usedDelegates + 1
        }

        // keep assigning delegates to candiates until precinct is
        // out of delegates.  precinct might already be out
        // of delegates if viableCandidates.count >= precinctDelegates
        while usedDelegates < precinctDelegates {
            let nextWinners: [String] = findHighestRemainingFactor()
            if nextWinners.count <= (precinctDelegates - usedDelegates) {
                for winner in nextWinners {
                    candidateDelegates[winner] = candidateDelegates[winner]! + 1
                    usedDelegates = usedDelegates + 1
                }
                // if we have more tied winners this round than
                // remaining delegages, initiate a coin toss
            } else { //nextWinners.count > remaining delegates
                var winnerString = ""
                for winner in nextWinners {
                    winnerString = winnerString + " \(winner)"
                }
                coinToss = "CoinToss for \(precinctDelegates - usedDelegates) delegates between\(winnerString)\n"
                usedDelegates = precinctDelegates
            }
        }//while
        return (delegates: candidateDelegates, coinToss: coinToss)
        
    }
    
    func delegateMessage() -> String {
        var result = "DELEGATES\n"
        let (delegates, coinToss) = calculateDelegates()
        for (candidate,delegateCount) in delegates {
            if delegateCount > 0 {
                result += "\(candidate) \(delegateCount)\n"
            }
        }
        result += coinToss
        return result
    }
    
    var validResult: Bool {
        if align2GrandTotal <= 0 {
            return false
        }
        if totalRegistrations <= 0 {
            return false
        }
        return true
    }
    /*func calculateDelegates() -> String {
        var usedDelegates = 0
        var candidateDelegates: [String: Int] = [:]
        var coinToss: String = "No coin tosses\n"
        
        if viableCandidates.count == 0 {
            return "No viable candidates\n"
        }
        func remainingFactor(candidate: String) -> Double {
            return delegateFactor(candidate: candidate) - Double(candidateDelegates[candidate]!)
        }
        
        func findHighestRemainingFactor() -> [String] {
            var largestFactor =  -1000.0
            var highestCandidates: [String] = []
            for candidate in viableCandidates {
                if remainingFactor(candidate: candidate) > largestFactor {
                    largestFactor = remainingFactor(candidate: candidate)
                    highestCandidates = [candidate]
                } else if remainingFactor(candidate: candidate) == largestFactor {
                    highestCandidates.append(candidate)
                }
            }
            return highestCandidates
        }
        
        for candidate in candidates {
            candidateDelegates[candidate] = 0
        }
        for candidate in viableCandidates {
            candidateDelegates[candidate] = candidateDelegates[candidate]! + 1
            usedDelegates = usedDelegates + 1
        }
        while usedDelegates < precinctDelegates {
            let nextWinners: [String] = findHighestRemainingFactor()
            if nextWinners.count <= (precinctDelegates - usedDelegates) {
                for winner in nextWinners {
                    candidateDelegates[winner] = candidateDelegates[winner]! + 1
                    usedDelegates = usedDelegates + 1
                }
            } else { //nextWinners.count > remaining delegates
                var winnerString = ""
                for winner in nextWinners {
                    winnerString = winnerString + " \(winner)"
                }
                coinToss = "CoinToss for \(precinctDelegates - usedDelegates) delegates between\(winnerString)\n"
                usedDelegates = precinctDelegates
            }
        }//while
        var result = "DELEGATES\n"
        for candidate in viableCandidates {
            result += "\(candidate) \(candidateDelegates[candidate]!)\n"
        }
        result += coinToss
        return result
    }*/
}
