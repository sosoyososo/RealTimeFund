//
//  SearchFundController.swift
//  howbuy
//
//  Created by Karsa wang on 6/8/15.
//  Copyright (c) 2015 Karsa wang. All rights reserved.
//

import UIKit
import Foundation


class SearchFundController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var saerchBar: UISearchBar!
    @IBOutlet weak var cancelItem : UIBarButtonItem!
    
    var objects  = Dictionary<String, String>()
    var allKeys = [String]()
    var master : MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.saerchBar
        self.navigationItem.leftBarButtonItem = self.cancelItem
    }
    @IBAction func cancel() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let url  = "http://s.howbuy.com/search.do?q=" + searchText
            var content = NSString(contentsOfURL: NSURL(string: url)!, encoding: NSUTF8StringEncoding, error: nil)
            if let range = content?.rangeOfString("<") {
                if range.length > 0 {
                    content = content?.substringFromIndex(range.location);
                }
            }
            if let range = content?.rangeOfString(">", options:NSStringCompareOptions.BackwardsSearch) {
                if range.length>0 {
                    content = content?.substringToIndex(range.location+1);
                }
            }
            
            self.allKeys.removeAll(keepCapacity: true)
            self.objects.removeAll(keepCapacity: true)
            
            var err : NSError?
            var parser = HTMLParser(html: content! as String, error: &err)
            if err != nil {
                println(err)
            } else {
                if let trNodes = parser.rootNode?.findChildTags("tr") {
                    var indexTr : Int
                    for indexTr=0;indexTr<trNodes.count;++indexTr {
                        let trNode = trNodes[indexTr]
                        
                        var indexTd : Int
                        var num = ""
                        var name : String?
                        var tdNodes = trNode.findChildTags("td")
                        for indexTd=0;indexTd<tdNodes.count;++indexTd {
                            let tdNode = tdNodes[indexTd]
                            if tdNode.className == "\\\"d-l\\\"" {
                                let pNodes = tdNode.findChildTags("p")
                                if  pNodes.count > 0 {
                                    name = pNodes[0].contents
                                } else {
                                    num = tdNode.contents
                                    let spans = tdNode.findChildTags("span")
                                    if  spans.count > 0 {
                                        var span = spans[0]
                                        num = num + span.contents
                                        
                                        let spanRange = tdNode.rawContents.rangeOfString(span.rawContents) as Range!
                                        var content = tdNode.rawContents.substringFromIndex(spanRange.endIndex)
                                        content = content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                                        content = content.substringToIndex((content.rangeOfString("<")?.startIndex)!)
                                        num = num + content
                                    }
                                }
                            }
                        }
                        if name?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 && name?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0  {
                            if num.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "--")).lengthOfBytesUsingEncoding(NSUTF8StringEncoding)>0 {
                                self.objects[num] = name!
                                self.allKeys.insert(num, atIndex: 0)
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let num = self.allKeys[indexPath.row] as String
        let name = self.objects[num]
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = num
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let num = self.allKeys[indexPath.row] as String
            let name = self.objects[num]
            self.master?.insertNewObject(name!, num: num)
        })
    }
}

