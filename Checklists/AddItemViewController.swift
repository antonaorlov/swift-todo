

import UIKit

//calls when user cancels to add a new item
protocol AddItemViewControllerDelegate: AnyObject {
  //handle cancel
  func addItemViewControllerDidCancel(
    _ controller: AddItemViewController)
  //handle completion
  func addItemViewController(
    _ controller: AddItemViewController,
    didFinishAdding item: ChecklistItem
  )
}

//subclass of UITableViewController manages tableview, confroms to UITextFieldDelegate
//responding events of UITextField
class AddItemViewController: UITableViewController, UITextFieldDelegate {
  //UI elements to storyboard
  @IBOutlet weak var textField: UITextField! //textfield
  @IBOutlet weak var doneBarButton: UIBarButtonItem! //button adding item

  weak var delegate: AddItemViewControllerDelegate? //prevents cycles

  //called after controller view loaded in memory, large title display to never
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    // Initialize a UIView with a blue background
        let myView = UIView(frame: CGRect(x: 0, y: 10, width: 2000, height: 1000))
        myView.backgroundColor = .red
        myView.alpha = 1.0 // Start fully visible
        view.addSubview(myView)

        // Animate the opacity of myView to fade out
        UIView.animate(withDuration: 2.0) { // Duration is 2 seconds
            myView.alpha = 0 // Animate to fully invisible
        }
    tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
  }

  //makes keyboard active, displays before view
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    textField.becomeFirstResponder()
  }

  // MARK: - Actions
  //connected to ui element, when user clicks cancel button, calls addItemViewCOntrollerDidCancel method
  @IBAction func cancel() {
    delegate?.addItemViewControllerDidCancel(self)
  }

  //method when user taps done, creates new checklistitem, set text to textfield,
  //call addItemViewController method
  @IBAction func done() {
    let item = ChecklistItem()
    item.text = textField.text!

    delegate?.addItemViewController(self, didFinishAdding: item)
  }

  // MARK: - Table View Delegates
  //if user tries to select row at table view, nil prevents it
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    return nil
  }

  // MARK: - Text Field Delegates
  //called when user makes changes to textfield
  //gets new text from current edit of user, if empty disables doneBarButton
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    //creates new text by repalcing old one with new input
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(
      in: stringRange,
      with: string)
    if newText.isEmpty {
      doneBarButton.isEnabled = false
    } else {
      doneBarButton.isEnabled = true
    }
    return true
  }

  //when text about to be cleared, disable done button, return true to clear button
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }
}


