//
//  SecondViewController.swift
//  ValueInvesting
//
//  Created by Mario Perozo on 6/2/20.
//  Copyright © 2020 Mario Perozo. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var tickerSymbol: String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let address: String = "https://www.marketwatch.com/investing/stock/\(tickerSymbol!)";

        guard let url: URL = URL(string: address) else {
            print("Could not create URL from address \"\(address)\".");
            return;
        }

        guard let webPage: String = textFromURL(url: url) else {
            print("Received nothing from URL \"\(url)\".");
            return;
        }

        
        let pattern: String =
          "<h3 class=\"intraday__price \">"
        + "\\s*"
        + "<sup class=\"character\">\\$</sup>"
        + "\\s*"
        + "<bg-quote[^>]*>([^<]+)</bg-quote>"
        + "\\s*"
        + "</h3>";

        guard let regex: NSRegularExpression = try? NSRegularExpression(pattern: pattern) else {
            print("Could not create regular expression.");
            return;
        }

        let wholePage: NSRange = NSRange(webPage.startIndex..., in: webPage);
        guard let match: NSTextCheckingResult = regex.firstMatch(in: webPage, range: wholePage) else {
            print("Regular expression did not match.");
            return;
        }

        let nSRange: NSRange = match.range(at: 1);
        guard let range: Range<String.Index> = Range(nSRange, in: webPage) else {
            print("Could not convert NSRange to Range<String.Index>.");
            return;
        }

        let s: String = webPage[range].replacingOccurrences(of: ",", with: "");
        guard let price: Double = Double(s) else {
            print("price \(webPage[range]) was not a Double");
            return;
        }

        
        
        priceLabel.text = "The price of the stock is US$ \(price)";
    }
}

func textFromURL(url: URL) -> String? {
    let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
    var result: String? = nil;
    
    var request: URLRequest = URLRequest(url: url);

    let dictionary: [String: String] = [
        "Accept":           "*/*",
        "Accept-Encoding":  "gzip, deflate, br",
        "Accept-Language":  "en-US,en;q=0.9",
        "Connection":       "keep-alive",
        //"Content-Length": "331",
        "Content-Type":     "application/x-www-form-urlencoded; charset=UTF-8",
        //"Host":           "as-sec.casalemedia.com",
        "Origin":           "https://www.marketwatch.com",
        "Referer":          "\(url)",
        "Sec-Fetch_Dest":   "empty",
        "Sec-Fetch_Mode":   "cors",
        "User-Agent":       "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
    ];

    for (key, value): (String, String) in dictionary {
        request.addValue(value, forHTTPHeaderField: key);
    }

    let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
        
        if let error: Error = error { //I hope this if is false.
            print(error);
        }
        if let data: Data = data {    //I hope this if is true.
            result = String(data: data, encoding: String.Encoding.utf8);
        }
        semaphore.signal();   //Cause the semaphore's wait method to return.
    }
    
    task.resume();    //Try to download the web page into the Data object, then execute the closure.
    semaphore.wait(); //Wait here until the download and closure have finished executing.
    return result;    //Do this return after the closure has finished executing.
}
