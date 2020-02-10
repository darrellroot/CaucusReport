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
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Uncommitted votes do not count for viability")
                Text("Total Early Votes \(model.early1GrandTotal)")
                Text("Total Attendee Votes \(model.attendee1GrandTotal)")
                Text("Alignment 1 Votes \(model.align1GrandTotal)")
                Text("Delegates \(model.precinctDelegates)")
                Text("Viability percentage \(model.viabilityPercentage)")
                Text("Votes required for viability \(model.viability)")
            }
            List(model.candidates, id: \.self) { candidate in
                Text("\(candidate) \(self.model.earlyVote1[candidate]!)+\(self.model.attendeeVote1[candidate]!)=\(self.model.align1Total(candidate: candidate))").foregroundColor(self.model.viable(candidate: candidate) ? Color.green : Color.red)
            }
            Button(action: { self.tweet() }) {
                Text("Tweet alignment 1 results")
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationBarTitle("Align 1 Review", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: EarlyVoter2View()) {
            Text("Align 2 Early Vote")
        })
    }
    func tweet() {
        if let align1Tweet = model.align1Tweet, let url = URL(string:"twitter://post?message=\(align1Tweet)"), UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url, options: [:],
                  completionHandler: {
                     (success) in
                    if success == false {
                        self.twitterAlert()
                    }
                     debugPrint("Open \(url): \(success)")
                   })
        } else {
            self.twitterAlert()
        }
    }
    func twitterAlert() {
        self.alertTitle = "Unable to open Twitter application"
        self.alertMessage = "Make sure Twitter is installed"
        self.showingAlert = true
    }
}
struct Alignment1Review_Previews: PreviewProvider {
    static var previews: some View {
        Alignment1Review()
    }
}
