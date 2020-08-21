//
//  HomeView.swift
//  SwiftUITest
//
//  Created by Bastien Ravalet on 2020-08-20.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack {
            CameraViewController.newInstance().edgesIgnoringSafeArea(.top)
            CameraViewController.newInstance().edgesIgnoringSafeArea(.top)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
