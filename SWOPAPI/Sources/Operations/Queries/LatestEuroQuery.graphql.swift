// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LatestEuroQuery: GraphQLQuery {
  public static let operationName: String = "LatestEuro"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query LatestEuro { latest(baseCurrency: "EUR", quoteCurrencies: ["USD", "CHF", "HKD"]) { __typename date baseCurrency quoteCurrency quote } }"#
    ))

  public init() {}

  public struct Data: SWOPAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { SWOPAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("latest", [Latest].self, arguments: [
        "baseCurrency": "EUR",
        "quoteCurrencies": ["USD", "CHF", "HKD"]
      ]),
    ] }

    /// Returns the latest rates
    public var latest: [Latest] { __data["latest"] }

    /// Latest
    ///
    /// Parent Type: `Rate`
    public struct Latest: SWOPAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { SWOPAPI.Objects.Rate }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("date", SWOPAPI.Date.self),
        .field("baseCurrency", String.self),
        .field("quoteCurrency", String.self),
        .field("quote", SWOPAPI.BigDecimal.self),
      ] }

      public var date: SWOPAPI.Date { __data["date"] }
      public var baseCurrency: String { __data["baseCurrency"] }
      public var quoteCurrency: String { __data["quoteCurrency"] }
      public var quote: SWOPAPI.BigDecimal { __data["quote"] }
    }
  }
}
