//
//  InPerson1View.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct Attendee1View: View {
    @EnvironmentObject var model: Model

        var body: some View {
            VStack {
                Text("Do not include early voting if they were entered on the early vote screen").font(.headline).padding([.top,.leading,.trailing])
                List(model.candidates, id: \.self) { candidate in
                    HStack {
                        NavigationLink(destination: AttendeeVote1Detail(candidate: candidate)) {
                            Text(candidate)
                            Spacer()
                            Text("\(self.model.attendeeVote1[candidate]!)")
                        }.foregroundColor(self.model.viable1(candidate: candidate) ? Color.blue : Color.red)
                    }
                }
            }.navigationBarTitle("Attendee Vote 1", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: Alignment1Review()) { HStack {
                        Text("Review 1")
                        Image(systemName: "chevron.right")
                    } })

        }
    }
struct InPerson1View_Previews: PreviewProvider {
    static var previews: some View {
        Attendee1View()
    }
}
