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
                Text("Early votes for alignment 2, make sure to reassign based on viability").padding(.top)
                List(model.candidates, id: \.self) { candidate in
                    HStack {
                        NavigationLink(destination: EarlyVote2Detail(candidate: candidate)) {
                            Text(candidate)
                            Spacer()
                            Text("\(self.model.earlyVote2[candidate]!)")
                        }.foregroundColor(self.model.viable2(candidate: candidate) ? Color.blue : Color.red)
                    }
                }
            }.onAppear { self.model.saveData() }
            .navigationBarTitle("Early Vote 2")
            .navigationBarItems(trailing:
                NavigationLink(destination: Attendee2View()) {
                    HStack {
                        Text("Attendee 2")
                        Image(systemName: "chevron.right")
                    }
                    
            })

    }
}

struct EarlyVoter2View_Previews: PreviewProvider {
    static var previews: some View {
        EarlyVoter2View()
    }
}
