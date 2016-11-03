//
//  ViewController.swift
//  SOCalenderEvent
//
//  Created by Hitesh on 11/3/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import EventKit

var setDateFormat:String = "dd-MM-yyyy hh:mm a"

class ViewController: UIViewController {

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    
    let datePicker: UIDatePicker = UIDatePicker()
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.SOGetPermissionCalendarAccess()
        self.setupDatePicker()
    }
    
    
    //MARK: Get Premission for access Calender
    func SOGetPermissionCalendarAccess() {
        switch EKEventStore.authorizationStatusForEntityType(.Event) {
        case .Authorized:
            print("Authorised")
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(.Event, completion: { (granted: Bool, error:NSError?) -> Void in
                if granted {
                    print("Granted")
                } else {
                    print("Access Denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    
    func setupDatePicker() {
        // Specifies intput type
        datePicker.datePickerMode = .DateAndTime
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        // Adds the toolbar to the view
        txtStartDate!.inputView = datePicker
        txtStartDate!.inputAccessoryView = toolBar
        txtStartDate?.tag = 1
        
        txtEndDate!.inputView = datePicker
        txtEndDate!.inputAccessoryView = toolBar
        txtEndDate?.tag = 2
    }
    
    func doneClick() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = setDateFormat
        //dateFormatter.dateStyle = .ShortStyle
        if txtStartDate?.isFirstResponder() == true {
            txtStartDate!.text = dateFormatter.stringFromDate(datePicker.date)
            txtStartDate!.resignFirstResponder()
        } else {
            txtEndDate!.text = dateFormatter.stringFromDate(datePicker.date)
            txtEndDate!.resignFirstResponder()
        }
    }
    
    func cancelClick() {
        txtStartDate!.resignFirstResponder()
        txtEndDate!.resignFirstResponder()
    }
    
    @IBAction func actionFetchEvent(sender: AnyObject) {
        if txtStartDate.text == "" || txtEndDate.text == "" {
            return
        }
        
        let objEvent = self.storyboard?.instantiateViewControllerWithIdentifier("EventVCID") as! EventVC
        objEvent.startDate = txtStartDate.text!
        objEvent.endDate = txtEndDate.text!
        self.navigationController?.pushViewController(objEvent, animated: true)
    }
    
    @IBAction func actionNewEvent(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

