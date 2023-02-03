//
//  BottomViewController.swift
//  BRQBottomSheetExample
//
//  Created by Bruno Faganello Neto on 17/07/19.
//  Copyright © 2019 Faganello. All rights reserved.
//

import UIKit
import IGColorPicker

class BottomViewController: UIViewController {
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    var selectedIndex = Int()
    
    init() {
        super.init(
            nibName: String(describing: BottomViewController.self),
            bundle: Bundle(for: BottomViewController.self)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup color picker
        colorPickerView.delegate = self
        colorPickerView.layoutDelegate = self
        colorPickerView.isSelectedColorTappable = false
        colorPickerView.style = .circle
        colorPickerView.selectionStyle = .check
        colorPickerView.backgroundColor = .clear
        categoryText.layer.cornerRadius = 50
        categoryText.addBottomBorderLineWithColor(color: .gray, width: 1.0)
    }
    
    @IBAction func addCategoryButton(_ sender: UIButton) {
        let newCategory = Category(context: self.context)
        newCategory.name = categoryText.text!
        newCategory.colorAsHex = colorPickerView.colors[selectedIndex]
       
        self.categories.append(newCategory)
        self.saveCategory()
    }
    func saveCategory() {
        do {
            try context.save()
            
        } catch {
            print("Kayıt aşamasında bir hata ile karışılaşıldı.collection")
        }
        
    }
}
extension BottomViewController: ColorPickerViewDelegate, ColorPickerViewDelegateFlowLayout {
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.backgroundColor = colorPickerView.colors[indexPath.item]
    
    }
    
    
    // MARK: - ColorPickerViewDelegateFlowLayout
    
//    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 50)
//    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
}
