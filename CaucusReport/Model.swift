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
    @Published var delegates: Int = 0 {
        didSet {
            if delegates < 0 {
                delegates = 0
            }
        }
    }
    
    @Published var candidates = Model.originalCandidates
    
    @Published var earlyVote1: [String: Int] = [:]
    @Published var align1PresentVote: [String: Int] = [:]
    
    init() {
        for candidate in candidates {
            earlyVote1[candidate] = 0
            align1PresentVote[candidate] = 0
        }
    }
    
    func addCandidate(name: String) {
        if candidates.contains(name) {
            debugPrint("already added")
        } else {
            candidates.append(name)
            earlyVote1[name] = 0
            align1PresentVote[name] = 0
        }
    }
    
}
