//
//  AddTaskViewController.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 24/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var labelAssessmentName: UILabel!
    @IBOutlet weak var textTaskName: UITextField!
    @IBOutlet weak var textNotes: UITextField!
    @IBOutlet weak var labelSliderValue: UILabel!
    @IBOutlet weak var sliderCompletion: UISlider!
    @IBOutlet weak var taskDueDate: UIDatePicker!
    @IBOutlet weak var taskReminder: UISwitch!
    var assessment:Assessment?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var saveSliderValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        labelAssessmentName.text = self.assessment?.name
        // Do any additional setup after loading the view.
    }
    

    @IBAction func sliderValue(_ sender: UISlider) {
        saveSliderValue = String(Int(sliderCompletion.value * 100))
        labelSliderValue.text = String(Int(sliderCompletion.value * 100)) + "% Completion"
    }
    
    
    
    @IBAction func saveTask(_ sender: UIButton) {
        //New Tasks
        let task = Task(context: context)
        
        let formatter = DateFormatter()
        formatter.calendar = taskDueDate.calendar
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: taskDueDate.date)
        let dateOfDue = formatter.date(from: dateString)
        task.startDate = dateOfDue
        
        let calendar = Calendar.current
        let date = Date()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = formatter.string(from: date)
        let currentTaskDate = formatter.date(from: currentDate)
        
        
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .brief
        form.allowedUnits = [.year, .month, .day, .hour]
        let daysLeft = form.string(from: date, to: taskDueDate.date)
        
        //let dateTOO = Calendar.current.dateComponents([.day], from: date, to: taskDueDate.date).day

        
        task.assessment = assessment?.name
        
        if self.textTaskName.text != ""
        {
            task.name = textTaskName.text
            task.notes = textNotes.text
            task.completion = saveSliderValue
            task.dueDateT = dateString
            task.timeLength = daysLeft
            assessment?.addToTasks(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            if taskReminder.isOn{
                
                let eventStore : EKEventStore = EKEventStore()
                
                eventStore.requestAccess(to: .event){ (granted, error) in
                    
                    if (granted) && (error == nil) {
                        print("granted \(granted)")
                        print("error \(error)")

                        let event:EKEvent = EKEvent(eventStore: eventStore)

                        var dayComp = DateComponents(day: -1)
                        let prevDate = Calendar.current.date(byAdding: dayComp, to: self.taskDueDate.date)
                        
                        event.title = self.textTaskName.text
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
