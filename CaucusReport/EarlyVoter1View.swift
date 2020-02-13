//
//  EarlyVoterView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/8/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct EarlyVoter1View: View {
    @EnvironmentObject var model: Model

    var body: some View {
        VStack {
            Text("Total precinct voters \(model.totalRegistrations)").padding(.top)
            Text("Precinct delegates \(model.precinctDelegates)")
            Text("Viability percentage \(model.viabilityPercentage)")
            Text("Votes required for viability \(model.viability)")
            List(model.candidates, id: \.self) { candidate in
                HStack {
                    NavigationLink(destination: EarlyVote1Detail(candidate: candidate)) {
                        Text(candidate)
                        Spacer()
                        Text("\(self.model.earlyVote1[candidate]!)")
                    }.foregroundColor(self.model.viable1(candidate: candidate) ? Color.blue : Color.red)
                }
            }
        }.onAppear { self.model.saveData() }
        .navigationBarTitle("Early Vote 1")
        .navigationBarItems(trailing:
            NavigationLink(destination: Attendee1View()) { HStack {
                    Text("Attendee 1")
                    Image(systemName: "chevron.right")
                } })

    }
}

struct EarlyVoter1View_Previews: PreviewProvider {
    static var previews: some View {
        EarlyVoter1View()
    }
}
