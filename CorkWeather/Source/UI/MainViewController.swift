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
import GoogleMaps
import SWLogger
import Proteus_UI
import Proteus_Core

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Storyboarded {
   
    @IBOutlet weak var weatherTableView : UITableView!
    @IBOutlet weak var emptyTableView : UIView!
    @IBOutlet weak var onboardingView : OnboardingView!
    
    var progressView = MBProgressHUD()
    var coordinator: MainCoordinator?
    var viewModel: MainViewModel?
    
    var loadingWeather = WeatherList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIButton.init(type: .infoLight)
        barButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem.init(customView: barButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        weatherTableView.isHidden = true
        emptyTableView.isHidden = true
        
        showMainList()
    }
    
    private func showMainList() {
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
        
        progressView.show(animated: true)
        self.viewModel!.loadWeatherList(callback: databaseLoaded)
        
        //hideOnboarding(showPickerOnCompletion: false)
    }

    func shouldShowOnboarding() {
        analytics().logEvent(AnalyticsEvents.onboardingShown)
        emptyTableView.isHidden = false
        self.onboardingView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: IBActions
    
    @IBAction func addClicked(sender : UIBarButtonItem) {
        analytics().logEvent(AnalyticsEvents.addClicked)
        
        self.onboardingView.hideOnboarding {
            self.showPicker()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel!.numberOfWeatherItems()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel!.numberOfWeatherItems() > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather : Weather = self.viewModel!.getWeatherAtIndex(index: indexPath.row)!
        Log.i ("row \(indexPath.row) weather location \(weather.location.coordinate.latitude) \(weather.location.coordinate.longitude)", "MainVC")
        let isLoading = loadingWeather.contains(weather)
        let weatherUnit = self.viewModel!.desiredTemperature
        return WeatherListCell.instantiate(tableView, indexPath, weather, isLoading, weatherUnit)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel!.removeWeatherAtIndex(index: indexPath.row)
            if (self.viewModel!.numberOfWeatherItems() == 0) {
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if (self.viewModel!.numberOfWeatherItems() == 0) {
                self.emptyTableView.isHidden = false
                self.weatherTableView.isHidden = true
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: WeatherViewProtocol
    
    func weatherItemLoaded(result: WeatherItemResult) {
        progressView.hide(animated: true)
        switch result {
        case .success(let weather):
            self.emptyTableView.isHidden = true
            self.weatherTableView.isHidden = false
            if let index = loadingWeather.index(of: weather) {
                loadingWeather.remove(at: index)
            }
            
            // TODO: Only refresh the correct row
            self.weatherTableView.reloadData()
        case .failure(let error):
            analytics().logEvent(AnalyticsEvents.weatherItemLoadFailure, [AnalyticsEvents.errorInfoDetail: error])
            Log.w("Failed to load weather with error: \(error)")
            showWeatherFetchFailure(reason: error)
        }
    }
    
    func databaseLoaded(result: DatabaseResult) {
        progressView.hide(animated: true)
        switch result {
        case .success(let weatherList):
            if weatherList.isEmpty {
                self.emptyTableView.isHidden = false
                self.weatherTableView.isHidden = true
                
                // We get back an empty list on first start
                if self.viewModel!.shouldShowOnboarding(true) {
                    self.onboardingView.show()
                }
            } else {
                self.emptyTableView.isHidden = true
                self.weatherTableView.isHidden = false
            }
            
            for weather in weatherList {
                if !loadingWeather.contains(weather) {
                    loadingWeather.append(weather)
                }
                
                // TODO: Add loading indicator
                self.viewModel!.fetch(weather.location) { [weak self] result in
                    self?.weatherItemLoaded(result: result)
                }
            }
            self.weatherTableView.reloadData()
        case .failure(let errorType):
            analytics().logEvent(AnalyticsEvents.databaseLoadFailure, [AnalyticsEvents.errorInfoDetail: errorType])
            Log.w("Failed to load weather with error: \(errorType)")
            showWeatherListLoadFailure(reason: errorType, retryCallback: {
                self.viewModel!.loadWeatherList(callback: self.databaseLoaded)
            })
        }
    }
    
    // MARK: Misc
    
    func weatherLocationObtained(result : PickResult) {
        switch result {
        case .success(let location):
            // Add address to list
            self.viewModel!.fetch(location) { [weak self] result in
                self?.weatherItemLoaded(result: result)
            }
        case .failure(let error):
            analytics().logEvent(AnalyticsEvents.weatherLocationFetchFailure, [AnalyticsEvents.errorInfoDetail: error])
            progressView.hide(animated: true)
            showWeatherPickError(reason: error)
        }
    }
    
    @objc func showInfo() {
        analytics().logEvent(AnalyticsEvents.infoClicked)
        self.coordinator?.showInfo()
    }
}
