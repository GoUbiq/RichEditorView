//
//  CritiqueManager.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-26.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation

class CritiqueManager {
    static let sharedInstance = CritiqueManager()
    
    func getHomeCritiques(completionHandler: @escaping ([Critique]?) -> ()) {
        apollo.fetch(query: HomeCritiqueQuery()) { result, error in
            guard let result = result?.data?.critiques.edges else { return completionHandler(nil) }
            completionHandler(result.map({ .init(critique: $0.node.fragments.graphQlCritique) }))
        }
    }
    
    func createCritique(title: String, descriptionHTML: String, mediaUrls: [String], defaultMediaUrl: String, completionHandler: @escaping (Critique?) -> ()) {
        let input: CritiqueCreateInput = .init(title: title, descriptionHtml: descriptionHTML, style: .review, mediaUrls: mediaUrls, defaultMediaUrl: defaultMediaUrl, tags: [], categories: [])
        apollo.perform(mutation: CreateCritiqueMutation(input: input)) { result, error in
            guard let result = result?.data?.createCritique.fragments.graphQlCritique else { return completionHandler(nil) }
            completionHandler(.init(critique: result))
        }
    }
    
    //MARK: - Comment
    
    func postComment(critiqueId: String, text: String, completionHandler: @escaping (Comment?) -> ()) {
        let mutation: PostCommentMutation = .init(input: .init(body: text, associatedCritiqueId: critiqueId))
        apollo.perform(mutation: mutation) { result, error in
            guard let result = result?.data?.addComment?.fragments.graphQlComment else { return completionHandler(nil) }
            completionHandler(.init(comment: result))
        }
    }
}
