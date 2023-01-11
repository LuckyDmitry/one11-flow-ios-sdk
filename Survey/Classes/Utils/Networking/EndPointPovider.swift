//
//  EndPointPovider.swift
//  1Flow
//
//  Created by Rohan Moradiya on 30/04/22.
//

import Foundation

protocol EndPointProtocol {
    var url: String { get }
}

enum EndPoints: EndPointProtocol {
    case addUser
    case getSurveys
    case addEvent
    case submitSurvey
    case logUser
    case appStoreRating
    
    var url: String {
        let BaseURL: String = {
                if OFProjectDetailsController.shared.currentEnviromment == .dev {
                    return "https://ez37ppkkcs.eu-west-1.awsapprunner.com/api/2021-06-15"
                } else {
                    return "https://api-sdk.1flow.app/api/2021-06-15"
                }
        }()
        switch self {
        case .addUser:
            return BaseURL + "/v3/user"
        case .getSurveys:
            var surveyUrl = BaseURL + "/v3/survey?platform=iOS"
            if let userID : String = OFProjectDetailsController.shared.analytic_user_id {
                surveyUrl = surveyUrl + "&user_id=" + userID
            }

            if let libraryVersion =
                OFProjectDetailsController.shared.libraryVersion {
                surveyUrl = surveyUrl + "&min_version=" + libraryVersion
            } else {
                surveyUrl = surveyUrl + "&min_version=" + OFProjectDetailsController.shared.oneFlowSDKVersion
            }

            if let langStr = Locale.current.languageCode {
                surveyUrl = surveyUrl + "&language_code=" + langStr
                OneFlowLog.writeLog("Language Code: \(langStr)")
            }
            return surveyUrl
        case .addEvent:
            return BaseURL + "/v3/track"
        case .submitSurvey:
            return BaseURL + "/v3/response"
        case .logUser:
            return BaseURL + "/v3/identify"
        case .appStoreRating:
            guard let bundleID = Bundle.main.bundleIdentifier else {
                return ""
            }
            return "http://itunes.apple.com/lookup?bundleId=" + bundleID
        }
    }
}
