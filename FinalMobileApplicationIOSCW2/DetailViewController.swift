//
//  DetailViewController.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 18/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var currentTask:Task?
    
    @IBOutlet weak var tableView: UITableView!

    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let cellColour:UIColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let cellSelColour:UIColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        //configure cell
        self.configureCell(cell, indexPath: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = cellSelColour
        cell.selectedBackgroundView = backgroundView
        let object = fetchedResultsController.object(at: indexPath)
        self.currentTask = object
        let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].name
        cell.labelTask?.text = title
        if let noteText = self.fetchedResultsController.fetchedObjects?[indexPath.row].notes
        {
            cell.labelNotes?.text = noteText
        }
        else{
            cell.labelNotes?.text = ""

        }
        if let dateText = self.fetchedResultsController.fetchedObjects?[indexPath.row].dueDateT
        {
            cell.labelDueDate?.text = "Due Date: " + dateText
        }
        else{
            cell.labelDueDate?.text = ""

        }
        if let textDaysleft = self.fetchedResultsController.fetchedObjects?[indexPath.row].timeLength
        {
            cell.labelDateLeft?.text = textDaysleft + " left"
        }
        else{
            cell.labelDateLeft?.text = ""

        }
        if let completText = self.fetchedResultsController.fetchedObjects?[indexPath.row].completion
        {
            cell.labelCompletion?.text = completText + "% Complete"
            let decimalValueText = String("0."+completText)
            let progressValue = Float(decimalValueText)
            cell.progressCompletion.setProgress(progressValue ?? 0, animated: true)
        }
        else{
            cell.labelCompletion?.text = ""

        }
        return cell
    }
    
    // MARK: - Configure Cell
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath)
    {
        
        //let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].name
        //cell.textLabel?.text = title
        cell.backgroundColor = cellColour
        if let noteText = self.fetchedResultsController.fetchedObjects?[indexPath.row].notes
        {
            cell.detailTextLabel?.text = noteText
        }
        else{
            cell.detailTextLabel?.text = ""

        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = assessment {
            if let label = detailDescriptionLabel {
                label.text = detail.name
            }

       }
    }

    var assessment: Assessment? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    // MARK: - Fetched results controller

    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let currentAssessment = self.assessment
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if(self.assessment != nil)
        {
            let predicate = NSPredicate(format: "classAssessment = %@", currentAssessment!)
            fetchRequest.predicate = predicate
        }
        else{
            //let predicate = NSPredicate(format: "assessment = %@", "Mathematics")
            //fetchRequest.predicate = predicate
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController<Task>(
        fetchRequest: fetchRequest,
        managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: #keyPath(Task.assessment),
        cacheName: nil)
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }

    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //<#code#>
        
        if let identifier = segue.identifier{
            switch identifier
            {
            case "assessmentDetail":
                let destVC = segue.destination as! AssessmentDetailViewController
                //set assessment name
                if let name = self.assessment?.name
                {
                    destVC.assessmentName = name
                }
                else{
                    destVC.assessmentName = "No Assessment set"
                }
                if let notes = self.assessment?.notes
                {
                    destVC.textNotes = notes
                }
                else{
                    destVC.textNotes = "No Notes set"
                }
                if let date = self.assessment?.dueDate
                {
                    destVC.textDueDate = date
                }
                else{
                    destVC.textDueDate = "No Date set"
                }
                if let module = self.assessment?.module
                {
                    destVC.textModule = module
                }
                else{
                    destVC.textModule = "No Module set"
                }
                if let level = self.assessment?.level
                {
                    destVC.textLevel = "Level " + level
                }
                else{
                    destVC.textLevel = "No Level set"
                }
                if let aValue = self.assessment?.aValue
                {
                    destVC.textValue = aValue
                }
                else{
                    destVC.textValue = "No Value set"
                }
                if let aMark = self.assessment?.aMark
                {
                    destVC.textMark = aMark
                }
                else{
                    destVC.textMark = "No Mark set"
                }
                if let completion = self.assessment?.progress
                {
                    destVC.textCompletion = completion
                }
                else{
                    destVC.textCompletion = "0"
                }
                if let dayLeft = self.assessment?.daysLeft
                {
                    destVC.textDaysLeft = dayLeft
                }
                else{
                    destVC.textDaysLeft = "0 days"
                }
                default:
                break
            }
        }
        if segue.identifier == "addTask"
        {
            let object = self.assessment
            let controller = segue.destination as! AddTaskViewController
            controller.assessment = object
        }
        if segue.identifier == "editTask"
        {
            let destVC = segue.destination as! EditTaskViewController
            destVC.currentTask = self.currentTask
        }
    }
    
    //MARK: - Editing Cell
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
            case .move:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}

