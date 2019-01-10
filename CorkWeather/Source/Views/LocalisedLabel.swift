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
class LocalisedLabel : UILabel {
    @IBInspectable public var localisationId : String = ""
    
    override func layoutSubviews() {
        super.layoutSubviews();
        syncWithIB()
    }
    
    func syncWithIB() {
        if !self.localisationId.isEmpty {
            let ret = Bundle(for: type(of: self)).localizedString(forKey: self.localisationId, value: "", table: nil);
            self.text = ret
        }
    }
}
