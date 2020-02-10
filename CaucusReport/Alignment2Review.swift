//
//  Alignment2Review.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct Alignment2Review: View {
    @EnvironmentObject var model: Model
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Total Align1 Votes=\(model.early1GrandTotal)+\(model.attendee1GrandTotal)=\(model.align1GrandTotal)")
                Text("Total Align2 Votes=\(model.early2GrandTotal)+\(model.attendee2GrandTotal)=\(model.align2GrandTotal)")
                Text("Delegates \(model.precinctDelegates)")
                Text("Viability percentage \(model.viabilityPercentage)")
                Text("Votes required for viability \(model.viability)")
                Text("Alignment 2 Votes").font(.headline)
            }
            List(model.viableCandidates, id: \.self) { candidate in
                HStack {
                    Text("\(candidate) \(self.model.earlyVote2[candidate]!)+\(self.model.attendeeVote2[candidate]!)=\(self.model.align2Total(candidate: candidate))")
                    Spacer()
                    Text("\(self.model.delegateFactor(candidate: candidate))")
                }
            }
            Text(model.calculateDelegates())
            Button(action: { self.tweet() }) {
                Text("Tweet alignment 2 results")
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        }.onAppear {
            self.model.saveData()
            if self.model.align2GrandTotal == 0 {
                self.alertTitle = "No votes entered"
                self.alertMessage = "If you don't enter any votes, it looks like a 12-way tie!"
                self.showingAlert = true
            }
        }
        .navigationBarTitle("Align 2 Review", displayMode: .inline)
        /*.navigationBarItems(trailing: NavigationLink(destination: EarlyVoter2View()) {
            Text("Align 2 Early Vote")
        })*/
    }
    func tweet() {
        if let align2Tweet = model.align2Tweet, let url = URL(string:"twitter://post?message=\(align2Tweet)"), UIApplication.shared.canOpenURL(url) {
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
/*struct Alignment1Review_Previews: PreviewProvider {
    static var previews: some View {
        Alignment1Review()
    }
}*/
