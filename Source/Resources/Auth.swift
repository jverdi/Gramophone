//
//  Auth.swift
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

extension Client.API {
    fileprivate enum Authentication: Resource {
        case authorize
        
        func uri() -> String {
            switch self {
            case .authorize:                        return "/oauth/authorize"
            }
        }
    }
}

extension Client {
    static let tokenResponseTypeValue = "token"
    
    public func authenticate(from presentingViewController: UIViewController, withCompletion completion: @escaping (APIResult<String>) -> Void) {
        guard let authenticationURL = authenticationURL() else {
            completion(Result.failure(APIError.invalidURL(path: "nil"))); return
        }
        
        let webController = OAuthWebController(url: authenticationURL, redirectURI: configuration.redirectURI) { result in
            
            if case .success(let apiResult) = result {
                self.accessToken = apiResult.data
            }

            presentingViewController.dismiss(animated: true) {
                completion(result)
            }
        }
        
        let navigationController = UINavigationController(rootViewController: webController)
        presentingViewController.present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func authenticationURL() -> URL? {
        var authenticationURLString = configuration.apiScheme + "://" + configuration.apiHost + API.Authentication.authorize.uri()
            + "/?\(Param.clientID.rawValue)=\(configuration.clientID)"
            + "&\(Param.redirectURI.rawValue)=\(configuration.redirectURI)"
            + "&\(Param.responseType.rawValue)=\(Client.tokenResponseTypeValue)"
        
        if configuration.scopes.count > 0 {
            let scopeString = configuration.scopes.map{ $0.rawValue }.joined(separator: Scope.separator)
            authenticationURLString += "&\(Param.scope)=\(scopeString)"
        }
        
        return URL(string: authenticationURLString)
    }
}

extension Client {
    public func isLoggedIn() -> Bool {
        return accessToken != nil
    }
    
    public func logout() {
        accessToken = nil
    }
    
    public func setAccessToken(_ token: String) {
        accessToken = token
    }
    
    func hasValidAccessToken(_ accessToken: String?) -> Bool {
        return accessToken != nil && accessToken!.characters.count > 0
    }
    
    func validateScopes(_ scopes: [Scope]) -> APIError? {
        let missingScopes = scopes.filter{ !self.configuration.scopes.contains($0) }
        if missingScopes.count > 0 {
            return APIError.missingScopes(scopes: missingScopes)
        }
        return nil
    }
}
