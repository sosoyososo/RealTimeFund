//
//  DetailViewController.swift
//  howbuy
//
//  Created by Karsa wang on 6/8/15.
//  Copyright (c) 2015 Karsa wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var detailItem: NSNumber? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let detail: NSNumber = self.detailItem {
            if let label = self.webView {
                let url = "http://www.howbuy.com/fund/" + detail.description
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
}

