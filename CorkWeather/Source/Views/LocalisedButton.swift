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
class LocalisedButton : UIButton {
    @IBInspectable public var NormalText : String = ""
    @IBInspectable public var HighlightText : String = ""
    @IBInspectable public var DisabledText : String = ""
    @IBInspectable public var SelectedText : String = ""
    @IBInspectable public var FocusedText : String = ""
 
    override func layoutSubviews() {
        super.layoutSubviews();
        syncWithIB()
    }
    
    func syncWithIB() {
        
        guard let localisedBundle = LanguageSelectorView.getBundle(object: self) else {
            return
        }
        if !self.NormalText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.NormalText, value: "", table: nil);
            setTitle(ret, for: .normal)
        }
        
        if !self.HighlightText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.HighlightText, value: "", table: nil);
            setTitle(ret, for: .highlighted)
        }
        if !self.DisabledText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.DisabledText, value: "", table: nil);
            setTitle(ret, for: .disabled)
        }
       
        if !self.SelectedText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.SelectedText, value: "", table: nil);
            setTitle(ret, for: .selected)
        }
        
        if !self.FocusedText.isEmpty {
            let ret = localisedBundle.localizedString(forKey: self.FocusedText, value: "", table: nil);
            if #available(iOS 9.0, *) {
                setTitle(ret, for: .focused)
            }
        }
    }
}
