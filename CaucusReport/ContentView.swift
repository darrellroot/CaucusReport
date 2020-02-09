//
//  ContentView.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/8/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("This app lets you enter data from a caucus, calculate delegates, and unofficially report them via your Twitter account.")
                    Text("You must have the Twitter app installed and logged in to generate a report from this device.")
                    Text("We recommend adding a picture of the caucus venue, preferably with location-services enabled, to your tweet report.  This will increase confidence in the report.")
                    Text("This version of the app uses Nevada Democratic caucus rules for all calculations.")
                }
                Spacer()
                Toggle(isOn: $model.realMode) {
                    (model.realMode ? Text("Real election mode") : Text("Test mode"))
                }
            }.padding()
            .navigationBarTitle(Text("Caucus Report"))
            .navigationBarItems(trailing:
                NavigationLink(destination: PrecinctView()) { Text("Precinct") })
        } // navigation view
    }// body
}

/*struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }*/
