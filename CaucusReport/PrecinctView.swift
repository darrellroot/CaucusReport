//
//  PrecinctView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct PrecinctView: View {
    @EnvironmentObject var model: Model
    
    
    var body: some View {
        VStack {
            HStack {
                Text("County:")
                TextField("County", text: $model.county)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("Precinct:")
                TextField("Precinct", text: $model.precinct)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack(spacing: 25) {
                Text("Delegates:")
                Spacer()
                Button(action: {
                    self.model.precinctDelegates = self.model.precinctDelegates - 1
                }) {
                    Image(systemName: "minus")
                }
                Button(action: {
                    self.model.precinctDelegates = self.model.precinctDelegates + 1
                }) {
                    Image(systemName: "plus")
                }
                Text("\(model.precinctDelegates)")
            }.font(.title)
            Spacer()
            VStack {
                Text("Early Voters \(model.totalEarlyVoters)")
                VoteModifyView(candidate: "", electionPhase: .totalEarlyVote)
                Text("Attendee Voters \(model.totalAttendees)")
                VoteModifyView(candidate: "",electionPhase: .totalAttendees)
            }
            Spacer()
        }.font(.headline).padding()
            .navigationBarTitle(Text("Precinct"), displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: EarlyVoter1View()) { HStack {
                        Text("Early Vote1 ")
                        Image(systemName: "chevron.right")
                    } })
    }
}

struct PrecinctView_Previews: PreviewProvider {
    static var previews: some View {
        PrecinctView()
    }
}
