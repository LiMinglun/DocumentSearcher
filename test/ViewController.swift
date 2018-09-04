//
//  ViewController.swift
//  test
//
//  Created by ML on 8/30/18.
//  Copyright © 2018 ML. All rights reserved.
//

import UIKit
import Material

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var filePath = ""
    var infos = [String:[String:Int]]()
    var searchList = [String]()
    var txtView = UITextView(frame: CGRect())
    var searchCurrent = 0
    var textContent = NSString(string: "")
    var currentFocus:Int?{
        didSet{
            if currentFocus == nil{return}
            if currentFocus! < 1{
                currentFocus = infos[searchList[searchCurrent]]!.count-1
            }
            else if currentFocus! > infos[searchList[searchCurrent]]!.count-1{
                currentFocus = 1
            }
        }
    }
    
    init(txtPath: String, searchInfo:[String:[String:Int]], searches:[String]){
        super.init(nibName: nil, bundle: nil)
        filePath = txtPath
        infos = searchInfo
        searchList = searches
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        let reader = txtReader(path: filePath)
        super.viewDidLoad()
        txtView = UITextView()
        txtView.backgroundColor = UIColor.white
        if let txtContent = reader.nsOrig(){
            textContent = txtContent

            //a.scrollRangeToVisible(txtContent.range(of: "s", options: .widthInsensitive))
        }
        highLight()
        view.layout(txtView).top(65).left().right().bottom(30)
        
        initializeUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    let txtFld = UITextField()
    private func initializeUI(){
        view.backgroundColor = Color.grey.lighten4
        let picker = UIPickerView(frame: CGRect())
        picker.dataSource = self
        picker.delegate = self
        txtFld.inputView = picker
        txtFld.text = searchList[searchCurrent]
        txtFld.backgroundColor = Color.grey.lighten3
        let buttonDown = Button(title: "Down", titleColor: UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1))
        let buttonUp = Button(title: "Up", titleColor: UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1))
        buttonDown.addTarget(self, action: #selector(nxt), for: .touchUpInside)
        buttonUp.addTarget(self, action: #selector(prv), for: .touchUpInside)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(confirm))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtFld.inputAccessoryView = toolBar
        view.layout(buttonUp).bottom().right(60).height(30).width(60)
        view.layout(buttonDown).bottom().right().height(30).width(60)
        view.layout(txtFld).bottom().left().right(120).height(30)
    }
    @objc func nxt(){
        guard infos[searchList[searchCurrent]]!.count > 1 else {
            return
        }
        let searchName = searchList[searchCurrent]
        let currentSearch = infos[searchName]!
        if currentFocus != nil {currentFocus!+=1} else {currentFocus = 1}
        txtView.scrollRangeToVisible(NSMakeRange(currentSearch["Position"+String(describing: currentFocus!)]!, searchName.count))
        highLight()
    }
    @objc func prv(){
        guard infos[searchList[searchCurrent]]!.count > 1 else {
            return
        }
        let searchName = searchList[searchCurrent]
        let currentSearch = infos[searchName]!
        if currentFocus != nil {currentFocus!-=1} else {currentFocus = 1}
        txtView.scrollRangeToVisible(NSMakeRange(currentSearch["Position"+String(describing: currentFocus!)]!, searchName.count))
        highLight()
    }
    @objc func confirm(){
        highLight()
        txtFld.resignFirstResponder()
    }
    private func highLight(){
        let attributed = NSMutableAttributedString(string: textContent as String)
        let searchName = searchList[searchCurrent]
        let currentSearch = infos[searchName]!
        if currentSearch.count >= 2{
            for i in 1...currentSearch.count-1{
                let range = NSMakeRange(currentSearch["Position"+String(describing: i)]!, searchName.count)
                if i == currentFocus{
                    attributed.addAttribute(.backgroundColor, value: UIColor.red, range: range)
                }
                else{
                    attributed.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
                }
            }
        }
        self.txtView.attributedText = attributed
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchList.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchCurrent = row
        currentFocus = nil
        txtFld.text = searchList[searchCurrent]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchList[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

