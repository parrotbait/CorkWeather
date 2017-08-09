//
//  ViewController.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class MainViewController: UIViewController, WeatherViewProtocol {

    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherMinTemp: UILabel!
    @IBOutlet weak var weatherMaxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!;
    @IBOutlet weak var weatherView: UIView!;
    var progressView = MBProgressHUD()
    
    let weatherBase = "https://openweathermap.org/img/w/%@.png"
    
    var presenter : WeatherPresenter! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presenter = WeatherPresenterImpl(view: self, fetcher: WeatherFetcher());
        weatherView.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.fetch("Cork,IE")
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
    }

    func weatherLoadFailed() {
        weatherDescription.text = "Load Failed";
        progressView.hide(animated: true)
    }
    
    func weatherLoaded(weather: Weather) {
        let property = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.6, animations: { [weak self] in
            self?.weatherView.alpha = 1.0
        })
        property.startAnimation()
        progressView.hide(animated: true)
        weatherDescription.text = weather.description;
        
        weatherTemp.text = String(format: "%@", presenter.getUnitAsString(weather.temperature));
        weatherMinTemp.text = String(format: Strings.get("Min_Temp"), presenter.getUnitAsString(weather.minTemperature));
        weatherMaxTemp.text = String(format: Strings.get("Max_Temp"), presenter.getUnitAsString(weather.maxTemperature));
        windSpeed.text = String(format: Strings.get("Wind_Speed"), weather.windSpeed);
        weatherIcon.sd_setImage(with: URL(string: String(format: weatherBase, weather.icon)), placeholderImage: nil)
    }
}

