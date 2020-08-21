//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Bastien Ravalet on 2020-08-20.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.title)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            Text("Bob")
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
