// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct CritiqueCreateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - title
  ///   - descriptionHtml
  ///   - style
  ///   - mediaUrls
  ///   - defaultMediaUrl
  ///   - tags
  ///   - categories
  public init(title: String, descriptionHtml: String, style: CritiqueStyle, mediaUrls: [String], defaultMediaUrl: String, tags: Swift.Optional<[TagCreateInput]?> = nil, categories: [String]) {
    graphQLMap = ["title": title, "descriptionHtml": descriptionHtml, "style": style, "mediaUrls": mediaUrls, "defaultMediaUrl": defaultMediaUrl, "tags": tags, "categories": categories]
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var descriptionHtml: String {
    get {
      return graphQLMap["descriptionHtml"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "descriptionHtml")
    }
  }

  public var style: CritiqueStyle {
    get {
      return graphQLMap["style"] as! CritiqueStyle
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "style")
    }
  }

  public var mediaUrls: [String] {
    get {
      return graphQLMap["mediaUrls"] as! [String]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mediaUrls")
    }
  }

  public var defaultMediaUrl: String {
    get {
      return graphQLMap["defaultMediaUrl"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "defaultMediaUrl")
    }
  }

  public var tags: Swift.Optional<[TagCreateInput]?> {
    get {
      return graphQLMap["tags"] as? Swift.Optional<[TagCreateInput]?> ?? Swift.Optional<[TagCreateInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tags")
    }
  }

  public var categories: [String] {
    get {
      return graphQLMap["categories"] as! [String]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "categories")
    }
  }
}

public enum CritiqueStyle: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case guide
  case review
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "GUIDE": self = .guide
      case "REVIEW": self = .review
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .guide: return "GUIDE"
      case .review: return "REVIEW"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CritiqueStyle, rhs: CritiqueStyle) -> Bool {
    switch (lhs, rhs) {
      case (.guide, .guide): return true
      case (.review, .review): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CritiqueStyle] {
    return [
      .guide,
      .review,
    ]
  }
}

public struct TagCreateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - rating
  ///   - mediaUrl
  ///   - productId
  ///   - positionX
  ///   - positionY
  public init(rating: Int, mediaUrl: Swift.Optional<String?> = nil, productId: GraphQLID, positionX: Swift.Optional<Double?> = nil, positionY: Swift.Optional<Double?> = nil) {
    graphQLMap = ["rating": rating, "mediaUrl": mediaUrl, "productId": productId, "positionX": positionX, "positionY": positionY]
  }

  public var rating: Int {
    get {
      return graphQLMap["rating"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "rating")
    }
  }

  public var mediaUrl: Swift.Optional<String?> {
    get {
      return graphQLMap["mediaUrl"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mediaUrl")
    }
  }

  public var productId: GraphQLID {
    get {
      return graphQLMap["productId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "productId")
    }
  }

  public var positionX: Swift.Optional<Double?> {
    get {
      return graphQLMap["positionX"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "positionX")
    }
  }

  public var positionY: Swift.Optional<Double?> {
    get {
      return graphQLMap["positionY"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "positionY")
    }
  }
}

public struct UserMetadataInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - influencerId
  public init(influencerId: GraphQLID) {
    graphQLMap = ["influencerId": influencerId]
  }

  public var influencerId: GraphQLID {
    get {
      return graphQLMap["influencerId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "influencerId")
    }
  }
}

public struct UserLoginInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - phoneNumber
  ///   - appleUserId
  ///   - loginType
  public init(phoneNumber: Swift.Optional<String?> = nil, appleUserId: Swift.Optional<String?> = nil, loginType: LoginType) {
    graphQLMap = ["phoneNumber": phoneNumber, "appleUserId": appleUserId, "loginType": loginType]
  }

  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phoneNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var appleUserId: Swift.Optional<String?> {
    get {
      return graphQLMap["appleUserId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "appleUserId")
    }
  }

  public var loginType: LoginType {
    get {
      return graphQLMap["loginType"] as! LoginType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loginType")
    }
  }
}

public enum LoginType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case facebook
  case phonenumber
  case appleid
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "FACEBOOK": self = .facebook
      case "PHONENUMBER": self = .phonenumber
      case "APPLEID": self = .appleid
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .facebook: return "FACEBOOK"
      case .phonenumber: return "PHONENUMBER"
      case .appleid: return "APPLEID"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LoginType, rhs: LoginType) -> Bool {
    switch (lhs, rhs) {
      case (.facebook, .facebook): return true
      case (.phonenumber, .phonenumber): return true
      case (.appleid, .appleid): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LoginType] {
    return [
      .facebook,
      .phonenumber,
      .appleid,
    ]
  }
}

public struct PresignedUrlInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - type
  ///   - fileType
  public init(type: MediaType, fileType: MediaFileExtension) {
    graphQLMap = ["type": type, "fileType": fileType]
  }

  public var type: MediaType {
    get {
      return graphQLMap["type"] as! MediaType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var fileType: MediaFileExtension {
    get {
      return graphQLMap["fileType"] as! MediaFileExtension
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fileType")
    }
  }
}

public enum MediaType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case image
  case video
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "IMAGE": self = .image
      case "VIDEO": self = .video
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .image: return "IMAGE"
      case .video: return "VIDEO"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: MediaType, rhs: MediaType) -> Bool {
    switch (lhs, rhs) {
      case (.image, .image): return true
      case (.video, .video): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [MediaType] {
    return [
      .image,
      .video,
    ]
  }
}

public enum MediaFileExtension: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case mp4
  case mov
  case jpeg
  case png
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "mp4": self = .mp4
      case "mov": self = .mov
      case "jpeg": self = .jpeg
      case "png": self = .png
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .mp4: return "mp4"
      case .mov: return "mov"
      case .jpeg: return "jpeg"
      case .png: return "png"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: MediaFileExtension, rhs: MediaFileExtension) -> Bool {
    switch (lhs, rhs) {
      case (.mp4, .mp4): return true
      case (.mov, .mov): return true
      case (.jpeg, .jpeg): return true
      case (.png, .png): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [MediaFileExtension] {
    return [
      .mp4,
      .mov,
      .jpeg,
      .png,
    ]
  }
}

public final class HomeCritiqueQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query HomeCritique($after: ID) {
      critiques(first: 10, after: $after) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...GraphQLCritique
          }
        }
      }
    }
    """

  public let operationName: String = "HomeCritique"

  public var queryDocument: String { return operationDefinition.appending("\n" + GraphQlCritique.fragmentDefinition).appending("\n" + GraphQlUser.fragmentDefinition).appending("\n" + GraphQlMedia.fragmentDefinition) }

  public var after: GraphQLID?

  public init(after: GraphQLID? = nil) {
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryRoot"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("critiques", arguments: ["first": 10, "after": GraphQLVariable("after")], type: .nonNull(.object(Critique.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(critiques: Critique) {
      self.init(unsafeResultMap: ["__typename": "QueryRoot", "critiques": critiques.resultMap])
    }

    public var critiques: Critique {
      get {
        return Critique(unsafeResultMap: resultMap["critiques"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "critiques")
      }
    }

    public struct Critique: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CritiqueConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge]) {
        self.init(unsafeResultMap: ["__typename": "CritiqueConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge] {
        get {
          return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CritiqueEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .nonNull(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node) {
          self.init(unsafeResultMap: ["__typename": "CritiqueEdge", "node": node.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var node: Node {
          get {
            return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Critique"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(GraphQlCritique.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var graphQlCritique: GraphQlCritique {
              get {
                return GraphQlCritique(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public final class CreateCritiqueMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateCritique($input: CritiqueCreateInput!) {
      createCritique(input: $input) {
        __typename
        ...GraphQLCritique
      }
    }
    """

  public let operationName: String = "CreateCritique"

  public var queryDocument: String { return operationDefinition.appending("\n" + GraphQlCritique.fragmentDefinition).appending("\n" + GraphQlUser.fragmentDefinition).appending("\n" + GraphQlMedia.fragmentDefinition) }

  public var input: CritiqueCreateInput

  public init(input: CritiqueCreateInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createCritique", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateCritique.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createCritique: CreateCritique) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createCritique": createCritique.resultMap])
    }

    public var createCritique: CreateCritique {
      get {
        return CreateCritique(unsafeResultMap: resultMap["createCritique"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createCritique")
      }
    }

    public struct CreateCritique: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Critique"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GraphQlCritique.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var graphQlCritique: GraphQlCritique {
          get {
            return GraphQlCritique(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Login($code: String!, $metadata: UserMetadataInput, $loginData: UserLoginInput) {
      login(code: $code, metadata: $metadata, loginData: $loginData) {
        __typename
        sessionId
        user {
          __typename
          id
          firstName
          lastName
          imageUrl
          email
        }
      }
    }
    """

  public let operationName: String = "Login"

  public var code: String
  public var metadata: UserMetadataInput?
  public var loginData: UserLoginInput?

  public init(code: String, metadata: UserMetadataInput? = nil, loginData: UserLoginInput? = nil) {
    self.code = code
    self.metadata = metadata
    self.loginData = loginData
  }

  public var variables: GraphQLMap? {
    return ["code": code, "metadata": metadata, "loginData": loginData]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("login", arguments: ["code": GraphQLVariable("code"), "metadata": GraphQLVariable("metadata"), "loginData": GraphQLVariable("loginData")], type: .object(Login.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login.flatMap { (value: Login) -> ResultMap in value.resultMap }])
    }

    /// _Arguments_
    /// - **code**: String
    public var login: Login? {
      get {
        return (resultMap["login"] as? ResultMap).flatMap { Login(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserSession"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("sessionId", type: .nonNull(.scalar(String.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sessionId: String, user: User) {
        self.init(unsafeResultMap: ["__typename": "UserSession", "sessionId": sessionId, "user": user.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var sessionId: String {
        get {
          return resultMap["sessionId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "sessionId")
        }
      }

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
            GraphQLField("imageUrl", type: .scalar(String.self)),
            GraphQLField("email", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, imageUrl: String? = nil, email: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "firstName": firstName, "lastName": lastName, "imageUrl": imageUrl, "email": email])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return resultMap["firstName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return resultMap["lastName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastName")
          }
        }

        public var imageUrl: String? {
          get {
            return resultMap["imageUrl"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "imageUrl")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }
      }
    }
  }
}

public final class PresignedUrlQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PresignedUrl($input: PresignedUrlInput!) {
      presignedUrl(input: $input) {
        __typename
        newUrl
        presignedUrl
      }
    }
    """

  public let operationName: String = "PresignedUrl"

  public var input: PresignedUrlInput

  public init(input: PresignedUrlInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryRoot"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("presignedUrl", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(PresignedUrl.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(presignedUrl: PresignedUrl) {
      self.init(unsafeResultMap: ["__typename": "QueryRoot", "presignedUrl": presignedUrl.resultMap])
    }

    public var presignedUrl: PresignedUrl {
      get {
        return PresignedUrl(unsafeResultMap: resultMap["presignedUrl"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "presignedUrl")
      }
    }

    public struct PresignedUrl: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PresignedUrl"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("newUrl", type: .scalar(String.self)),
          GraphQLField("presignedUrl", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(newUrl: String? = nil, presignedUrl: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "PresignedUrl", "newUrl": newUrl, "presignedUrl": presignedUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var newUrl: String? {
        get {
          return resultMap["newUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "newUrl")
        }
      }

      public var presignedUrl: String? {
        get {
          return resultMap["presignedUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "presignedUrl")
        }
      }
    }
  }
}

public final class SearchForProdTitlesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query searchForProdTitles($query: String!, $first: Int!) {
      searchForProdTitles(query: $query, first: $first) {
        __typename
        feedItems {
          __typename
          ...GraphQLProduct
        }
      }
    }
    """

  public let operationName: String = "searchForProdTitles"

  public var queryDocument: String { return operationDefinition.appending("\n" + GraphQlProduct.fragmentDefinition) }

  public var query: String
  public var first: Int

  public init(query: String, first: Int) {
    self.query = query
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["query": query, "first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryRoot"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("searchForProdTitles", arguments: ["query": GraphQLVariable("query"), "first": GraphQLVariable("first")], type: .object(SearchForProdTitle.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(searchForProdTitles: SearchForProdTitle? = nil) {
      self.init(unsafeResultMap: ["__typename": "QueryRoot", "searchForProdTitles": searchForProdTitles.flatMap { (value: SearchForProdTitle) -> ResultMap in value.resultMap }])
    }

    public var searchForProdTitles: SearchForProdTitle? {
      get {
        return (resultMap["searchForProdTitles"] as? ResultMap).flatMap { SearchForProdTitle(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "searchForProdTitles")
      }
    }

    public struct SearchForProdTitle: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResults"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("feedItems", type: .nonNull(.list(.nonNull(.object(FeedItem.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(feedItems: [FeedItem]) {
        self.init(unsafeResultMap: ["__typename": "SearchResults", "feedItems": feedItems.map { (value: FeedItem) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var feedItems: [FeedItem] {
        get {
          return (resultMap["feedItems"] as! [ResultMap]).map { (value: ResultMap) -> FeedItem in FeedItem(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: FeedItem) -> ResultMap in value.resultMap }, forKey: "feedItems")
        }
      }

      public struct FeedItem: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(GraphQlProduct.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var graphQlProduct: GraphQlProduct {
            get {
              return GraphQlProduct(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ProductsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Products($first: Int!) {
      products(first: $first) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...GraphQLProduct
          }
        }
      }
    }
    """

  public let operationName: String = "Products"

  public var queryDocument: String { return operationDefinition.appending("\n" + GraphQlProduct.fragmentDefinition) }

  public var first: Int

  public init(first: Int) {
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryRoot"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("products", arguments: ["first": GraphQLVariable("first")], type: .nonNull(.object(Product.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(products: Product) {
      self.init(unsafeResultMap: ["__typename": "QueryRoot", "products": products.resultMap])
    }

    public var products: Product {
      get {
        return Product(unsafeResultMap: resultMap["products"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "products")
      }
    }

    public struct Product: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ProductConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge]) {
        self.init(unsafeResultMap: ["__typename": "ProductConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge] {
        get {
          return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ProductEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .nonNull(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node) {
          self.init(unsafeResultMap: ["__typename": "ProductEdge", "node": node.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var node: Node {
          get {
            return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(GraphQlProduct.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var graphQlProduct: GraphQlProduct {
              get {
                return GraphQlProduct(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public struct GraphQlProduct: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment GraphQLProduct on Product {
      __typename
      id
      title
      affiliateUrl
      tags {
        __typename
        id
      }
    }
    """

  public static let possibleTypes: [String] = ["Product"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("affiliateUrl", type: .nonNull(.scalar(String.self))),
      GraphQLField("tags", type: .nonNull(.list(.nonNull(.object(Tag.selections))))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, title: String, affiliateUrl: String, tags: [Tag]) {
    self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "affiliateUrl": affiliateUrl, "tags": tags.map { (value: Tag) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String {
    get {
      return resultMap["title"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  public var affiliateUrl: String {
    get {
      return resultMap["affiliateUrl"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "affiliateUrl")
    }
  }

  public var tags: [Tag] {
    get {
      return (resultMap["tags"] as! [ResultMap]).map { (value: ResultMap) -> Tag in Tag(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Tag) -> ResultMap in value.resultMap }, forKey: "tags")
    }
  }

  public struct Tag: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Tag"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Tag", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }
}

public struct GraphQlMedia: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment GraphQLMedia on Media {
      __typename
      id
      position
      srcUrl
      width
      height
      mediaType
    }
    """

  public static let possibleTypes: [String] = ["Media"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("position", type: .scalar(Int.self)),
      GraphQLField("srcUrl", type: .nonNull(.scalar(String.self))),
      GraphQLField("width", type: .nonNull(.scalar(Double.self))),
      GraphQLField("height", type: .nonNull(.scalar(Double.self))),
      GraphQLField("mediaType", type: .nonNull(.scalar(MediaType.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, position: Int? = nil, srcUrl: String, width: Double, height: Double, mediaType: MediaType) {
    self.init(unsafeResultMap: ["__typename": "Media", "id": id, "position": position, "srcUrl": srcUrl, "width": width, "height": height, "mediaType": mediaType])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var position: Int? {
    get {
      return resultMap["position"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "position")
    }
  }

  public var srcUrl: String {
    get {
      return resultMap["srcUrl"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "srcUrl")
    }
  }

  public var width: Double {
    get {
      return resultMap["width"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "width")
    }
  }

  public var height: Double {
    get {
      return resultMap["height"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "height")
    }
  }

  public var mediaType: MediaType {
    get {
      return resultMap["mediaType"]! as! MediaType
    }
    set {
      resultMap.updateValue(newValue, forKey: "mediaType")
    }
  }
}

public struct GraphQlUser: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment GraphQLUser on User {
      __typename
      id
      imageUrl
      name
      description
    }
    """

  public static let possibleTypes: [String] = ["User"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("imageUrl", type: .scalar(String.self)),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("description", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, imageUrl: String? = nil, name: String? = nil, description: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "User", "id": id, "imageUrl": imageUrl, "name": name, "description": description])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var imageUrl: String? {
    get {
      return resultMap["imageUrl"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "imageUrl")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }
}

public struct GraphQlComment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment GraphQLComment on Comment {
      __typename
      id
      body
      likeCount
      userHasLiked
      author {
        __typename
        ...GraphQLUser
      }
      createdAt
    }
    """

  public static let possibleTypes: [String] = ["Comment"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("body", type: .nonNull(.scalar(String.self))),
      GraphQLField("likeCount", type: .nonNull(.scalar(String.self))),
      GraphQLField("userHasLiked", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("author", type: .nonNull(.object(Author.selections))),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, body: String, likeCount: String, userHasLiked: Bool, author: Author, createdAt: String) {
    self.init(unsafeResultMap: ["__typename": "Comment", "id": id, "body": body, "likeCount": likeCount, "userHasLiked": userHasLiked, "author": author.resultMap, "createdAt": createdAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var body: String {
    get {
      return resultMap["body"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "body")
    }
  }

  public var likeCount: String {
    get {
      return resultMap["likeCount"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "likeCount")
    }
  }

  public var userHasLiked: Bool {
    get {
      return resultMap["userHasLiked"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "userHasLiked")
    }
  }

  public var author: Author {
    get {
      return Author(unsafeResultMap: resultMap["author"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "author")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(GraphQlUser.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, imageUrl: String? = nil, name: String? = nil, description: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "imageUrl": imageUrl, "name": name, "description": description])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var graphQlUser: GraphQlUser {
        get {
          return GraphQlUser(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct GraphQlCritique: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment GraphQLCritique on Critique {
      __typename
      id
      title
      shortdescription
      descriptionHtml
      author {
        __typename
        ...GraphQLUser
      }
      media {
        __typename
        ...GraphQLMedia
      }
      defaultMedia {
        __typename
        ...GraphQLMedia
      }
      createdAt
    }
    """

  public static let possibleTypes: [String] = ["Critique"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("shortdescription", type: .scalar(String.self)),
      GraphQLField("descriptionHtml", type: .nonNull(.scalar(String.self))),
      GraphQLField("author", type: .nonNull(.object(Author.selections))),
      GraphQLField("media", type: .nonNull(.list(.nonNull(.object(Medium.selections))))),
      GraphQLField("defaultMedia", type: .nonNull(.object(DefaultMedium.selections))),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, title: String, shortdescription: String? = nil, descriptionHtml: String, author: Author, media: [Medium], defaultMedia: DefaultMedium, createdAt: String) {
    self.init(unsafeResultMap: ["__typename": "Critique", "id": id, "title": title, "shortdescription": shortdescription, "descriptionHtml": descriptionHtml, "author": author.resultMap, "media": media.map { (value: Medium) -> ResultMap in value.resultMap }, "defaultMedia": defaultMedia.resultMap, "createdAt": createdAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String {
    get {
      return resultMap["title"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  public var shortdescription: String? {
    get {
      return resultMap["shortdescription"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "shortdescription")
    }
  }

  public var descriptionHtml: String {
    get {
      return resultMap["descriptionHtml"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "descriptionHtml")
    }
  }

  public var author: Author {
    get {
      return Author(unsafeResultMap: resultMap["author"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "author")
    }
  }

  public var media: [Medium] {
    get {
      return (resultMap["media"] as! [ResultMap]).map { (value: ResultMap) -> Medium in Medium(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Medium) -> ResultMap in value.resultMap }, forKey: "media")
    }
  }

  public var defaultMedia: DefaultMedium {
    get {
      return DefaultMedium(unsafeResultMap: resultMap["defaultMedia"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "defaultMedia")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(GraphQlUser.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, imageUrl: String? = nil, name: String? = nil, description: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "imageUrl": imageUrl, "name": name, "description": description])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var graphQlUser: GraphQlUser {
        get {
          return GraphQlUser(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Medium: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Media"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(GraphQlMedia.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, position: Int? = nil, srcUrl: String, width: Double, height: Double, mediaType: MediaType) {
      self.init(unsafeResultMap: ["__typename": "Media", "id": id, "position": position, "srcUrl": srcUrl, "width": width, "height": height, "mediaType": mediaType])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var graphQlMedia: GraphQlMedia {
        get {
          return GraphQlMedia(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct DefaultMedium: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Media"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(GraphQlMedia.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, position: Int? = nil, srcUrl: String, width: Double, height: Double, mediaType: MediaType) {
      self.init(unsafeResultMap: ["__typename": "Media", "id": id, "position": position, "srcUrl": srcUrl, "width": width, "height": height, "mediaType": mediaType])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var graphQlMedia: GraphQlMedia {
        get {
          return GraphQlMedia(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}
