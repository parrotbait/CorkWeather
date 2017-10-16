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

class InfoViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var bioText : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Strings.get("Info_Title")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let originalText = NSMutableAttributedString.init(string: Strings.get("Follow_Twitter"), attributes: [NSParagraphStyleAttributeName: paragraphStyle])
        originalText.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, originalText.length))
        let text = NSMutableAttributedString.init(string: "Twitter")
        text.addAttribute(NSLinkAttributeName, value: "http://www.twitter.com/parrotbait", range: NSMakeRange(0, 7))
        originalText.append(text)
        originalText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, originalText.length))
        
        bioText.textColor = .white
        bioText.delegate = self
        bioText.attributedText = originalText
    }
    
    @IBAction func contactClicked(sender: Any?) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController.init()
            mailVC.setSubject("Cork Weather App Feedback")
            mailVC.setToRecipients(["parrotbait@gmail.com"])
            self.present(mailVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("No_Email_Setup"), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = SFSafariViewController.init(url: URL)
        if #available(iOS 10.0, *) {
            vc.preferredBarTintColor = .red
            vc.preferredControlTintColor = .white
        } else {
            vc.view.tintColor = .red
        }
        self.present(vc, animated: true, completion: nil)
        return false
    }
}
