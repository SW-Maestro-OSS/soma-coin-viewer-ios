//
//  AlertContents.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

public enum AlertContents: Sendable {
    case title(Title)
    case message(Message)
    case actionTitle(ActionTitle)
    
    var keyPart: String {
        switch self {
        case .title(let title):
            title.keyPart
        case .message(let message):
            message.keyPart
        case .actionTitle(let actionTitle):
            actionTitle.keyPart
        }
    }
    
    public enum Title: String, Sendable, CaseIterable {
        case webSocketError
        case internetConnectionError
        case systemError
        case exchangeRateError
        
        var keyPart: String {
            "title_\(self.rawValue)"
        }
    }
    
    public enum Message: String, Sendable, CaseIterable {
        case streamSubFailure
        case streamUnsubFailure
        case unintendedDisconnection
        case webSocketServerIsUnstable
        case internetConnectionFailed
        case failedToGetExchangerate
        case unknownError
        
        var keyPart: String {
            "message_\(self.rawValue)"
        }
    }
    
    public enum ActionTitle: String, Sendable, CaseIterable {
        case cancel
        case retry
        case ignore
        
        var keyPart: String {
            "actionTitle_\(self.rawValue)"
        }
    }
}
