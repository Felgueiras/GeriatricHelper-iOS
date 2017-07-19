//
//  HelpTopics.swift
//  GeriatricHelper
//
//  Created by felgueiras on 18/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation
import SwiftMessages

class SwiftMessagesHelper{
    
    static let help_topic_cga = "Sobre a Avaliação Geriátrica Global"
    static let help_topic_functionalities = "Funcionalidades"
    static let help_topic_personal_area = "Área Pessoal"
    static let help_topic_patients = "Pacientes"
    static let help_topic_prescriptions = "Prescrições"
    static let help_topic_sessions = "Sessões"
    static let help_topic_cga_guide = "Guia da AGG"
    
    static let helpTopics:[String] = [
        help_topic_cga,help_topic_functionalities,help_topic_personal_area,
        help_topic_patients,help_topic_prescriptions,help_topic_sessions,
        help_topic_cga_guide
    ]
    
    
    static func showMessage(type: Theme, text: String)
    {
        // display status message
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .CardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(type)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
//        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        view.configureContent(title: "Warning",
                              body: text)
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        
        // get default config
        let config = defaultConfig()
        
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
    
    }
    
    
    static func defaultConfig() -> SwiftMessages.Config
    {
        // configure the view
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        config.presentationStyle = .bottom
        
        // Display in a window at the specified window level: UIWindowLevelStatusBar
        // displays over the status bar while UIWindowLevelNormal displays under.
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        // Disable the default auto-hiding behavior.
        //        config.duration = .forever
        
        // Dim the background like a popover view. Hide when the background is tapped.
        //        config.dimMode = .gray(interactive: true)
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { }
        }
        
        return config
    }
    
    
    static func showWarningMessage()
    {
        // display status message
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .CardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.warning)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        view.configureContent(title: "Warning",
                              body: "Consider yourself warned.",
                              iconText: iconText)
        view.button?.isHidden = true
        
        // get default config
        let config = defaultConfig()
        
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
        
    }
}
