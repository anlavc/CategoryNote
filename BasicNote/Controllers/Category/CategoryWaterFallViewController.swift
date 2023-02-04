//
//  CategoryViewController.swift
//  BasicNote
//
//  Created by Anıl AVCI on 26.01.2023.
//

import UIKit
import CoreData

class CategoryWaterFallViewController: UIViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   let cell = "cellcategory"
    @IBOutlet weak var tableView: UITableView!
    let cellCategory = "wallCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadCategory()
      
        
        self.tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: cell)
    }
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Veriler yüklenirken bir sorun oldu \(error.localizedDescription)")
        }
        tableView.reloadData()
    }


}
extension CategoryWaterFallViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categories = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as? CategoryTableViewCell
        cell?.textLabel?.text = categories.name
        return cell!
    }
  
    
}

