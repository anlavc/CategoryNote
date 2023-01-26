//
//  ViewController.swift
//  BasicNote
//
//  Created by Anıl AVCI on 15.01.2023.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    let cell = "categoryCell"
    var categories = [Category]()
    var notes = [Note]()
    
    var selectedCollectionCategory : Category?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var addCategoryButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable()
        delegateFunc()
        viewEdit()
        loadCategory()
        loadNote()
        setupLongGestureRecognizerOnCollection()
    }
    fileprivate func delegateFunc() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        noteTableView.delegate = self
        noteTableView.dataSource = self
        searchBar.delegate = self
    }
    
    fileprivate func viewEdit() {
        addCategoryButton.layer.cornerRadius = 8
        addCategoryButton.layer.masksToBounds = true
        addNoteButton.layer.cornerRadius = addNoteButton.bounds.size.height / 2
        
        addNoteButton.layer.shadowColor = UIColor.black.cgColor
        addNoteButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        addNoteButton.layer.shadowOpacity = 0.7
        addNoteButton.layer.shadowRadius = 4.0
        
        addNoteButton.layer.masksToBounds = true
    }
    
    fileprivate func registerTable() {
        self.noteTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let nibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(nibCell, forCellWithReuseIdentifier: cell)
    }
    
    
    /// Collection Long Gesture action
    func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        categoryCollectionView?.addGestureRecognizer(longPressedGesture)
    }
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let p = gestureRecognizer.location(in: categoryCollectionView)
        
        if let indexPath = categoryCollectionView?.indexPathForItem(at: p)  {
            
            print("Long press at item: \(indexPath.row)")
            
        }
    }
    /// Note Add Button Segue
    /// - Parameter sender: button click
    @IBAction func addNoteButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToAddNoteID")
        self.show(vc!, sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        noteTableView.reloadData()
        loadNote()
    }
    /// CoreData load func
    /// - Parameter request: CoreData Note request
    func loadNote(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            notes = try context.fetch(request)
        } catch {
            print("Veriler yüklenirken bir sorun oldu \(error.localizedDescription)")
        }
        noteTableView.reloadData()
    }
    /// Load Category Note
    /// - Parameter request
    func loadCategoryNote(index: Int) {
       
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "upCategory.name MATCHES %@", categories[index].name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadNote(with: request)
     
    }
    /// Note Save Func
    func saveNote() {
        do {
            try context.save()
            print("başatıyla title kayıt edildi.")
        } catch {
            print("Kayıt aşamasında bir hata ile karışılaşıldı.title")
        }
        self.noteTableView.reloadData()
    }
    /// Category Add Button
    /// - Parameter sender: Button
    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategory()
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Cancel button press")
        }))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
      
        present(alert, animated: true, completion: nil)
    }
    /// Save Category Func
    func saveCategory() {
        do {
            try context.save()
            
        } catch {
            print("Kayıt aşamasında bir hata ile karışılaşıldı.collection")
        }
        self.categoryCollectionView.reloadData()
        
    }
    
    /// CoreData  Load Category
    /// - Parameter request: Category request
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Veriler yüklenirken bir sorun oldu \(error.localizedDescription)")
        }
        categoryCollectionView.reloadData()
    }
    /// Tableview Remove Note
    func removeItem(listItem: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "item = %@", listItem)
        
        if let result = try? context.fetch(fetchRequest) {
            for item in result {
                context.delete(item)
            }
            do {
                saveNote()
                print("silindi ve kayıt edildi.")
            } catch let error {
                print("silinemedi ve kayıt olmadı")
            }
        }
    }
    
}
//MARK: - CollectionView Delegate and GestureRecognizer
extension NotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        loadCategoryNote(index: indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as?  CategoryCollectionViewCell
        let categories = categories[indexPath.row]
        cell?.categoryLabel.text = categories.name
        categoryCollectionView.layer.cornerRadius = 20
        categoryCollectionView.layer.masksToBounds = true
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categories[indexPath.row].name
        let font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.regular)
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        let width = text!.size(withAttributes: attributes).width
        
        return CGSize(width: width + 8+8+8+15, height: 35)
        
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                print("delete button clicked")
                let data = self.categories[indexPath.row] // items = [NSManagedObject]()
                self.context.delete(data)
                self.categories.remove(at: indexPath.row)
                self.categoryCollectionView.deleteItems(at: [indexPath])
                self.saveCategory()
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
        }
        return context
    }
    
}
//MARK: - Tableview Delegate and DataSource
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    private func handleMoveToTrash() {
        print("Moved to trash")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        let notes = notes[indexPath.row]
        cell?.title.text = notes.title
        cell?.date.text = notes.upCategory?.name
        cell?.note.text = notes.noteText
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteaction = UITableViewRowAction(style: .default, title: "Sil") { action, indexPath in
            
            let data = self.notes[indexPath.row] // items = [NSManagedObject]()
            self.context.delete(data)
            self.notes.remove(at: indexPath.row)
            self.noteTableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveNote()
        }
        return [deleteaction]
    }
    
}

//MARK: - SearchBar Delegate
extension NotesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR noteText CONTAINS[cd] %@ OR upCategory.name CONTAINS[cd] %@", searchBar.text!,searchBar.text!,searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadNote(with: request)
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNote()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
    }
    }
}
