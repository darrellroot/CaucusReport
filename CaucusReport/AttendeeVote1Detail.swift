//
//  InPersonVote1Detail.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct AttendeeVote1Detail: View {
    let candidate: String
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text("Attendee votes for candidate \(candidate) during first alignment.  Do not include early voting if they were entered on early voting screen.")
            Spacer()
            Text("Votes: \(model.attendeeVote1[self.candidate]!)")
            Spacer()
            VoteModifyView(candidate: candidate, electionPhase: .attendeeVote1)
        }.padding()
            .font(.title)
            .navigationBarTitle("\(candidate) Early Votes", displayMode: .inline)
    }
}
/*struct InPersonVote1Detail_Previews: PreviewProvider {
 static var previews: some View {
 InPersonVote1Detail()
 }
 }*/
