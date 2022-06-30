//
//  WatchViewModel.swift
//  AppleWatchApp WatchKit Extension
//
//  Created by Javier Melo on 30/06/22.
//

import Foundation
import WatchConnectivity

class WatchViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var counter = 0
    
    // Añadir más casos de recepción
    enum WatchReceiveMethod: String {
        case sendCounterToNative
    }
    
    // Añadir más casos de envío
    enum WatchSendMethod: String {
        case sendCounterToFlutter
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    // Este método es el que se activa a través del Boton en el ContentView, recibe el valor aumentado del contador para posteriormente enviarlo a Flutter
    func sendDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
        sendMessage(for: method.rawValue, data: data)
    }
    
}

extension WatchViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // Recibe el mensaje del AppDelegate.swift
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            
            switch enumMethod {
            case .sendCounterToNative:
                
                self.counter = (message["data"] as? Int) ?? 0
            }
        }
    }
    
    // Envía el mensaje desde el Apple Watch a Flutter
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable else {
            return
        }
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}

