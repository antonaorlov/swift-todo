
import UIKit

//subclass of UITableViewController, inherits methods from UITableViewController
//takes on AddItemViewControllerDelegate methods
class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
  //create empty array
  var items = [ChecklistItem]()
  
  func saveChecklistItems() {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(items) {
          UserDefaults.standard.set(encoded, forKey: "ChecklistItems")
      }
  }
  
  func loadChecklistItems() {
    let decoder = JSONDecoder()
        if let savedItems = UserDefaults.standard.object(forKey: "ChecklistItems") as? Data {
            if let loadedItems = try? decoder.decode([ChecklistItem].self, from: savedItems) {
                items = loadedItems
                print("Successfully loaded checklist items")
            } else {
                print("Failed to decode checklist items")
            }
        }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //navigation bar prefer large titles
    navigationController?.navigationBar.prefersLargeTitles = true

    //creates instances of item sets a location add to items array
    let item1 = ChecklistItem()
    item1.text = "Visit New York"
    items.append(item1)

    let item2 = ChecklistItem()
    item2.text = "Visit London"
    item2.checked = true
    items.append(item2)

    let item3 = ChecklistItem()
    item3.text = "Visit Paris"
    item3.checked = true
    items.append(item3)

    let item4 = ChecklistItem()
    item4.text = "Visit Texas"
    items.append(item4)

    let item5 = ChecklistItem()
    item5.text = "Visit Lake City"
    items.append(item5)
    
    loadChecklistItems()
       
    
  }

  // MARK: - Navigation
  //prepare bedore viewcontroller
  override func prepare(
    for segue: UIStoryboardSegue,
    sender: Any?
  ) {
    //check if string is AddItem, seque is performed
    if segue.identifier == "AddItem" {
      //seque destination is AddItemViewController, seque current view controller assigned to
      //AddItemViewController ChecklistViewController: UITableViewController
      let controller = segue.destination as! AddItemViewController
      controller.delegate = self
    }
  }

  // MARK: - Actions
  //fucntion checks if to set checkmark, if item boolean is cheked
  func configureCheckmark(
    for cell: UITableViewCell,
    with item: ChecklistItem
  ) {
    if item.checked {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
  }
//sets up text display for table view cell, gets UILabel from ce..viewWithTag(1000)
//sets label text to item text of array
  func configureText(
    for cell: UITableViewCell,
    with item: ChecklistItem
  ) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }

  // MARK: - Table View Data Source
  //ovverides NumberOfRowsInSection from UITableViewDataSource
  //return number of rows equal to items array.
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return items.count
  }

  //dequeueReusableCell reuses cell if available or creates a new one, ceheckListItem deque a cell
   override func tableView(
     _ tableView: UITableView,
     cellForRowAt indexPath: IndexPath
   ) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(
       withIdentifier: "ChecklistItem",
       for: indexPath)
     //gets checklistitem equals to current row of table
     let item = items[indexPath.row]

     configureText(for: cell, with: item)
     configureCheckmark(for: cell, with: item)

     return cell
   }
  // MARK: - Table View Delegate
  //
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    //selects cell of index
    if let cell = tableView.cellForRow(at: indexPath) {
      //fetches checklist item of selected row
      let item = items[indexPath.row]
      //toggles checked property
      item.checked.toggle()

      //update check of cell
      configureCheckmark(for: cell, with: item)
    }
    //deselects row
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    // remove item from array of table.
    items.remove(at: indexPath.row)

    // deletes the row at index
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
  
  // MARK: - Add Item ViewController Delegates
  //function works if user cancels adding an item
  func addItemViewControllerDidCancel(
    _ controller: AddItemViewController
  ) {
    //returns to previous view controller
    navigationController?.popViewController(animated: true)
  }

  //user completes adding an item
  func addItemViewController(
    _ controller: AddItemViewController,
    didFinishAdding item: ChecklistItem
  ) {
    
    //determnes new row index, last index of array
    let newRowIndex = items.count
    //adds to new array
    items.append(item)
    
    //creates new indexpath,inserts row and cancels if user dosent use return to previous controller
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated:true)
  }
}

