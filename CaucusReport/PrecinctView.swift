//
//  PrecinctView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/9/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct PrecinctView: View {
    @EnvironmentObject var model: Model
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("County").font(.headline).layoutPriority(1)
                Picker(selection: $model.county, label: Text("")) {
                    ForEach(Model.nevadaCounties, id: \.self) { county in
                        Text(county)
                    }
                }.labelsHidden()
            }
            HStack {
                Text("Precinct:")
                TextField("Precinct", text: $model.precinct)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Stepper(onIncrement: {
                self.model.precinctDelegates += 1
            }, onDecrement: {
                self.model.precinctDelegates -= 1
                if self.model.precinctDelegates == 1 {
                    self.alertTitle = "Notice"
                    self.alertMessage = "Precincts with 1 delegate only have 1 alignment, and immediately award the delegate to the candidate with the most votes"
                    self.showingAlert = true
                }
            }) {
                Text("Delegates: \(self.model.precinctDelegates)")
            }
            /*Stepper(value: self.$model.precinctDelegates, in: 1...1000) {
             Text("Delegates: \(self.model.precinctDelegates)")
             }*/
            Spacer()
            VStack {
                Text("Early Voters \(model.totalEarlyVoters)")
                VoteModifyView(candidate: "", electionPhase: .totalEarlyVote)
                Text("Attendee Voters \(model.totalAttendees)")
                VoteModifyView(candidate: "",electionPhase: .totalAttendees)
            }
            Spacer()
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        }
        .font(.headline).padding()
        .navigationBarTitle(Text("Precinct"), displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                if self.model.precinctDelegates == 1 {
                    NavigationLink(destination: EarlyVoter2View()) {
                        HStack {
                            Text("Early Vote2")
                            Image(systemName: "chevron.right")
                        }
                    }
                } else {
                    NavigationLink(destination: EarlyVoter1View()) {
                        HStack {
                            Text("Early Vote1")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        )
        /*.navigationBarItems(trailing:
            NavigationLink(destination: (self.model.precinctDelegates != 1 ? EarlyVoter1View() : EarlyVoter2View())) {
                HStack {
                    Text("Early Vote1 ")
                    Image(systemName: "chevron.right")
                }
        })*/
        /*self.model.precinctDelegates != 1 ? .navigationBarItems(trailing:
             NavigationLink(destination: EarlyVoter1View()) {
                    HStack {
                        Text("Early Vote1 ")
                        Image(systemName: "chevron.right")
                    }
            }) : .navigationBarItems(trailing: NavigationLink(destination: EarlyVoter2View()) {
                    HStack {
                        Text("Early Vote2 ")
                        Image(systemName: "chevron.right")
                    }
                }
            )*/
    }// body
}// struct

struct PrecinctView_Previews: PreviewProvider {
    static var previews: some View {
        PrecinctView()
    }
}
