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
    @Published var delegates: Int = 2 {
        didSet {
            if delegates < 2 {
                delegates = 2
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

    var align1GrandTotal: Int {
        return early1GrandTotal + attendee1GrandTotal
    }
    
    var viabilityPercentage: Double {
        switch self.delegates {
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
        output += "County \(county) precinct \(precinct) Delegates \(delegates)\n"
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
        output += "County \(county) precinct \(precinct) Delegates \(delegates)\n"
        for candidate in viableCandidates {
            output += "\(candidate) \(align2Total(candidate: candidate))"
        }
        output += "#CaucusReportApp\n"

        debugPrint("tweet characters \(output.count)")
        return output.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    
}
