//
//  ViewController2.swift
//  webviewTest
//
//  Created by Peter Young on 2023/01/10.
//

import UIKit
import WebKit

class ViewController2 : UIViewController,
                      WKNavigationDelegate,
                      WKUIDelegate,
                      WKScriptMessageHandler
{

    var webView: WKWebView! // 스토리보드의 웹뷰 연결한 아웃렛 변수
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // 웹뷰가 로드될 때 필요한 인디케이터

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let myBlog = "http://localhost:3000" // express 통해서 연 URL 링크
        let url = URL(string: myBlog) // URL 타입으로 변경
        let request = URLRequest(url: url!) // Request 준비
        
        let contentController = WKUserContentController() // js랑 통신해서 받아온 값 다룰 핸들러
        let config = WKWebViewConfiguration() // 웹 뷰를 스토리보드 형식으로 만들 시 사용 불가능. 하지만 알아두기
        
        // native -> js call (문서 시작시에만 가능한, 환경설정으로 사용함), source부분에 함수 대신 HTML직접 삽입 가능
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        // js -> native call : name의 값을 지정하여, js에서 webkit.messageHandlers.NAME.postMessage("");와 연동되는 것, userContentController함수에서 처리한다
        contentController.add(self, name: "callbackHandler")
        
        config.userContentController = contentController
        
        webView = WKWebView(frame: self.view.frame, configuration: config)
        
        self.view.addSubview(webView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // native -> js call page에 js를 주입하는 방법
//        webView.evaluateJavaScript("javascript:redHeader()", completionHandler: { msg, err in
//            print(msg)
//            print(err?.localizedDescription)
//        })
        webView.load(request) // 웹뷰를 로드해야지 사용할 수 있어.
    }
    
    
    // JS -> Native CALL
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        // message.name으로 판단한다.
        
        print("name: \(message.name)")
        
        if(message.name == "callbackHandler"){
            print(message.body)
            abc()
        }
    }
    
    func abc(){
        print("abc call")
    }
    
    // WebView가 로드가 끝난 시점에 호출하는 함수
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
        webView.evaluateJavaScript("javascript:redHeader()", completionHandler: { msg, err in
            print("msg: \(msg)")
            print("err : \(err?.localizedDescription)")
        })
    }
    
} // ViewController

