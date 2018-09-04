//
//  txtReader.swift
//  test
//
//  Created by ML on 8/31/18.
//  Copyright © 2018 ML. All rights reserved.
//

import UIKit

class txtReader: NSObject {
    private let txtPath:String
    private var content:String = ""
    
    init(path: String) {
        txtPath = NSHomeDirectory() + "/Documents" + "/" + path
        super.init()
        //content = loadTxt(from: txtPath)
    }
    
    private func loadTxt() -> String{
        if let tData = NSData(contentsOfFile: txtPath){
            let txtData:String = (NSString(data: tData as Data, encoding: String.Encoding.utf8.rawValue))! as String
            //print(String(bytes: a, encoding: String.Encoding.utf8))
            //print(a)
            return txtData
        }
        return ""
    }
    
    public func utf8()->[UInt8]{
        let utf8Text:[UInt8] = Array(content.utf8)
        return utf8Text
    }
    
    public func fixWindowsEnterSign() -> NSString?{
        if let tData = NSData(contentsOfFile: txtPath){
            let txtData:String = (NSString(data: tData as Data, encoding: String.Encoding.utf8.rawValue))! as String
            self.content = txtData
            for i in utf8(){
                return nil
            }
        }
        return nil
    }

    public func nsOrig() -> NSString?{
        var txtContent:NSString
        do {
            txtContent = try NSString(contentsOfFile: txtPath, encoding: String.Encoding.utf8.rawValue)
            txtContent = txtContent.replacingOccurrences(of: "\r\n", with: "\n") as NSString
            //print(txtContent)
        } catch {
            return nil
        }
        //print(txtContent.range(of: "a", options: .widthInsensitive))
        //let a = UITextView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        //a.scrollRangeToVisible(nsOrig()!.range(of: "大", options: .widthInsensitive))
        return txtContent
    }
    
    public func search (forText: [String]) -> [String:[String:Int]]{
        var result = [String:[String:Int]]()
        let txt = loadTxt()
        for searchTarget in forText{
            result[searchTarget] = self.kmpMatcher(T: txt, P: searchTarget)
        }
        //print(result)
        return result
    }
    
    private func kmpMatcher(T:String, P:String) -> [String:Int]{
        //print("))startMatch\(P)")
        var result = [String:Int]()
        var occurance = 0
        let stringArr = Array(T)
        let patternArr = Array(P)
        let n = stringArr.count
        let m = patternArr.count
        //print(m,n)
        let pi = computePrefixFunction(pattern: P)
        var q = 0
        for i in 1...n{
            while(q>0 && patternArr[q] != stringArr[i-1]){
                q = pi[q]
            }
            if patternArr[q] == stringArr[i-1]{
                q += 1
            }
            if q == m{
                occurance += 1
                result["Position\(occurance)"] = i-m
                q = pi[q]
            }
        }
        result["Occurance"] = occurance
        //print("))endMatch\(P)")
        return result
    }
    
    private func computePrefixFunction(pattern:String) -> [Int]{
        let patternArr = Array(pattern)
        let m = patternArr.count
        var result = [Int](repeating: 0, count: m+1)
        var k = 0
        if m < 2{
            return result
        }
        for q in 2...m{
            while (k>0 && patternArr[k] != patternArr[q-1]){
                k = result[k]
            }
            if patternArr[k] == patternArr[q-1]{
                k += 1
            }
            result[q] = k
        }
        //print(result)
        return result
    }
}
