//
//  initialViewController.swift
//  test
//
//  Created by ML on 9/2/18.
//  Copyright © 2018 ML. All rights reserved.
//

import UIKit

class initialViewController: UIViewController {
    
    var searchResult = [String:[String:[String:Int]]]()
    let home = NSHomeDirectory() + "/Documents"
    let txtField = UITextField(frame: CGRect(x: 0, y: (UIScreen.main.bounds.height-40)/2, width: UIScreen.main.bounds.width-30, height: 30))
    let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-30, y: (UIScreen.main.bounds.height-40)/2, width: 30, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(home)
        view.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(search), for: .touchUpInside)
        txtField.backgroundColor = UIColor.white
        button.backgroundColor = UIColor.blue
        view.addSubview(txtField)
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func search(){
        if let searchText = txtField.text{
            if searchText == ""{return}
            let fileList = getAllFiles(ofType: [".txt"])
            let searchList = searchText.components(separatedBy: "-")
            searchASync(files: fileList, For: searchList)
        }
    }
    
    private func searchASync(files:[String], For: [String]){
        let group = DispatchGroup()
        let tableView = TableViewController(info: self.searchResult, fileList: [], searchList: For)
        var processFileList = [String]()
        var onlyONCE = true
        self.navigationController?.pushViewController(tableView, animated: true)
        
        for file in files {
            group.enter()
            //print("--start\(file)")
            DispatchQueue.global(qos: .userInitiated).async {
                let newReader = txtReader(path: file)
                self.searchResult[file] = newReader.search(forText: For)
                processFileList.append(file)
                DispatchQueue.main.async {
                    tableView.processView.text = "\(processFileList.count)of\(files.count)"
                }
                //print("--finish\(file)")
                group.leave()
            }
            group.notify(queue: .global()){
                guard onlyONCE == true else {return}
                onlyONCE = false
                DispatchQueue.main.async {
                    print("fkkk")
                    tableView.processView.isHidden = true
                    tableView.update(withFileList: processFileList, withInfo: self.searchResult)
                }
            }
        }
    }
    
    private func getAllFiles(ofType: [String]) -> [String]{
        var result = [String]()
        let allFiles = FileManager.default.enumerator(atPath: home)
        if let rawArr = allFiles?.allObjects as? [String]{
            for i in rawArr{
                for j in ofType{
                    if i.hasSuffix(j){
                        result.append(i)
                    }
                }
            }
            //print(result)
            return result
        }
        return [""]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
