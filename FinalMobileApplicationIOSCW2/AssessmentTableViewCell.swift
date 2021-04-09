//
//  AssessmentTableViewCell.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 26/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import CoreData

class AssessmentTableViewCell: UITableViewCell {

    @IBOutlet weak var labelModule: UILabel!
    @IBOutlet weak var labelAssessment: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelMark: UILabel!
    
    var textModule = ""
    var textAssessment = ""
    var textDueDate = ""
    var textValue = ""
    var textMark = ""
    
    override func awakeFromNib() {
        
        labelModule.text = textModule
        labelAssessment.text = textAssessment
        labelDueDate.text = textDueDate
        labelValue.text = textValue
        labelMark.text = textMark
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
