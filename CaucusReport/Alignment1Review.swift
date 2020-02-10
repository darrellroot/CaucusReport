//
//  Alignment1Review.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct Alignment1Review: View {
    @EnvironmentObject var model: Model

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Uncommitted votes do not count for viability")
                Text("Total Early Votes \(model.early1GrandTotal)")
                Text("Total Attendee Votes \(model.attendee1GrandTotal)")
                Text("Alignment 1 Votes \(model.align1GrandTotal)")
                Text("Delegates \(model.delegates)")
                Text("Viability percentage \(model.viabilityPercentage)")
                Text("Votes required for viability \(model.viability)")
            }
            List(model.candidates, id: \.self) { candidate in
                Text("\(candidate) \(self.model.earlyVote1[candidate]!)+\(self.model.attendeeVote1[candidate]!)=\(self.model.align1Total(candidate: candidate))").foregroundColor(self.model.viable(candidate: candidate) ? Color.green : Color.red)
            }
        }.navigationBarTitle("Align 1 Review", displayMode: .inline)
    }
}

struct Alignment1Review_Previews: PreviewProvider {
    static var previews: some View {
        Alignment1Review()
    }
}
