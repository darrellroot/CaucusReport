//
//  VoteModifyView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

//It is ok to call this with an empty candidate for the
//totalEarlyVoters and totalAttendee phases
struct VoteModifyView: View {
    let candidate: String
    let electionPhase: ElectionPhase
    @EnvironmentObject var model: Model

    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    self.modifyTotal(-1)
                }) {
                    HStack {
                        Image(systemName: "minus")
                        Text("1")
                    }
                }
                Spacer()
                Button(action: {
                    self.modifyTotal(+1)
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("1")
                    }
                }
            }//hstack
            HStack {
                Button(action: {
                    self.modifyTotal(-10)
                }) {
                    HStack {
                        Image(systemName: "minus")
                        Text("10")
                    }
                }
                Spacer()
                Button(action: {
                    self.modifyTotal(+10)
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("10")
                    }
                }
            }//hstack

            HStack {
                Button(action: {
                    self.modifyTotal(-100)
                }) {
                    HStack {
                        Image(systemName: "minus")
                        Text("100")
                    }
                }
                Spacer()
                Button(action: {
                    self.modifyTotal(+100)
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("100")
                    }
                }
            }//hstack

        }//vstack
    }//view
    
    func modifyTotal(_ amount: Int) {
        switch electionPhase {
        case .totalEarlyVote:
            model.totalEarlyVoters += amount
        case .totalAttendees:
            model.totalAttendees += amount
        case .earlyVote1:
            model.earlyVote1[candidate] = model.earlyVote1[candidate]! + amount
        case .attendeeVote1:
            model.attendeeVote1[candidate] = model.attendeeVote1[candidate]! + amount
        case .earlyVote2:
            model.earlyVote2[candidate] = model.earlyVote2[candidate]! + amount
        case .attendeeVote2:
            model.attendeeVote2[candidate] = model.attendeeVote2[candidate]! + amount
        }
    }
}

/*struct VoteModifyView_Previews: PreviewProvider {
    static var previews: some View {
        VoteModifyView()
    }
}*/
