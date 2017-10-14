//
//  AuthWebController.swift
//  Gramophone
//
//  Copyright (c) 2017 Jared Verdi. All Rights Reserved
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Result
import WebKit

class OAuthWebController: UIViewController, WKNavigationDelegate {
    static let instagramAccessTokenParamName = "access_token"
    
    let url: URL
    let redirectURI: String
    let authenticationDidComplete: ((APIResult<String>) -> Swift.Void)
    
    let responseURIPrefix: String
    
    required init(url: URL, redirectURI: String, authenticationDidComplete: @escaping ((APIResult<String>) -> Swift.Void)) {
        self.url = url
        self.redirectURI = redirectURI.hasSuffix("/") ? redirectURI : "\(redirectURI)/"
        self.authenticationDidComplete = authenticationDidComplete
        
        self.responseURIPrefix = "\(self.redirectURI)#\(OAuthWebController.instagramAccessTokenParamName)="
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login to Instagram"
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(OAuthWebController.cancel))
        
        clearCaches()
        
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        webView.load(request)
    }
    
    func clearCaches() {
        let dataTypes: [String] = [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeLocalStorage]
        let websiteDataTypes = Set(dataTypes)
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler:{ })
        
        URLCache.shared.removeAllCachedResponses()
    }
    
    @objc public func cancel() {
        authenticationDidComplete(Result.failure(APIError.userCancelled))
    }
    
    // MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let URLString = navigationAction.request.url?.absoluteString {
            if URLString.hasPrefix(responseURIPrefix), let range = URLString.range(of: responseURIPrefix) {
                decisionHandler(.cancel)

                let startIndex = range.upperBound
                let accessToken = String(URLString[startIndex...])
                
                authenticationDidComplete(Result.success(APIResponse(data: accessToken)))
                return
            }
            else if URLString.hasPrefix(redirectURI) {
                decisionHandler(.allow)

                authenticationDidComplete(Result.failure(APIError.serverError))
                return
            }
        }
        
        decisionHandler(.allow)
    }
}
