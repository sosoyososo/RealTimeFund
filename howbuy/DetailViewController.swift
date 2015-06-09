//
//  DetailViewController.swift
//  howbuy
//
//  Created by Karsa wang on 6/8/15.
//  Copyright (c) 2015 Karsa wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    var detailItem: String? {
        didSet {
            self.configureView()
        }
    }
    func configureView() {
        if let detail: String = self.detailItem {
            if let label = self.webView {
                let url = "http://www.howbuy.com/fund/" + detail
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let path = NSBundle.mainBundle().pathForResource("detail", ofType: "js")
        let js = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error:nil)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            webView.stringByEvaluatingJavaScriptFromString(js as! String)
        })
    }
}

