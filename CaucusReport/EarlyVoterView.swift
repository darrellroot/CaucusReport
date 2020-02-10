//
//  EarlyVoterView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/8/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct EarlyVoterView: View {
    @EnvironmentObject var model: Model

    var body: some View {
        VStack {
            List(model.candidates, id: \.self) { candidate in
                //ForEach(model.candidates, id: \.self) { candidate in
                HStack {
                    NavigationLink(destination: EarlyVote1Detail(candidate: candidate)) {
                        Text(candidate)
                        Spacer()
                        Text("\(self.model.earlyVote1[candidate]!)")
                    }
                }
            }
        }.navigationBarTitle("Early Vote Align 1")
        .navigationBarItems(trailing:
            NavigationLink(destination: Attendee1View()) { Text("Attendee Align 1") })

    }
}

struct EarlyVoterView_Previews: PreviewProvider {
    static var previews: some View {
        EarlyVoterView()
    }
}
