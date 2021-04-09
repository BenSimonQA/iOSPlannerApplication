//
//  EditAssessmentViewController.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 18/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class EditAssessmentViewController: UIViewController {
    @IBOutlet weak var textModule: UITextField!
    @IBOutlet weak var textLevel: UITextField!
    @IBOutlet weak var textAssessment: UITextField!
    @IBOutlet weak var textValue: UITextField!
    @IBOutlet weak var textMark: UITextField!
    @IBOutlet weak var textNotes: UITextField!
    @IBOutlet weak var updateDatePicker: UIDatePicker!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var sliderCompletion: UISlider!
    @IBOutlet weak var setReminder: UISwitch!
    
    var saveSliderValue = ""
    
    var currentAssessment:Assessment?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textModule.text = currentAssessment?.module
        textLevel.text = currentAssessment?.level
        textAssessment.text = currentAssessment? .name
        textValue.text = currentAssessment?.aValue
        textMark.text = currentAssessment?.aMark
        textNotes.text = currentAssessment?.notes
        completionLabel.text = currentAssessment?.progress ?? "" + "% Completion"
        let setSliderValue = Float(currentAssessment?.progress ?? "")
        sliderCompletion.value = setSliderValue ?? 0
    }
    
    @IBAction func saveSlider(_ sender: UISlider) {
        saveSliderValue = String(Int(sliderCompletion.value * 100))
        completionLabel.text = String(Int(sliderCompletion.value * 100)) + "% Completion"
    }
    
    @IBAction func updateAssessment(_ sender: UIButton) {
        //Get Date Picker detail
        let formatter = DateFormatter()
        formatter.calendar = updateDatePicker.calendar
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: updateDatePicker.date)
        
        
        let checkMark = Int(textMark.text!)
        if checkMark != nil
        {
            if (checkMark! > 0 && checkMark! < 100)
            {
                currentAssessment?.aMark = textMark.text
                
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
        
        if (textLevel.text == "3" || textLevel.text == "4" || textLevel.text == "5" || textLevel.text == "6" || textLevel.text == "7")
        {
            currentAssessment?.level = textLevel.text
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        else{
                //Alert
                let alert = UIAlertController(title: "Wrong Input, Levels must be 3,4,5,6,7", message: "Please enter details", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
        }
        
        
        let checkValue = Int(textValue.text!)
                  if checkValue != nil
                  {
                      if (checkValue! > 0 && checkValue! < 100)
                      {
                          currentAssessment?.aValue = textValue.text
                          
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
        
        
        if setReminder.isOn{
            
            let eventStore : EKEventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event){ (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    print("error \(error)")

                    let event:EKEvent = EKEvent(eventStore: eventStore)

                    var dayComp = DateComponents(day: -1)
                    let prevDate = Calendar.current.date(byAdding: dayComp, to: self.updateDatePicker.date)
                    
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
        
        //Update detail
        currentAssessment?.name = textAssessment.text
        currentAssessment?.module = textModule.text
        //currentAssessment?.level = textLevel.text
        //currentAssessment?.aValue = textValue.text
        //currentAssessment?.aMark = textMark.text
        currentAssessment?.notes = textNotes.text
        currentAssessment?.dueDate = "Due " + dateString
        currentAssessment?.progress = saveSliderValue
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
