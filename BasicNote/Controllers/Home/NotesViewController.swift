//
//  ViewController.swift
//  BasicNote
//
//  Created by Anıl AVCI on 15.01.2023.
//

import UIKit
import CoreData
import IGColorPicker
protocol BottomViewControllerDelegate: class {
    func reloadCollectionView()
}
class NotesViewController: UIViewController,BottomViewControllerDelegate {
    func reloadCollectionView() {
        loadCategory()
        categoryCollectionView.reloadData()
        
    }
    
    
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
        
        //MARK: - collectionmove
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        categoryCollectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = categoryCollectionView else {
            return
        }
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            
        default:
            collectionView.cancelInteractiveMovement()
        }
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
    @IBAction func addNoteButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "goToAddNoteID")
        self.show(vc!, sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        noteTableView.reloadData()
        categoryCollectionView.reloadData()
        loadCategory()
        loadNote()
    }
    func loadNote(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            notes = try context.fetch(request)
        } catch {
            print("Veriler yüklenirken bir sorun oldu \(error.localizedDescription)")
        }
        noteTableView.reloadData()
    }
    func loadCategoryNote(index: Int) {
        if categories[index].name! == "Genel" {
            DispatchQueue.main.async {
                self.loadNote()
            }
        } else {
            DispatchQueue.main.async {
                let request : NSFetchRequest<Note> = Note.fetchRequest()
                request.predicate = NSPredicate(format: "upCategory.name MATCHES %@", self.categories[index].name!)
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                self.loadNote(with: request)
            }
        }
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "upCategory.name MATCHES %@", categories[index].name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadNote(with: request)
    }
    func saveNote() {
        do {
            try context.save()
            print("başatıyla title kayıt edildi.")
        } catch {
            print("Kayıt aşamasında bir hata ile karışılaşıldı.title")
        }
        self.noteTableView.reloadData()
    }
    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {
        let myViewController = BottomViewController()
        myViewController.delegate = self
        let bottomSheetViewModel = BRQBottomSheetViewModel(
            cornerRadius: 20,
            animationTransitionDuration: 0.3,
            backgroundColor: UIColor.red.withAlphaComponent(0.5)
        )
        let bottomSheetVC = BRQBottomSheetViewController(
            viewModel: bottomSheetViewModel,
            childViewController: myViewController
        )
        presentBottomSheet(bottomSheetVC, completion: nil)
        
    }
    /// Save Category Func
    func saveCategory() {
        do {
            try context.save()
            
        } catch {
            print("Kayıt aşamasında bir hata ile karışılaşıldı.collection")
        }
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
            self.noteTableView.reloadData()
        }

    }
    /// CoreData  Load Category
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Veriler yüklenirken bir sorun oldu \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
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
            } catch let error {
                print(error.localizedDescription)
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
        cell?.contentView.backgroundColor = categories.colorAsHex as? UIColor ?? UIColor.random()
        categoryCollectionView.layer.cornerRadius = 20
        categoryCollectionView.layer.masksToBounds = true
        return cell!
        
    }
    //MARK: - Collection Move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = categories.remove(at: sourceIndexPath.row)
        categories.insert(item, at: destinationIndexPath.row)
        
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
        if notes.count == 0 {
            tableView.setEmptyView(title: "Note", message: "To list your notes, first add a category and note...")
        }
        else {
            tableView.restore()
        }
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        let notes = notes[indexPath.row]
        
        cell?.title.text = notes.title
        cell?.date.text = notes.upCategory?.name ?? "Genel"
        cell?.note.text = notes.noteText
        cell?.dateView.backgroundColor = notes.upCategory?.colorAsHex as? UIColor ?? UIColor.random()
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteaction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            
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
