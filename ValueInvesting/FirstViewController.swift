//
//  FirstViewController.swift
//  ValueInvesting
//
//  Created by Mario Perozo on 6/2/20.
//  Copyright © 2020 Mario Perozo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var globalPrice : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func returnButtonPressed(_ sender: UITextField) {
        
        sender.resignFirstResponder();
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        
        guard let secondViewController: SecondViewController = segue.destination as? SecondViewController else {
            print("Destination was not SecondViewController.");
            return;
        }
        
        guard let textField : UITextField = sender as? UITextField else {
            print("I should have been sent on my way by a UITextField");
            return;
        }
        
        secondViewController.tickerSymbol = textField.text;
    }
    
    
}
