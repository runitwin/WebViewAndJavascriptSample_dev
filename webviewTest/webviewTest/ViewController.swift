//
//  ViewController.swift
//  webviewTest
//
//  Created by Peter Young on 2023/01/10.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView?
    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//
//        print(message.body)
//        let date = Date()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.messageToWebview(msg: "hello, I got your messsage: \(message.body) at \(date)")
//        }
//    }
//
//    func messageToWebview(msg: String) {
//        self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
//    }
    
    func GetLocationValue()
    {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "GDApp")//bridge
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: configuration)
                            
        webView?.navigationDelegate = self
        
        guard let path: String = Bundle.main.path(forResource: "index", ofType: "html") else { return }
        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
        
        
//        webView?.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
        
        webView?.load(URLRequest(url: URL(string: "https://kgds.kdrco.net/gdui/Shop/main.aspx?revphoneno=15551234567")!))//?revphoneno=15551234567
        
        self.view.addSubview(webView!)
        */
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webViewInit()
    }
    
    func webViewInit(){
        
        WKWebsiteDataStore.default().removeData(ofTypes:
        [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache],
        modifiedSince: Date(timeIntervalSince1970: 0)) {
        }
        
        
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "printToastMsg")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.preferences.javaScriptEnabled = true
        
        webView = WKWebView(frame: self.view.frame, configuration: configuration)
        
        webView?.uiDelegate = self
        
        
//        webView?.configuration.userContentController = userContentController
        
//        webView?.configuration.preferences.javaScriptEnabled = true
//        webView?.allowsBackForwardNavigationGestures = true
        
        
        
        
        
        if let url = URL(string: "https://kgds.kdrco.net/gdui/Shop/main2.aspx?revphoneno=15551234567") {//https://m.officecheckin.com
            let request = URLRequest(url: url)
            
            webView = WKWebView(frame: self.view.frame)
            
            
            webView?.load(request)
            
            
            
            self.view.addSubview(webView!)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                self.webView?.evaluateJavaScript("webkit.messageHandlers.GDApp.fnAppDelAddrCheck()")//javascript:fnAppDelAddrCheck();
                
                //webkit.messageHandlers.bridge.onMessage('FromNativetoJS')
            }
            
            
            
            //String webScript = "javascript:setLocationValue(" + strLatitude[0] + ", " + strLongitude[0] + ");";
        }
            
    }
    
}

extension ViewController: WKUIDelegate{
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default) { (action) in
            completionHandler(false)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if let text = alert.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("didReceive: \(message.name)")
        
        if(message.name == "locationSearch"){
            
            let data:[String:String] = message.body as! Dictionary
            //location Event
            //data["action"] = searchLocation
            
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
        webView.evaluateJavaScript("javascript:redHeader()", completionHandler: { msg, err in
            print("msg: \(msg)")
            print("err : \(err?.localizedDescription)")
        })
    }
    
}
