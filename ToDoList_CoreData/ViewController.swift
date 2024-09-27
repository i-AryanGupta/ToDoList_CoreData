//
//  ViewController.swift
//  ToDoList_CoreData
//
//  Created by Yashom on 27/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // in context where we can perform object in core data database
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // we need a property thats should be global that drive the number of models
    
    private var models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        title = "To Do List"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target:  self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
         
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            
            self?.createItem(name: text)
        }
                                     ))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            print(indexPath)
        
        
            let model = models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier:  "cell", for: indexPath)
            cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func getAllItems(){
        do{
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData() // it is a UI operation so we do in the main thread
            }
        }
        catch{
            
        }
    }
    
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems() // refrest our models and reload our tableView
        }
        catch{
            
        }
    }
    
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        
        do{
            try context.save()
        }
        catch{
            
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String)
    {
        item.name = newName
        
        do{
            try context.save()
        }
        catch{
             
        }
        
    }

}

