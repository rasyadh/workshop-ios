//
//  Localify.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

/**
 Localization Language Identifier.
 */
enum LanguageName: String {
    case english = "en"
}

/**
 Class used to handle Localization language.
 */
class Localify: NSObject {
    static let shared = Localify()
    private var languageBundle: Bundle!
    var languageIdentifier = ""
    
    /**
    Set enabled language localization.
    - Parameters:
       - name: LanguageName identifier
    */
    func setLanguage(_ name: LanguageName) {
        let path = Bundle.main.path(forResource: name.rawValue, ofType: ".lproj")!
        let bundle = Bundle(path: path)!
        languageBundle = bundle
        switch name {
        case .english:
            languageIdentifier = "en"
        }
    }
    
    /**
    Get string of localisation.
    - Parameters:
       - key: String localization identifier
    */
    static func get(_ key: String) -> String {
        return NSLocalizedString(key, bundle: Localify.shared.languageBundle, comment: "")
    }
}
