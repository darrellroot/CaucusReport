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
                    Text(candidate)
                    Spacer()
                    Button(action: {
                        self.model.earlyVote1[candidate] = self.model.earlyVote1[candidate]! - 1
                    }) {
                        Image(systemName: "minus")
                    }
                    Spacer()
                    Button(action: {
                        self.model.earlyVote1[candidate] = self.model.earlyVote1[candidate]! + 1
                    }) {
                        Image(systemName: "plus")
                    }
                    Spacer()
                    Text("\(self.model.earlyVote1[candidate]!)")
                }
            }
        }.navigationBarTitle("Early Vote Total")
    }
}

struct EarlyVoterView_Previews: PreviewProvider {
    static var previews: some View {
        EarlyVoterView()
    }
}
