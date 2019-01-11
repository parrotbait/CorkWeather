//
//  OnboardingView.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import UIKit

class OnboardingView: UIView {
    
    @IBOutlet weak var step1Background : UIView!
    @IBOutlet weak var arrowButton : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func show() {
        self.isHidden = false
        self.alpha = 0.0
        step1Background.alpha = 0.0
        arrowButton.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
            self.step1Background.alpha = 1.0
        }) { (_ result : Bool) in
            if result {
                UIView.animate(withDuration: 0.5, animations: {
                    self.arrowButton.alpha = 1.0
                });
            }
        }
        
        let tapGR = UITapGestureRecognizer()
        tapGR.addTarget(self, action: #selector(onboardingClicked))
        self.addGestureRecognizer(tapGR)
    }
    
    @IBAction func onboardingClicked(sender : Any?) {
        // Don't like this in here
        analytics().logEvent(AnalyticsEvents.onboardingClicked)
        hideOnboarding(nil)
    }
    
    typealias HideComplete = (() -> Void)
    
    func hideOnboarding(_ callback: HideComplete?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }) { (_ result : Bool) in
            self.isHidden = true
            callback?()
        }
    }
}
