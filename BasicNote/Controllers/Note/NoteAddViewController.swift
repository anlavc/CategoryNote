//
//  NoteAddViewController.swift
//  BasicNote
//
//  Created by Anıl AVCI on 17.01.2023.
//

import UIKit
import CoreData


class NoteAddViewController: UIViewController {
    
    var notes = [Note]()
    var categoriesPicker = [Category]()
    var selectedCategory : Category?
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var noteAreaTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var categoriesTextView: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        noteAreaTextView.layer.cornerRadius = 8
        noteAreaTextView.layer.masksToBounds = true
        loadCategory()
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    /// CoreData Load Category
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoriesPicker = try context.fetch(request)
            print("veriler yüklendi.")
        } catch {
            print("Veriler yüklenirken bir sorun oldu \(error.localizedDescription)")
        }
    }
    
    /// Picher Hidden
    @IBAction func isTappeddropdownButton(_ sender: Any) {
        pickerView.isHidden = false
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    /// CoreData Note Save
  
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if titleTextView.text == "" {
            let refreshAlert = UIAlertController(title: "Warning", message: "Title field cannot be empty.", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(refreshAlert, animated: true, completion: nil)
        } else if categoriesTextView.text == "Category" {
            let refreshAlert = UIAlertController(title: "Warning", message: "Please select a category.", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(refreshAlert, animated: true, completion: nil)
        } else {
            let refreshAlert = UIAlertController(title: "Success", message: "Note added", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let newTitle = Note(context: self.context)
                newTitle.title = self.titleTextView.text!
                newTitle.noteText = self.noteAreaTextView.text
                newTitle.upCategory = self.selectedCategory
                self.notes.append(newTitle)
                self.saveNote()
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    /// CoreData Note Save
    func saveNote() {
        do {
            try context.save()
            print("Veri başarıyla kayıt edildi.")
        } catch {
            print("Kayıt aşamasında bir hata ile karışılaşıldı\(error.localizedDescription)")
        }
    }
}

extension NoteAddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesPicker[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoriesTextView.text = categoriesPicker[row].name
        selectedCategory = categoriesPicker[row]
        pickerView.isHidden = true
    }
    
}
extension NoteAddViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoriesTextView {
            print("You edit myTextField")
        }
    }
}
