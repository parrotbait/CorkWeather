//
//  WeatherListCell.swift
//  Cork Weather
//
//  Created by Eddie Long on 09/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import UIKit

class WeatherListCell : UITableViewCell {
    @IBOutlet weak var weatherLocation: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherMaxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print ("init")
    }

}
