//
//  UIBarButtonItem+Localisation.swift
//  CorkWeather
//
//  Created by Eddie Long on 16/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit

class LocalisedBarButtonItem : UIBarButtonItem {
    @IBInspectable public var localisationId : String = "" {
        didSet {
            self.title = Strings.get(self.localisationId)
        }
    }
}
