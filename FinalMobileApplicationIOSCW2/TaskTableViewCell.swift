//
//  TaskTableViewCell.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 25/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!
    @IBOutlet weak var labelDateLeft: UILabel!
    @IBOutlet weak var labelCompletion: UILabel!
    @IBOutlet weak var porgressDueDate: UIProgressView!
    @IBOutlet weak var progressCompletion: UIProgressView!
    
    var textTask = ""
    var textNotes = ""
    var textDueDate = ""
    var textDayLeft = ""
    var textComp = ""
    var part = ""
    var task:Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        porgressDueDate.transform = porgressDueDate.transform.scaledBy(x: 1, y: 10)
        progressCompletion.transform = progressCompletion.transform.scaledBy(x: 1, y: 10)
        // Initialization code
        labelTask.text = textTask
        labelNotes.text = textNotes
        labelDueDate.text = textDueDate
        labelDateLeft.text = textDayLeft
        print(textComp.count)
        labelCompletion.text = textComp
        //progressCompletion.setProgress(progressValue ?? 0, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
