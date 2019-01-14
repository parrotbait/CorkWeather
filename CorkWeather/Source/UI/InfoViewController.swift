//
//  InfoViewController.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import SafariServices
import Proteus_UI
import Proteus_Core

class InfoViewController: UIViewController, UITextViewDelegate, Storyboarded {
    
    @IBOutlet weak var bioText : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let originalText = NSMutableAttributedString.init(string: Strings.get("Follow_Twitter"), attributes: [NSAttributedString.Key.foregroundColor: paragraphStyle])
        originalText.addAttribute(NSAttributedString.Key.link, value: UIColor.white, range: NSRange.init(location: 0, length: originalText.length))
        let text = NSMutableAttributedString.init(string: "Twitter")
        text.addAttribute(NSAttributedString.Key.link, value: sharedConfig.twitterBio, range: NSRange.init(location:0, length: 7))
        originalText.append(text)
        originalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: NSRange.init(location:0, length: originalText.length))
        
        bioText.textColor = .white
        bioText.delegate = self
        bioText.attributedText = originalText
    }
    
    @IBAction func contactClicked(sender: Any?) {
        if MFMailComposeViewController.canSendMail() {
            analytics().logEvent(AnalyticsEvents.contactClicked)
            let mailVC = MFMailComposeViewController.init()
            mailVC.setSubject(sharedConfig.feedbackEmailSubject)
            mailVC.setToRecipients(sharedConfig.feedbackEmailRecipients)
            self.present(mailVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("No_Email_Setup"), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let viewcontroller = SFSafariViewController.init(url: URL)
        if #available(iOS 10.0, *) {
            viewcontroller.preferredBarTintColor = .red
            viewcontroller.preferredControlTintColor = .white
        } else {
            viewcontroller.view.tintColor = .red
        }
        self.present(viewcontroller, animated: true, completion: nil)
        return false
    }
}
