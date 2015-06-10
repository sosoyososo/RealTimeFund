//
//  MasterViewController.swift
//  howbuy
//
//  Created by Karsa wang on 6/8/15.
//  Copyright (c) 2015 Karsa wang. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    @IBOutlet weak var addItem: UIBarButtonItem!

    var detailViewController: DetailViewController? = nil
    var objects  = Dictionary<String, String>()
    var allKeys = [String]()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem?.title = "编辑"

        self.navigationItem.rightBarButtonItem = addItem
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        if let obj = NSUserDefaults.standardUserDefaults().valueForKey("num") as? [String] {
            self.allKeys = obj
        }
        if let obj = NSUserDefaults.standardUserDefaults().valueForKey("name") as? Dictionary<String, String> {
            self.objects = obj
        }
        self.tableView.reloadData()
    }

    func insertNewObject(name : String,num : String) {
        self.allKeys.insert(num, atIndex: 0)
        self.objects[num] = name
        self.tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setValue(self.allKeys, forKey: "num")
        NSUserDefaults.standardUserDefaults().setValue(self.objects, forKey: "name")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let num = self.allKeys[indexPath.row] as String
                let name = self.objects[num]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = num
                controller.title = name
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "Add" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! SearchFundController
            controller.master = self
        }
    }

    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let num = self.allKeys[indexPath.row] as String
        let name = self.objects[num]
        cell.textLabel!.text = name
        cell.detailTextLabel?.text = num
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let num = self.allKeys[indexPath.row] as String
            self.allKeys.removeAtIndex(indexPath.row)
            self.objects.removeValueForKey(num)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)            
            NSUserDefaults.standardUserDefaults().setValue(self.allKeys, forKey: "num")
            NSUserDefaults.standardUserDefaults().setValue(self.objects, forKey: "name")
        } else if editingStyle == .Insert {
        }
    }


}

