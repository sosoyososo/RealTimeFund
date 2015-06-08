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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let url  = "http://s.howbuy.com/search.do?q=" + searchText
            var content = NSString(contentsOfURL: NSURL(string: url)!, encoding: NSUTF8StringEncoding, error: nil)

            let numStart = "<td class=\\\"d-l\\\">"
            let numEnd = "</td><td class=\\\"d-l\\\"><p class=\\\"fund-n\\\">"
            let nameEnd = "</p>"

            self.allKeys.removeAll(keepCapacity: true)
            self.objects.removeAll(keepCapacity: true)
            var range = content?.rangeOfString(numStart)
            for ;range?.length>0; {
                let range1 = content?.rangeOfString(numEnd)
                let numLength = ((range1?.location)! as Int) - ((range?.length)! as Int)  - ((range?.location)! as Int)
                let numRange = NSMakeRange(((range?.length)! as Int) + ((range?.location)! as Int), numLength)
                let num = content?.substringWithRange(numRange)
                content = content?.substringFromIndex(((range1?.location)! as Int) + ((range1?.length)! as Int))
                let range2 = content?.rangeOfString(nameEnd)
                let name = content?.substringToIndex(((range2?.location)! as Int))
                range = content?.rangeOfString(numStart)
                self.objects[num!] = name!
                self.allKeys.insert(num!, atIndex: 0)
            }
            self.tableView.reloadData()
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
    
}

