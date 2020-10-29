//
//  STLoginManager.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-27.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import FBSDKLoginKit

class STLoginManager {
    static let sharedInstance = STLoginManager()
    
    var currentSession: Session? {
        return self.fetchCurrentSession()
    }
    
    //MARK: - Core data fetches
    private func fetchCurrentSession() -> Session? {
        let newRequest: NSFetchRequest<Session> = Session.fetchRequest()

        do {
            return try mainContext.fetch(newRequest).first
        } catch {
            return nil
        }
    }
    
    //MARK: - Private
    private func deleteAllSessions() throws {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        
        let sessions = try mainContext.fetch(fetchRequest)
        for session in sessions {
            mainContext.delete(session)
        }
        
        try mainContext.save()
    }
    
    func disconnectUser() {
        do {
            try self.deleteAllSessions()
            LoginManager().logOut()
//            (UIApplication.shared.delegate as? AppDelegate)?.subscribeToNotificationTopic()
//            NotificationManager.sharedInstance.clearNotifications()
//            NotificationManager.sharedInstance.stopActivityNotificationsSubscription()
            ApolloClientManager.sharedInstance.updateWSPayload()
        } catch {}
    }

    
    func processLogin(phoneNumber: String? = nil, withCode code: String, completionHandler: @escaping (Bool) -> ()) {
//        var loginMetaData: UserMetadataInput? = nil
        
        let loginData: UserLoginInput
        if let phoneNumber = phoneNumber {
            loginData = UserLoginInput(phoneNumber: phoneNumber, loginType: .phonenumber)
        } else {
            loginData = UserLoginInput(loginType: .facebook)
        }
        
        let loginMutation: LoginMutation = .init(code: code, metadata: nil, loginData: loginData)

        apollo.perform(mutation: loginMutation) { result, error in
            guard let data = result?.data?.login, error == nil else { return completionHandler(false) }

            do {
                try self.deleteAllSessions()
                let user = data.user
                
                Session.createNewEntryWith(
                    id: data.sessionId,
                    userId: user.id,
                    userEmail: user.email,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    userImage: URL(string: user.imageUrl ?? "")
                )
                try? mainContext.save()

//                ApolloClientManager.sharedInstance.configureApolloClient()

                ApolloClientManager.sharedInstance.updateWSPayload()
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }
    
    func updateUserInfos(newEmail: String? = nil, newFirstName: String? = nil, newLastName: String? = nil, imageUrl: String? = nil, completionHandler: @escaping (Session?) -> ()) {
        let updateUserInput = UserUpdateInput(firstName: newFirstName, lastName: newLastName, email: newEmail, imageUrl: imageUrl)

        apollo.perform(mutation: UpdateUserMutation(userInput: updateUserInput)) { result, error in
            guard let user = result?.data?.updateUser else {
                completionHandler(nil)
                return
            }

            if let session = self.fetchCurrentSession() {
                session.userEmail = user.email
                session.userFirstName = user.firstName
                session.userLastName = user.lastName
                session.userImgUrl = URL(string: user.imageUrl ?? "")
                try? mainContext.save()
                completionHandler(session)
            } else {
                completionHandler(nil)
            }
        }
    }

    
    //MARK: - Phone login
    func authenticatePhoneNumber(phoneNumber: String, completionHandler: @escaping (Bool) -> ()) {
        apollo.perform(mutation: AuthenticateMutation(phone: phoneNumber)) { result, error in
            completionHandler(result?.data?.authenticate ?? false)
        }
    }
    
    func verifyPermissionScopes() {
        guard AccessToken.isCurrentAccessTokenActive, let current = AccessToken.current else { return }
        
//        if !current.hasGranted(.contains(.userFriends) && !current.declinedPermissions.contains(.userFriends) {
//            self.disconnectUser()
//        }
        
    }
}
