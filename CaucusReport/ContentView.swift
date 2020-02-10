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
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("This app lets you enter data from a caucus, calculate delegates, and unofficially report them via Twitter.")
                    Text("You must have the Twitter app installed to generate a report from this device.")
                    Text("Save a paper copy of all data.")
                    Text("This app uses Nevada Democratic caucus rules for all calculations.")
                }
                Spacer()
                Toggle(isOn: $model.realMode) {
                    (model.realMode ? Text("Real election mode") : Text("Test mode"))
                }
                Spacer()
                Button(action: {
                    self.model.reset()
                    self.alertTitle = "Data Reset"
                    self.alertMessage = ""
                    self.showingAlert = true
                }) {
                    Text("RESET ALL DATA AND START OVER").font(.headline).multilineTextAlignment(.center)
                }.padding(EdgeInsets(top:12, leading: 20, bottom: 12, trailing: 20))
                    .foregroundColor(Color.black)
                    .background(Color.red).cornerRadius(.infinity)
            }.padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                }

            .navigationBarTitle(Text("Caucus Report"))
            .navigationBarItems(trailing:
                NavigationLink(destination: PrecinctView()) { HStack {
                    Text("Precinct")
                    Image(systemName: "chevron.right")
                    } })
        } // navigation view
    }// body
}

/*struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }*/
