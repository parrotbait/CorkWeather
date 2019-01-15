//
//  UILabel+Localisation.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class LocalisedLabel : UILabel {
    @IBInspectable public var localisationId : String = ""
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        syncWithIB()
    }
    
    func syncWithIB() {
        if !self.localisationId.isEmpty {
            let bundle = Bundle.init(for: type(of: self))
            let ret = bundle.localizedString(forKey: self.localisationId, value: "", table: nil)
            self.text = ret
        }
    }
}
