//
//  ViewController.swift
//  CoreDataCRUD
//
//  Created by MACBOOK on 28/12/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //reference to manage object context
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        fetchPeople()
    }
    
    private func fetchPeople(){
        do{
            
            items = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("ERROR")
        }
    }
    
    //MARK- clickAddBtn
    @IBAction func clickAddBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "ADD", message: "Add a new person", preferredStyle: .alert)
        alert.addTextField()
        
        let submitBtn = UIAlertAction(title: "SAVE", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text!
            newPerson.age = 100
            
            do{
                try self.context.save()
            }
            catch{
                print("ERROR while Saving the person")
            }
            
            self.fetchPeople()
            
        }
        alert.addAction(submitBtn)
        self.present(alert, animated: true, completion: nil)
        
    
    }
    

}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        guard let person = items?[indexPath.row] else{ return UITableViewCell()}
        cell.textLabel?.text  = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = items![indexPath.row]
        
        let alert = UIAlertController(title: "EDIT", message: "Update person", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        
        textField.text = person.name
        
        let submitBtn = UIAlertAction(title: "UPDATE", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            person.name = textField.text
            
            do{
                try self.context.save()
            }
            catch{
                print("ERROR while updating the person")
            }
            
            self.fetchPeople()
            
        }
        alert.addAction(submitBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let personToRemove = self.items![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do{
                try self.context.save()
            }
            catch{
                print("ERROR in removing the person from DB")
            }
            
            self.fetchPeople()
            
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}

