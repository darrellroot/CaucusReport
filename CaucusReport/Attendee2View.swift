//
//  Attendee2View.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct Attendee2View: View {
    @EnvironmentObject var model: Model

        var body: some View {
            VStack {
                Text("Do not include early voting if they were entered on the early vote screen")
                List(model.candidates, id: \.self) { candidate in
                    HStack {
                        NavigationLink(destination: AttendeeVote2Detail(candidate: candidate)) {
                            Text(candidate)
                            Spacer()
                            Text("\(self.model.attendeeVote2[candidate]!)")
                        }
                    }
                }
            }.navigationBarTitle("Attendee Align 2 Votes", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: Alignment2Review()) {
                    HStack {
                        Text("Align 2 Review")
                        Image(systemName: "chevron.right")
                    } })

        }
    }
/*struct InPerson1View_Previews: PreviewProvider {
    static var previews: some View {
        Attendee1View()
    }
}*/
