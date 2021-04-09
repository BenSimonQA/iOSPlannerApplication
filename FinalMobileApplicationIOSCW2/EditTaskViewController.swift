//
//  EditTaskViewController.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 25/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class EditTaskViewController: UIViewController {
    @IBOutlet weak var labelAssessment: UILabel!
    @IBOutlet weak var textTask: UITextField!
    @IBOutlet weak var textNotes: UITextField!
    @IBOutlet weak var complationLabel: UILabel!
    @IBOutlet weak var sliderCompletion: UISlider!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var setReminder: UISwitch!
    var saveSliderValue = ""
    var currentTask:Task?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelAssessment.text = currentTask?.assessment
        textTask.text = currentTask?.name
        textNotes.text = currentTask?.notes
        complationLabel.text = currentTask?.completion ?? "" + "% Completion"
        let setSliderValue = Float(currentTask?.completion ?? "")
        sliderCompletion.value = setSliderValue ?? 0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        saveSliderValue = String(Int(sliderCompletion.value * 100))
        complationLabel.text = String(Int(sliderCompletion.value * 100)) + "% Completion"
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        
        let task = Task(context: context)
        
        let formatter = DateFormatter()
        formatter.calendar = dueDatePicker.calendar
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: dueDatePicker.date)
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
        let daysLeft = form.string(from: date, to: dueDatePicker.date)
        
        //let dateTOO = Calendar.current.dateComponents([.day], from: date, to: taskDueDate.date).day
        if setReminder.isOn{
            
            let eventStore : EKEventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event){ (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    print("error \(error)")

                    let event:EKEvent = EKEvent(eventStore: eventStore)

                    var dayComp = DateComponents(day: -1)
                    let prevDate = Calendar.current.date(byAdding: dayComp, to: self.dueDatePicker.date)
                    
                    event.title = self.textTask.text
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

        
        currentTask?.assessment = labelAssessment.text
        currentTask?.name = textTask.text
            currentTask?.notes = textNotes.text
            currentTask?.completion = saveSliderValue
            currentTask?.dueDateT = dateString
            currentTask?.timeLength = daysLeft
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

        
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
