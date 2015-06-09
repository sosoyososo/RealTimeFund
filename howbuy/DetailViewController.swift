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
            let ajaxUrl = "http://www.howbuy.com/fund/ajax/gmfund/valuation/valuationnav.htm?jjdm=" + detail
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var ajax = NSString(contentsOfURL: NSURL(string: ajaxUrl)!, encoding: NSUTF8StringEncoding, error: nil)
                if ajax?.length>0 {
                    var err : NSError?
                    var parser = HTMLParser(html: ajax! as String, error: &err)
                    if err != nil {
                        println(err)
                    } else {
                        if let timeNode = parser.rootNode?.findNodeById("valuationTime") {
                            if let time = timeNode.getAttributeNamed("value")  as String? {
                                let imgName = "http://static.howbuy.com/images/fund/valuation/160119_"+time+".png"
                                var htmlStr = NSString(format: "<br><br><img src=%@></img>", imgName)
                                if let spanNodes = parser.rootNode?.findChildTags("span") {
                                    var index : Int
                                    for index = 0; index < spanNodes.count; ++index {
                                        let node = spanNodes[index]
                                        if node.className=="con_value con_value_down" {
                                            htmlStr = NSString(format: "%@  %@", node.contents, htmlStr)
                                        } else if node.className=="con_value con_value_up" {
                                            htmlStr = NSString(format: "%@  %@", node.contents, htmlStr)
                                        }
                                        if node.className=="con_ratio_green con_ratio_down" {
                                            htmlStr = NSString(format: "<font color=\"#65AFF8\">%@</font>  %@", node.contents, htmlStr)
                                        } else if node.className=="con_ratio_red con_ratio_up" {
                                            htmlStr = NSString(format: "<font color=\"#DF1921\">%@</font>  %@", node.contents, htmlStr)
                                        }
                                        if node.className=="con_ratio_green" {
                                            htmlStr = NSString(format: "%@  %@", node.contents, htmlStr)
                                        } else if node.className=="con_ratio_red" {
                                        }
                                        if node.className=="tips_icon_con" {
                                            htmlStr = NSString(format: "净值:%@  %@", node.contents, htmlStr)
                                        }
                                    }
                                }
                                self.webView.loadHTMLString(htmlStr as String, baseURL: nil)
                            }
                        }
                    }
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
}

