//
//  ContentView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/8/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var realMode = false
    @State var caucus: Caucuses = .nevadaDemocrat
    @State var county: String = ""
    @State var precinct: String = ""
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("This app lets you enter data from a caucus, calculate delegates, and unofficially report them via your Twitter account.")
                    Text("You must have the Twitter app installed and logged in to generate a report from this device.")
                    Text("We recommend adding a picture of the caucus venue, preferably with location-services enabled, to increase confidence in the report.")
                    Text("The current version of this app uses Nevada Democratic caucus rules for all calculations.")
                }
                    Spacer()
                    Toggle(isOn: $realMode) {
                        (realMode ? Text("Real election mode") : Text("Test mode"))
                    }
                    Spacer()
                Text("County:")
                TextField("County", text: $county)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Precinct:")
                TextField("Precinct", text: $precinct)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker(selection: $caucus, label: Text("")) {
                    ForEach(Caucuses.allCases) { caucusName in
                        Text(caucusName.rawValue).tag(caucusName)
                    }
                }.foregroundColor(Color.blue)
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                    .labelsHidden()
                
                Text("caucus type \(caucus.rawValue)")
            }.padding()
                .navigationBarTitle(Text("Caucus Report"))
                .navigationBarItems(trailing:
                    NavigationLink(destination: EarlyVoterView()) { Text("Early Voters") })
                    //Button("Early Voters", action: { EarlyVoterView() }))
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
