//
//  EarlyVoteDetail.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct EarlyVote1Detail: View {
    let candidate: String
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text("Votes for candidate \(candidate) in early voting, as calculated before first alignment")
            Spacer()
            Text("Votes: \(self.model.earlyVote1[self.candidate]!)")
            Spacer()
            VoteModifyView(candidate: candidate, electionPhase: .earlyVote1)
        }.padding()
            .font(.title)
            .navigationBarTitle("\(candidate) Early Votes", displayMode: .inline)
    }
}

/*struct EarlyVoteDetail_Previews: PreviewProvider {
 static var previews: some View {
 EarlyVoteDetail()
 }
 }*/


