//
//  ViewController.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var trend: Trend?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        readJsonFromFile(fileName: "trend_2201")
        
        print(trend?.root.bp)
        
    }

    func readJsonFromFile(fileName: String) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
            
                let fileUrl = URL(fileURLWithPath: path)
            
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            
                trend = try JSONDecoder().decode(Trend.self, from: data)
                
            } catch {
            
                print("unable to find json data")
                
            }
        
        }

    }
}

