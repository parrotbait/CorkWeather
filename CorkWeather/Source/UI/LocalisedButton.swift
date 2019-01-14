//
//  LocalisedButton.swift
//  CorkWeather
//
//  Created by Eddie Long on 09/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class LocalisedButton : UIButton {
    @IBInspectable public var normalText : String = ""
    @IBInspectable public var highlightText : String = ""
    @IBInspectable public var disabledText : String = ""
    @IBInspectable public var selectedText : String = ""
    @IBInspectable public var focusedText : String = ""
 
    open override func layoutSubviews() {
        super.layoutSubviews()
        syncWithIB()
    }
    
    func syncWithIB() {
        guard let localisedBundle = LanguageSelectorView.getBundle(object: self) else {
            return
        }
        if !self.normalText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.normalText, value: "", table: nil)
            setTitle(ret, for: .normal)
        }
        
        if !self.highlightText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.highlightText, value: "", table: nil)
            setTitle(ret, for: .highlighted)
        }
        if !self.disabledText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.disabledText, value: "", table: nil)
            setTitle(ret, for: .disabled)
        }
       
        if !self.selectedText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.selectedText, value: "", table: nil)
            setTitle(ret, for: .selected)
        }
        
        if !self.focusedText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.focusedText, value: "", table: nil)
            if #available(iOS 9.0, *) {
                setTitle(ret, for: .focused)
            }
        }
    }
}
