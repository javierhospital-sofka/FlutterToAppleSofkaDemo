//
//  ContentView.swift
//  AppleWatchApp WatchKit Extension
//
//  Created by Javier Melo on 30/06/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    var body: some View {
        VStack {
          Image("logo")
                .resizable()
                .frame(height: 60)
                 Text("Contador: \(viewModel.counter)")
                     .padding()
                 Button(action: {
                     viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["counter": viewModel.counter + 1])
                 }) {
                     Text("Añadir")
                 }
             }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
