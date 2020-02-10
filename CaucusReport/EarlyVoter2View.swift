//
//  EarlyVoter2View.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct EarlyVoter2View: View {
    @EnvironmentObject var model: Model

    var body: some View {
            VStack {
                Text("Early votes for alignment 2, limited to candidates with viability")
                List(model.viableCandidates, id: \.self) { candidate in
                    HStack {
                        NavigationLink(destination: EarlyVote2Detail(candidate: candidate)) {
                            Text(candidate)
                            Spacer()
                            Text("\(self.model.earlyVote2[candidate]!)")
                        }
                    }
                }
            }.navigationBarTitle("Early Vote Align 2")
            .navigationBarItems(trailing:
                NavigationLink(destination: Attendee2View()) { Text("In Person Align 2") })

    }
}

struct EarlyVoter2View_Previews: PreviewProvider {
    static var previews: some View {
        EarlyVoter2View()
    }
}
