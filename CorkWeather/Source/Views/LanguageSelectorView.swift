//
//  LanguageSelectorView.swift
//  CorkWeather
//
//  Created by Eddie Long on 10/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LanguageSelectorView: UIView {
    
    static var ForcedLanguage: String = "en"
    @IBInspectable public var Language : String = LanguageSelectorView.ForcedLanguage {
        didSet {
            LanguageSelectorView.ForcedLanguage = self.Language
        }
    }
    
    static func getBundle(object: AnyObject) -> Bundle? {
        let path = Bundle(for: type(of: object)).path(forResource: LanguageSelectorView.ForcedLanguage, ofType: "lproj")
        guard let bundlePath = path else {
            NSLog("Unable to find bundle for language: %@", LanguageSelectorView.ForcedLanguage)
            return nil
        }
        let bundle = Bundle.init(path: bundlePath)
        guard let localisedBundle = bundle else {
            NSLog("Missing bundle at path: %@", bundlePath)
            return nil
        }
        return localisedBundle
    }
}
