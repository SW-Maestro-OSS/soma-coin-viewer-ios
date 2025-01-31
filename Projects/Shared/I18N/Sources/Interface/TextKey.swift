//
//  TextKey.swift
//  I18N
//
//  Created by choijunios on 1/31/25.
//

public enum TextKey {
    public enum Alert {
        public enum Title: String, CaseIterable {
            case webSocketError = "alertmodel_title_websocketerror"
            case internetConnectionError = "alertmodel_title_internetconnectionerror"
            case systemError = "alertmodel_title_systemerror"
        }
        public enum Message: String, CaseIterable {
            case streamSubFailure = "alertmodel_message_streamsubfailure"
            case streamUnsubFailure = "alertmodel_message_streamunsubfailure"
            case unintendedDisconnection = "alertmodel_message_unintendeddisconnection"
            case webSocketServerIsUnstable = "alertmodel_message_serverisunstable"
            case internetConnectionFailed = "alertmodel_message_internetconnectionfailed"
            case unknownError = "alertmodel_message_unknownerror"
        }
        public enum ActionTitle: String, CaseIterable {
            case cancel = "alertmodel_action_title_cancel"
            case retry = "alertmodel_action_title_retry"
            case ignore = "alertmodel_action_title_ignore"
        }
    }
}
