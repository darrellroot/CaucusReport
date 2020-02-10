//
//  Model.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import Foundation

class Model: ObservableObject {
    static let originalCandidates = ["Bennet","Biden","Bloomberg","Buttigieg","Gabbard","Kloubuchar","Patrick","Sanders","Steyer","Warren","Yang", "Uncommitted"]
    
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
            if viable(candidate: candidate) {
                result.append(candidate)
            }
        }
        return result
    }

    var attendee1GrandTotal: Int {
        var grandTotal = 0
        for candidate in self.candidates {
            if candidate != "Uncommitted" {
                grandTotal = grandTotal + (attendeeVote1[candidate] ?? 0)
            }
        }
        return grandTotal
    }
    
    var attendee2GrandTotal: Int {
        var grandTotal = 0
        for candidate in self.candidates {
            if candidate != "Uncommitted" {
                grandTotal = grandTotal + (attendeeVote2[candidate] ?? 0)
            }
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
    
    func viable(candidate: String) -> Bool {
        if align1Total(candidate: candidate) >= viability {
            return true
        } else {
            return false
        }
    }
    
    var viability: Int {
        let doubleViability = (Double(align1GrandTotal) * viabilityPercentage).rounded(.up)
        return Int(doubleViability)
    }

    init() {
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
            if viable(candidate: candidate) {
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
        for candidate in viableCandidates {
            output += "\(candidate) \(align2Total(candidate: candidate))\n"
        }
        output += calculateDelegates()
        output += "#CaucusReportApp\n"

        debugPrint("tweet characters \(output.count)")
        return output.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    func delegateFactor(candidate: String) -> Double {
        guard align1GrandTotal > 0 else { return 0.0 }
        return (Double(align2Total(candidate: candidate)) * Double(precinctDelegates) / Double(align1GrandTotal)).rounded(toPlaces: 4)
    }
    
    
    func calculateDelegates() -> String {
        
        var usedDelegates = 0
        var candidateDelegates: [String: Int] = [:]
        var coinToss: String = "No coin tosses\n"

        func remainingFactor(candidate: String) -> Double {
            return delegateFactor(candidate: candidate) - Double(candidateDelegates[candidate]!)
        }

        func findHighestRemainingFactor() -> [String] {
            var largestFactor = 0.0
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
            }
        }//while
        var result = ""
        for candidate in viableCandidates {
            result += "\(candidate) \(candidateDelegates[candidate]!) delegates\n"
        }
        result += coinToss
        return result
    }
}
