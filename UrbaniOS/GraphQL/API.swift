// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum UserType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case other
  case admin
  case customer
  case business
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "OTHER": self = .other
      case "ADMIN": self = .admin
      case "CUSTOMER": self = .customer
      case "BUSINESS": self = .business
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .other: return "OTHER"
      case .admin: return "ADMIN"
      case .customer: return "CUSTOMER"
      case .business: return "BUSINESS"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: UserType, rhs: UserType) -> Bool {
    switch (lhs, rhs) {
      case (.other, .other): return true
      case (.admin, .admin): return true
      case (.customer, .customer): return true
      case (.business, .business): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [UserType] {
    return [
      .other,
      .admin,
      .customer,
      .business,
    ]
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

public enum GroupType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case `default`
  case referral
  case contest
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "DEFAULT": self = .default
      case "REFERRAL": self = .referral
      case "CONTEST": self = .contest
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .default: return "DEFAULT"
      case .referral: return "REFERRAL"
      case .contest: return "CONTEST"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: GroupType, rhs: GroupType) -> Bool {
    switch (lhs, rhs) {
      case (.default, .default): return true
      case (.referral, .referral): return true
      case (.contest, .contest): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [GroupType] {
    return [
      .default,
      .referral,
      .contest,
    ]
  }
}

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Login($userType: UserType!, $code: String!, $metadata: UserMetadataInput, $loginData: UserLoginInput) {
      login(userType: $userType, code: $code, metadata: $metadata, loginData: $loginData) {
        __typename
        sessionId
        user {
          __typename
          id
          firstName
          lastName
          imageUrl
          email
          isFollowing
          followersCount
        }
      }
    }
    """

  public let operationName: String = "Login"

  public var userType: UserType
  public var code: String
  public var metadata: UserMetadataInput?
  public var loginData: UserLoginInput?

  public init(userType: UserType, code: String, metadata: UserMetadataInput? = nil, loginData: UserLoginInput? = nil) {
    self.userType = userType
    self.code = code
    self.metadata = metadata
    self.loginData = loginData
  }

  public var variables: GraphQLMap? {
    return ["userType": userType, "code": code, "metadata": metadata, "loginData": loginData]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("login", arguments: ["userType": GraphQLVariable("userType"), "code": GraphQLVariable("code"), "metadata": GraphQLVariable("metadata"), "loginData": GraphQLVariable("loginData")], type: .object(Login.selections)),
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
    /// - **userType**: User userType
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
            GraphQLField("isFollowing", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("followersCount", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, imageUrl: String? = nil, email: String? = nil, isFollowing: Bool, followersCount: String) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "firstName": firstName, "lastName": lastName, "imageUrl": imageUrl, "email": email, "isFollowing": isFollowing, "followersCount": followersCount])
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

        public var isFollowing: Bool {
          get {
            return resultMap["isFollowing"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isFollowing")
          }
        }

        public var followersCount: String {
          get {
            return resultMap["followersCount"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "followersCount")
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
    query products($first: Int!) {
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

  public let operationName: String = "products"

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

    /// List of products.
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

      /// A list of edges.
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

        /// The item at the end of ProductEdge.
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
      descriptionHtml
      ordersCountStr
      images {
        __typename
        srcUrl
      }
      maximumAllowedQuantity
      groupType
      recommId
      variants(first: 1) {
        __typename
        edges {
          __typename
          node {
            __typename
            id
            price
            compareAtPrice
          }
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["Product"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("descriptionHtml", type: .nonNull(.scalar(String.self))),
      GraphQLField("ordersCountStr", type: .nonNull(.scalar(String.self))),
      GraphQLField("images", type: .nonNull(.list(.nonNull(.object(Image.selections))))),
      GraphQLField("maximumAllowedQuantity", type: .nonNull(.scalar(Int.self))),
      GraphQLField("groupType", type: .nonNull(.scalar(GroupType.self))),
      GraphQLField("recommId", type: .scalar(String.self)),
      GraphQLField("variants", arguments: ["first": 1], type: .nonNull(.object(Variant.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, title: String, descriptionHtml: String, ordersCountStr: String, images: [Image], maximumAllowedQuantity: Int, groupType: GroupType, recommId: String? = nil, variants: Variant) {
    self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "descriptionHtml": descriptionHtml, "ordersCountStr": ordersCountStr, "images": images.map { (value: Image) -> ResultMap in value.resultMap }, "maximumAllowedQuantity": maximumAllowedQuantity, "groupType": groupType, "recommId": recommId, "variants": variants.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Globally unique identifier.
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  /// The title of the product.
  public var title: String {
    get {
      return resultMap["title"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  /// The description of the product, complete with HTML formatting.
  public var descriptionHtml: String {
    get {
      return resultMap["descriptionHtml"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "descriptionHtml")
    }
  }

  public var ordersCountStr: String {
    get {
      return resultMap["ordersCountStr"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "ordersCountStr")
    }
  }

  /// The images associated with the product.
  public var images: [Image] {
    get {
      return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
    }
  }

  public var maximumAllowedQuantity: Int {
    get {
      return resultMap["maximumAllowedQuantity"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "maximumAllowedQuantity")
    }
  }

  public var groupType: GroupType {
    get {
      return resultMap["groupType"]! as! GroupType
    }
    set {
      resultMap.updateValue(newValue, forKey: "groupType")
    }
  }

  public var recommId: String? {
    get {
      return resultMap["recommId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "recommId")
    }
  }

  /// A list of variants associated with the product.
  public var variants: Variant {
    get {
      return Variant(unsafeResultMap: resultMap["variants"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "variants")
    }
  }

  public struct Image: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Image"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("srcUrl", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(srcUrl: String) {
      self.init(unsafeResultMap: ["__typename": "Image", "srcUrl": srcUrl])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The location of the original image as a URL.
    /// 
    /// If there are any existing transformations in the original source URL, they will remain and not be stripped.
    public var srcUrl: String {
      get {
        return resultMap["srcUrl"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "srcUrl")
      }
    }
  }

  public struct Variant: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["ProductVariantConnection"]

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
      self.init(unsafeResultMap: ["__typename": "ProductVariantConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// A list of edges.
    public var edges: [Edge] {
      get {
        return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
      }
    }

    public struct Edge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ProductVariantEdge"]

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
        self.init(unsafeResultMap: ["__typename": "ProductVariantEdge", "node": node.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The item at the end of ProductVariantEdge.
      public var node: Node {
        get {
          return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "node")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ProductVariant"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("price", type: .nonNull(.scalar(String.self))),
            GraphQLField("compareAtPrice", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, price: String, compareAtPrice: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "ProductVariant", "id": id, "price": price, "compareAtPrice": compareAtPrice])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Globally unique identifier.
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// The price of the product variant in the default shop currency.
        public var price: String {
          get {
            return resultMap["price"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "price")
          }
        }

        /// The compare-at price of the variant in the default shop currency.
        public var compareAtPrice: String? {
          get {
            return resultMap["compareAtPrice"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "compareAtPrice")
          }
        }
      }
    }
  }
}
