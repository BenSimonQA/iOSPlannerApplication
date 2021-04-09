//
//  AddAssessmentViewController.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 18/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import EventKit

class AddAssessmentViewController: UIViewController {

    @IBOutlet weak var textModule: UITextField!
    @IBOutlet weak var textLevel: UITextField!
    @IBOutlet weak var textAssessment: UITextField!
    @IBOutlet weak var textValue: UITextField!
    @IBOutlet weak var textMark: UITextField!
    @IBOutlet weak var textNotes: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderAssessment: UISwitch!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var sliderCompletion: UISlider!
    
    var saveSliderValue = ""
    //get context handle
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    @IBAction func setReminder(_ sender: UISwitch) {
        
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        saveSliderValue = String(Int(sliderCompletion.value * 100))
        completionLabel.text = String(Int(sliderCompletion.value * 100)) + "% Completion"
    }
    
    @IBAction func saveAssessment(_ sender: UIButton) {
        let newAssessment = Assessment(context: context)
        
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: datePicker.date)

        
        if self.textAssessment.text != ""
        {
            
            let calendar = Calendar.current
            let date = Date()
            formatter.dateFormat = "dd.MM.yyyy"
            let currentDate = formatter.string(from: date)
            let currentTaskDate = formatter.date(from: currentDate)
            
            let form = DateComponentsFormatter()
            form.maximumUnitCount = 2
            form.unitsStyle = .brief
            form.allowedUnits = [.year, .month, .day, .hour]
            let daysLeft = form.string(from: date, to: datePicker.date)
            
            newAssessment.name = self.textAssessment.text
            newAssessment.notes = self.textNotes.text
            newAssessment.module = self.textModule.text
            //newAssessment.level = self.textLevel.text
            newAssessment.dueDate = "Due " + dateString
            //newAssessment.aValue = self.textValue.text
            //newAssessment.aMark = self.textMark.text
            newAssessment.progress = saveSliderValue
            newAssessment.daysLeft = daysLeft
            
            
            let eventStore : EKEventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event){ (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    print("error \(error)")

                    let event:EKEvent = EKEvent(eventStore: eventStore)

                    event.title = self.textAssessment.text
                    event.startDate = self.datePicker.date
                    event.endDate = self.datePicker.date
                    event.notes = self.textNotes.text
                    //event.addAlarm(EKAlarm(absoluteDate: self.datePicker.date))
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                }
                else{

                    print("failed to save event with error : \(error) or access not granted")
                }
                
            }
            
            
            if reminderAssessment.isOn{
                
                let eventStore : EKEventStore = EKEventStore()
                
                eventStore.requestAccess(to: .event){ (granted, error) in
                    
                    if (granted) && (error == nil) {
                        print("granted \(granted)")
                        print("error \(error)")

                        let event:EKEvent = EKEvent(eventStore: eventStore)

                        var dayComp = DateComponents(day: -1)
                        let prevDate = Calendar.current.date(byAdding: dayComp, to: self.datePicker.date)
                        
                        event.title = self.textAssessment.text
                        event.startDate = prevDate
                        event.endDate = prevDate
                        event.notes = "A day before due date."
                        event.addAlarm(EKAlarm(absoluteDate: prevDate!))
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        do {
                            try eventStore.save(event, span: .thisEvent)
                        } catch let error as NSError {
                            print("failed to save event with error : \(error)")
                        }
                        print("Saved Event")
                    }
                    else{
                        print("failed to save event with error : \(error) or access not granted")
                    }
                    
                }
                
                
            }
            else{

            }
            
                        
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        else{
                //Alert
                let alert = UIAlertController(title: "Missing Assessment", message: "Please enter details", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
        }
        
        if self.textLevel.text != ""
        {
            if (self.textLevel.text == "3" || self.textLevel.text == "4" || self.textLevel.text == "5" || self.textLevel.text == "6" || self.textLevel.text == "7")
            {
                newAssessment.level = self.textLevel.text
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            else{
                    //Alert
                    let alert = UIAlertController(title: "Wrong Input, Levels must be 3,4,5,6,7", message: "Please enter details", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
            }
        }

        
        if self.textMark.text != ""
        {
            let checkMark = Int(self.textMark.text!)
            if checkMark != nil
            {
                if (checkMark! > 0 && checkMark! < 100)
                {
                    newAssessment.aMark = self.textMark.text
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                else{
                        //Alert
                        let alert = UIAlertController(title: "Wrong Input Marks must be from 0 - 100", message: "Please enter details", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                        alert.addAction(OKAction)
                        self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "Wrong Input Marks must be integers", message: "Please enter details", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if self.textValue.text != ""
        {
            let checkValue = Int(self.textValue.text!)
            if checkValue != nil
            {
                if (checkValue! > 0 && checkValue! < 100)
                {
                    newAssessment.aValue = self.textValue.text
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                else{
                        //Alert
                        let alert = UIAlertController(title: "Wrong Input Value must be from 0 - 100", message: "Please enter details", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                        alert.addAction(OKAction)
                        self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                let alert = UIAlertController(title: "Wrong Input Value must be integers", message: "Please enter details", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }
}
