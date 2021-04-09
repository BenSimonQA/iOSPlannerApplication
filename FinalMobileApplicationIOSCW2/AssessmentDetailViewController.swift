//
//  AssessmentDetailViewController.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 18/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit

class AssessmentDetailViewController: UIViewController {

    @IBOutlet weak var labelAssessmentName: UILabel!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var textViewModule: UITextView!
    @IBOutlet weak var textViewLevel: UITextView!
    @IBOutlet weak var textViewDueDate: UITextView!
    @IBOutlet weak var textViewValue: UITextView!
    @IBOutlet weak var textViewMark: UITextView!
    @IBOutlet weak var progressViewMark: UIProgressView!
    @IBOutlet weak var progressViewValue: UIProgressView!
    @IBOutlet weak var labelCompletion: UILabel!
    @IBOutlet weak var labelPerCompletion: UILabel!
    @IBOutlet weak var completionProgress: UIProgressView!
    @IBOutlet weak var labeDaysLeft: UITextView!
    
    var textNotes = ""
    var textModule = ""
    var textLevel = ""
    var textDueDate = ""
    var textValue = ""
    var textMark = ""
    var assessmentName = ""
    var textCompletion = ""
    var textDaysLeft = ""
    var assessment:Assessment?
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewValue.transform = progressViewValue.transform.scaledBy(x: 1, y: 5)
        progressViewMark.transform = progressViewMark.transform.scaledBy(x: 1, y: 5)
        completionProgress.transform = completionProgress.transform.scaledBy(x: 1, y: 5)
        
        labeDaysLeft.text = textDaysLeft
        labelAssessmentName.text = assessmentName
        textViewNotes.text = textNotes
        textViewDueDate.text = textDueDate
        textViewModule.text = textModule
        textViewLevel.text = textLevel
        let decimalValueText = String("0."+textValue)
        let progressValue = Float(decimalValueText)
        textViewValue.text = textValue
        progressViewValue.setProgress(progressValue ?? 0, animated: true)
        let decimalMarkText = String("0."+textMark)
        let progressMark = Float(decimalMarkText)
        textViewMark.text = textMark
        progressViewMark.setProgress(progressMark ?? 0, animated: true)
        let decimalProgressText = String("0."+textCompletion)
        let progressComp = Float(decimalProgressText)
        labelPerCompletion.text = textCompletion
        completionProgress.setProgress(progressComp ?? 0, animated: true)
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
