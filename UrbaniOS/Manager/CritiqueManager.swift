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
    
    func getHomeCritiques(after: String? = nil, completionHandler: @escaping ([Critique]?, Bool) -> ()) {
        apollo.fetch(query: HomeCritiqueQuery(after: after)) { result, error in
            guard let result = result?.data?.critiques else { return completionHandler(nil, false) }
            completionHandler(result.edges.map({ .init(critique: $0.node.fragments.graphQlCritique) }), result.pageInfo.hasNextPage)
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
    
    func likeComment(commentId: String, completionHandler: @escaping (Comment?) -> ()) {
        apollo.perform(mutation: LikeCommentMutation(id: commentId)) { result, error in
            guard let result = result?.data?.likeComment?.fragments.graphQlComment else { return completionHandler(nil) }
            completionHandler(.init(comment: result))
        }
    }
    
    func unlikeComment(commentId: String, completionHandler: @escaping (Comment?) -> ()) {
        apollo.perform(mutation: UnlikeCommentMutation(id: commentId)) { result, error in
            guard let result = result?.data?.unlikeComment?.fragments.graphQlComment else { return completionHandler(nil) }
            completionHandler(.init(comment: result))
        }
    }
}
