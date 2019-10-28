//
//  WebViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 26/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    var to: String?
    var from: String?
    var fromCountry: String?
    var toCountry:String?
    var duration:Int?
    var date:Date?
    var webView: WKWebView!
    var airports=[Airport]()
    
    //This function is to load the webView
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    //this allows the data to be decode into a JSON file
    struct Airport: Decodable {
        let name:String
        let code:String
        let city:String
        let country:String
    }
    //this function is to fetch the data from a JSON file and generate URL using the data from it and load the web at last
    fileprivate func fetch(){
        let urlString="https://gist.githubusercontent.com/tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588/airports.json"
        guard let url=URL(string: urlString)else{return}
        URLSession.shared.dataTask(with: url){(data,_,error)in
            DispatchQueue.main.async {
                if error != nil{
                    return
                }
                guard let data=data else{return}
                
                do{
                    let decoder=JSONDecoder()
                    self.airports=try decoder.decode([Airport].self, from: data)
                }catch _{
                    print("error")
                }
                //generate url and load page here after read JSON file
                let url=self.generateUrl()
                self.webView.load(URLRequest(url: url))
            }
            }.resume()
    }
    //this function is to generate the url using the airport code to generate the url
    func generateUrl()->URL{
        //construct url content
        to=to?.lowercased()
        from=from?.lowercased()
        let place=from!+"-to-"+to!
        let subFrom = String( (from?.prefix(1))!).uppercased()
        let requestFrom=subFrom+String(((from?.suffix(from!.count-1))!))
        let subTo=String( (to?.prefix(1))!).uppercased()
        let requestTo=subTo+String(((to?.suffix(to!.count-1))!))
        var airportFrom=""
        var airportTo=""
        var findFrom=false
        var findTo=false
        //find the correct airport code
        for i in self.airports{
            if (i.city==requestFrom && i.country==fromCountry?.capitalized && !findFrom){
                airportFrom=i.code.lowercased()
                findFrom=true
            }
            if (i.city==requestTo && i.country==fromCountry?.capitalized && !findTo){
                airportTo=i.code.lowercased()
                findTo=true
            }
        }
        
        let subCity=airportFrom+"-"+airportTo
        
        let front="https://au.trip.com/flights/"+place+"/tickets-"+subCity
        let middle="/?flighttype=d&dcity="+airportFrom+"&acity="+airportTo
        var components=DateComponents()
        let calendar=Calendar(identifier: .gregorian)
        components.day = 3
        let returnDate=calendar.date(byAdding: components, to: date!)!
        let format=DateFormatter()
        format.dateFormat="yyyy-MM-dd"
        let goDate=format.string(from: date!)
        let backDate=format.string(from: returnDate)
        let end="&startdate="+goDate+"&returndate="+backDate+"&class=ys&quantity=1&searchboxarg=t"
        
        
        return (URL(string: front+middle+end)!)
    }
    
    //load data and webview
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        //add fresh button here, the solution was from an youtube video
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = from!+" to "+to!
    }

}
