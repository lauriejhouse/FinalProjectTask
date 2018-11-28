//
//  NewGoalViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol NewGoalViewControllerDelegate: class {
    func newGoalViewControllerDidCancel(_ controller: NewGoalViewController)
    func newGoalViewController(_ controller: NewGoalViewController, didFinishAdding goal: GoalItem)
    func newGoalViewController(_ controller: NewGoalViewController, didFinishEditing goal: GoalItem)
}

class NewGoalViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    

    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var managedContext: NSManagedObjectContext!
    
    weak var delegate: NewGoalViewControllerDelegate?
    var goalToEdit: GoalItem?
    
    let icons = ["No Icon", "Sport", "Self", "work", "Computer", "Fun"]
    var placeholderGoals = ["Learn Programming", "Learn Piano", "Build Rome", "Become Enlightened", "Breathe Underwater", "Turn Back Time", "Run A Marathon", "Read 10 Books", "Quit Job", "Deactivate Facebook"]
    
    
    
    
    
    
    
    // MARK: - Action Methods
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.newGoalViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let goal = goalToEdit {
            goal.text = goalTextField.text!
            goal.iconName = iconLabel.text!
            delegate?.newGoalViewController(self, didFinishEditing: goal)
        } else {
            let goal = NSEntityDescription.insertNewObject(forEntityName: "GoalItem", into: managedContext) as! GoalItem
            goal.text = goalTextField.text!
            goal.iconName = iconLabel.text
            delegate?.newGoalViewController(self, didFinishAdding: goal)
        }
        
    }
    
    
    
    
    
    // MARK: - BPs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let goal = goalToEdit {
            title = "Edit Goal"
            goalTextField.text = goal.text
            doneBtn.isEnabled = true
            iconLabel.text = goal.iconName
            imageView.image = UIImage(named: goal.iconName!)
        } else {
            let randomGoals = placeholderGoals.randomItem()
            goalTextField.placeholder = "\(randomGoals!)..."
            let random = icons.randomItem()
            imageView.image = UIImage(named: random!)
            iconLabel.text = random
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goalTextField.becomeFirstResponder()
    }
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 2 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    
    
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBtn.isEnabled = newText.length > 0
        
        return true
        
    }
    
    
    
    
    
    // MARK: - Icon Picker Delegate
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        imageView.image = UIImage(named: iconName)
        iconLabel.text = iconName
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let vc = segue.destination as! IconPickerViewController
            vc.delegate = self
        }
    }
    
    
    
    
}

public extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
