//
//  UIBarButtonItem+Localisation.swift
//  CorkWeather
//
//  Created by Eddie Long on 16/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class LocalisedBarButtonItem : UIBarButtonItem {
    @IBInspectable public var localisationId : String = "" {
        didSet {
            let ret = Bundle(for: type(of: UIApplication.shared)).localizedString(forKey: self.localisationId, value: "", table: nil)
            self.title = ret
        }
    }
}
