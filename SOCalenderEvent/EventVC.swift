//
//  EventVC.swift
//  SOCalenderEvent
//
//  Created by Hitesh on 11/3/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import EventKit

class EventVC: UIViewController {
    
    var startDate = ""
    var endDate = ""
    
    let arrEvent = NSMutableArray()

    @IBOutlet weak var tblEvent: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getAllEvents()
    }
    
    func getAllEvents() {
        
        //
        let eventStore = EKEventStore()
        let calendars = eventStore.calendarsForEntityType(.Event)
        
        for calendar in calendars {
            print(calendar)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = setDateFormat
            
            let dateStart = dateFormatter.dateFromString(startDate)!
            let dateEnd = dateFormatter.dateFromString(endDate)!
            
            let predicate = eventStore.predicateForEventsWithStartDate(dateStart, endDate: dateEnd, calendars: [calendar])
            
            let events = eventStore.eventsMatchingPredicate(predicate)
            
            for event in events {
                let dict = NSMutableDictionary()
                dict.setValue(event.title, forKey: "title")
                dict.setValue(event.startDate, forKey: "startDate")
                dict.setValue(event.endDate, forKey: "endDate")
                dict.setValue(calendar.title, forKey: "type")
                arrEvent.addObject(dict)
            }
        }
        tblEvent.reloadData()
        print(arrEvent)
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEvent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        let dict = arrEvent.objectAtIndex(forRowAtIndexPath.row) as! NSDictionary
        
        let lblName = cell.contentView.viewWithTag(1) as! UILabel
        lblName.text = dict.valueForKey("title") as? String
        
        let lblType = cell.contentView.viewWithTag(2) as! UILabel
        lblType.text = dict.valueForKey("type") as? String
        
        let lblStartDate = cell.contentView.viewWithTag(3) as! UILabel
        lblStartDate.text = self.convertDateIntoString((dict.valueForKey("startDate") as? NSDate)!)
        
        let lblEndDate = cell.contentView.viewWithTag(4) as! UILabel
        lblEndDate.text = self.convertDateIntoString((dict.valueForKey("endDate") as? NSDate)!)
    }
    
    func convertDateIntoString(dateString : NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzz"
        let dateObj = dateFormatter.stringFromDate(dateString)
        return dateObj
    }

    

    @IBAction func actionBack(sender: AnyObject) {
                self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
