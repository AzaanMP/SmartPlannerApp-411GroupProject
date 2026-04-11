//
//  MessageComposeView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI
import MessageUI


// We use UIViewControllerRepresentable to "borrow" a screen from standard iOS and use it inside SwiftUI
struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String
    
    @Environment(\.dismiss) var dismiss


    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.body = body
        controller.recipients = recipients
        controller.messageComposeDelegate = context.coordinator
        return controller
    }


    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // Nothing needs to update while the screen is open
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    // The Coordinator acts as a listener to know when you hit "Send" or "Cancel"
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView
        
        init(_ parent: MessageComposeView) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Close the text screen when done
            parent.dismiss()
        }
    }
}
