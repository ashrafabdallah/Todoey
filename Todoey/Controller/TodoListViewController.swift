//
//  ViewController.swift
//  Todoey
//
//  Created by Ashraf Eltantawy on 11/09/2023.
//

import UIKit

class TodoListViewController: UITableViewController {
    private var selectedRow:Int?
    let dataFilePath  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var array = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadItems()
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ToDoItemCell.rawValue, for: indexPath)
        let item = array[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done  ? .checkmark : .none
     
       // cell.accessoryType  = (indexPath.row  == selectedRow) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let selectedRow = selectedRow {
//                  let deselectedIndexPath = IndexPath(row: selectedRow, section: indexPath.section)
//                  let deselectedCell = tableView.cellForRow(at: deselectedIndexPath)
//                  deselectedCell?.accessoryType = .none
//              }
              
              // Update the selected row and add a checkmark to the new selection
//              selectedRow = indexPath.row
//              let cell = tableView.cellForRow(at: indexPath)
//              cell?.accessoryType = .checkmark
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        array[indexPath.row].done = !array[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {[weak self] action in
            guard let self = self else {return}
            if textField.text?.isEmpty == true{
                textField.placeholder = "please add item."
                self.present(alert, animated: true)
            }else{
                if let text = textField.text{
                    self.array.append(Item(title: text))
                }
                saveItems()
                self.dismiss(animated: true)
            }
        }
        
        alert.addTextField{
            $0.placeholder = "Create New Item"
            textField = $0
            
        }
        
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(array)
            try data.write(to: dataFilePath!)
        }catch{
            
        }
        tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                array = try decoder.decode([Item].self, from: data)
                
            }catch{
                
            }
        }
    }
    
}

