//
//  ViewController.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NetworkService.shared.myFirstRequest{ (result) in
            
            switch result{
                
            case .success(let data):
                for item in data{
                    
                    let name = item.name ?? ""
                    
                }
            case .failure(let error):
                print("Error is: \(error.localizedDescription)")
            }
        }
    }


}

