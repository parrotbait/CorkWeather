//
//  UILabel+Localisation.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit

class LocalisedLabel : UILabel {
    @IBInspectable public var localisationId : String = "" {
        didSet {
            self.text = Strings.get(self.localisationId)
        }
    }
}
