//
//  ApolloClientManager.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-02.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import ApolloWebSocket
import ApolloCore
import Apollo

var apollo: ApolloClientManager {
    return ApolloClientManager.sharedInstance
}

class ApolloClientManager {
    static let sharedInstance = ApolloClientManager()
    
    fileprivate var loginManager: STLoginManager {
        return STLoginManager.sharedInstance
    }
    
    private lazy var apolloClient: ApolloClient = ApolloClient(networkTransport: self.splitNetworkTransport)
    
    private lazy var networkTransport: HTTPNetworkTransport = {
        let client = URLSessionClient(sessionConfiguration: .default)
        let transport = HTTPNetworkTransport(url: URL(string: userDefaults.string(forKey: apiAccessHostUrl)!)!, client: client)
        transport.delegate = self
        return transport
    }()
    
    private lazy var webSocketTransport: WebSocketTransport = {
        let url = URL(string: userDefaults.string(forKey: webSocketUrl)!)!
        let request = URLRequest(url: url)
        
        var headers = [String: String]()
        // Add any new headers you need
        headers["X-Session"] = "0185d03a-141f-46e4-8816-3f8adc86a664"//self.loginManager.currentSession?.id ?? ""
        headers["X-App-Version"] = "\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")"
        
        let transport = WebSocketTransport(request: request, connectingPayload: headers)
        transport.delegate = self
    
        return transport
    }()
    
    
    
    private lazy var splitNetworkTransport = SplitNetworkTransport(
        httpNetworkTransport: self.networkTransport,
        webSocketNetworkTransport: self.webSocketTransport
    )
    
    private func checkAthenticationError(error: GraphQLError?) {
        guard let error = error, let code = error.extensions?["code"] as? String, code == "UNAUTHENTICATED" else { return }
        DispatchQueue.main.async {
//            STLoginManager.sharedInstance.disconnectUser()
        }
    }
    
    func fetch<Query: GraphQLQuery>(query: Query, cachePolicy: CachePolicy = .fetchIgnoringCacheData, queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), resultHandler: ((GraphQLResult<Query.Data>?, Error?) -> ())? = nil) {
        self.apolloClient.fetch(query: query, cachePolicy: cachePolicy, queue: queue) { result in
            var ferror: Error?
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    ferror = result.errors?.first
                    resultHandler?(result, ferror)
                case .failure(let error):
                    ferror = error
                    resultHandler?(nil, ferror)
                }
                
                print("Query \n ---------- \n\(query.operationDefinition)")
                print("error \n ---------- \n\(ferror?.localizedDescription ?? "None")")
                if let error = ferror {
                    self.checkAthenticationError(error: error as? GraphQLError)
//                    let error = NSError(domain: "Network issue - Query", code: 1337, userInfo: ["Error": error.localizedDescription, "operation": query.operationDefinition])
//                    Crashlytics.sharedInstance().recordError(error)
                }
            }
        }
    }
    
    func perform<Mutation: GraphQLMutation>(mutation: Mutation, queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), resultHandler: ((GraphQLResult<Mutation.Data>?, Error?) -> ())? = nil) {
        self.apolloClient.perform(mutation: mutation, queue: queue) { result in
            var ferror: Error?
            
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    ferror = result.errors?.first
                    resultHandler?(result, ferror)
                case .failure(let error):
                    ferror = error
                    resultHandler?(nil, ferror)
                }
                
                print("Mutation \n ---------- \n\(mutation.operationDefinition)")
                print("error \n ---------- \n\(ferror?.localizedDescription ?? "None")")
                if let error: Error = ferror {
                    self.checkAthenticationError(error: error as? GraphQLError)
//                    let error = NSError(domain: "Network issue - Mutation", code: 1337, userInfo: ["Error": error.localizedDescription, "operation": mutation.operationDefinition])
//                    Crashlytics.sharedInstance().recordError(error)
                }
            }
        }
    }
    
    @discardableResult func subscribe<Subscription: GraphQLSubscription>(subscription: Subscription, queue: DispatchQueue = DispatchQueue.main, resultHandler: ((GraphQLResult<Subscription.Data>?, Error?) -> ())? = nil) -> Cancellable {
        return self.apolloClient.subscribe(subscription: subscription, queue: queue) { result in
            print("Start subscription \(subscription.operationDefinition)")
            
            var ferror: Error?
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    ferror = result.errors?.first
                    resultHandler?(result, ferror)
                case .failure(let error):
                    ferror = error
                    resultHandler?(nil, ferror)
                }
                
                if let error = ferror {
                    self.checkAthenticationError(error: error as? GraphQLError)
//                    let error = NSError(domain: "Network issue - Subscription", code: 1337, userInfo: ["Error": error.localizedDescription, "operation": subscription.operationDefinition])
//                    Crashlytics.sharedInstance().recordError(error)
                }
            }
        }
    }
    
    func updateWSPayload() {
        var headers = [String: String]()
        // Add any new headers you need
        headers["X-Session"] = self.loginManager.currentSession?.id ?? ""
        headers["X-App-Version"] = "\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")"
        
        self.webSocketTransport.updateConnectingPayload(headers)
    }
}

extension ApolloClientManager: HTTPNetworkTransportPreflightDelegate {
    public func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        // If there's an authenticated user, send the request. If not, don't.
        return true
    }
    
    public func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        
        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        
        // Add any new headers you need
        headers["X-Session"] = self.loginManager.currentSession?.id ?? ""
        headers["X-App-Version"] = "\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")"
        
        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
        
        print("Outgoing request: \(request)")
    }
}

extension ApolloClientManager: HTTPNetworkTransportTaskCompletedDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          didCompleteRawTaskForRequest request: URLRequest,
                          withData data: Data?,
                          response: URLResponse?,
                          error: Error?) {
        //        print("Raw task completed for request: \(request)")
        //        print("Raw task ended \(Date().timeIntervalSince1970)")
        //        print(error)
        
        //        if let error = error {
        //            print("Error: \(error)")
        //        }
        //
        //        if let response = response {
        //            print("Response: \(response)")
        //        } else {
        //            print("No URL Response received!")
        //        }
        //
        //        if let data = data {
        //            print("Data: \(String(describing: String(bytes: data, encoding: .utf8)))")
        //        } else {
        //            print("No data received!")
        //        }
    }
}

extension ApolloClientManager: WebSocketTransportDelegate {

    func webSocketTransportDidConnect(_ webSocketTransport: WebSocketTransport) {
        print("connected")
    }
    
    func webSocketTransportDidReconnect(_ webSocketTransport: WebSocketTransport) {
        print("reconnect")
    }
    
    func webSocketTransport(_ webSocketTransport: WebSocketTransport, didDisconnectWithError error: Error?) {
        print("DISCONNECTED WITH \(error.debugDescription)")
    }
}

