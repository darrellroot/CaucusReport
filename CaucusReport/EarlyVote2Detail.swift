//
//  EarlyVote2Detail.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
// 

import SwiftUI

struct EarlyVote2Detail: View {
    let candidate: String
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text("Votes for candidate \(candidate) in early voting, as calculated for second alignment after viability determination")
            Spacer()
            Text("Votes: \(self.model.earlyVote2[self.candidate]!)").foregroundColor(self.model.viable2(candidate: candidate) ? Color.blue : Color.red)
            Spacer()
            VoteModifyView(candidate: candidate, electionPhase: .earlyVote2)
        }.padding()
            .font(.title)
            .navigationBarTitle("\(candidate) Early Vote 2", displayMode: .inline)
    }
}

/*struct EarlyVoteDetail_Previews: PreviewProvider {
 static var previews: some View {
 EarlyVoteDetail()
 }
 }*/


