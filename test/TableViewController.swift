//
//  TableViewController.swift
//  test
//
//  Created by ML on 9/2/18.
//  Copyright © 2018 ML. All rights reserved.
//

import UIKit
import Material
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var tableView = UITableView(frame: CGRect())
    var tableViewInfo: [String:[String:[String:Int]]]
    var files = [""]
    var searches = [""]
    public var processView = UILabel(frame: CGRect())
    
    init(info: [String:[String:[String:Int]]], fileList:[String], searchList: [String]){
        tableViewInfo = info
        files = fileList
        searches = searchList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processView.backgroundColor = Color.grey.lighten3
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.dataSource=self
        tableView.delegate=self
        tableView.backgroundColor = UIColor.white
        //self.tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        view.layout(processView).center().width(100).height(25)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func update(withFileList: [String], withInfo: [String:[String:[String:Int]]]){
        files = withFileList
        tableViewInfo = withInfo
        brutalPreProcess()
        self.tableView.reloadData()
    }
    
    func brutalPreProcess(){//not efficient at all, to be elimated
        for ic in (0..<files.count).reversed(){
            let i = files[ic]
            var isGood = false
            for j in searches{
                if tableViewInfo[i]![j]!["Occurance"] != 0{
                    isGood = true
                    break
                }
            }
            if !isGood{
                files.remove(at: ic)
                tableViewInfo.removeValue(forKey: i)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return files.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = files[indexPath.row]
        var detailStr = ""
        for j in searches{
            detailStr += j + "-" + String(describing: tableViewInfo[files[indexPath.row]]![j]!["Occurance"]!) + " "
        }
        cell!.detailTextLabel?.text = detailStr
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readerView = ViewController(txtPath: files[indexPath.row],searchInfo: tableViewInfo[files[indexPath.row]]!, searches: searches)
        self.navigationController?.pushViewController(readerView, animated: true)
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
