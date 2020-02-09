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
    
    var body: some View {
        VStack {
            Text("County:")
            TextField("County", text: $model.county)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Precinct:")
            TextField("Precinct", text: $model.precinct)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            HStack {
                Text("Delegates:")
                Spacer()
                Button(action: {
                    self.model.delegates = self.model.delegates - 1
                }) {
                    Image(systemName: "minus")
                }
                Spacer()
                Button(action: {
                    self.model.delegates = self.model.delegates + 1
                }) {
                    Image(systemName: "plus")
                }
                Spacer()
                Text("\(model.delegates)")
            }.font(.title)
            Spacer()
            
        }.padding()
            .navigationBarTitle(Text("Precinct"))
            .navigationBarItems(trailing:
                NavigationLink(destination: EarlyVoterView()) { Text("Early Voters") })
    }
}

struct PrecinctView_Previews: PreviewProvider {
    static var previews: some View {
        PrecinctView()
    }
}
