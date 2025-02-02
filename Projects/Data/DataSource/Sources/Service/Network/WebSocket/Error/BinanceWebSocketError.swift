//
//  BinanceWebSocketError.swift
//  Data
//
//  Created by choijunios on 1/30/25.
//

import Foundation

enum BinanceWebSocketError: Int, Error {
    // General Server or Network issues (10xx)
    case unknown = -1000
    case disconnected = -1001
    case unauthorized = -1002
    case tooManyRequests = -1003
    case unexpectedResponse = -1006
    case timeout = -1007
    case serverBusy = -1008
    case invalidMessage = -1013
    case unknownOrderComposition = -1014
    case tooManyOrders = -1015
    case serviceShuttingDown = -1016
    case unsupportedOperation = -1020
    case invalidTimestamp = -1021
    case invalidSignature = -1022
    
    // Request issues (11xx)
    case illegalChars = -1100
    case tooManyParameters = -1101
    case mandatoryParamEmptyOrMalformed = -1102
    case unknownParam = -1103
    case unreadParameters = -1104
    case paramEmpty = -1105
    case paramNotRequired = -1106
    case paramOverflow = -1108
    case badPrecision = -1111
    case noDepth = -1112
    case tifNotRequired = -1114
    case invalidTif = -1115
    case invalidOrderType = -1116
    case invalidSide = -1117
    case emptyNewClOrdId = -1118
    case emptyOrgClOrdId = -1119
    case badInterval = -1120
    case badSymbol = -1121
    case invalidSymbolStatus = -1122
    case invalidListenKey = -1125
    case moreThanXHours = -1127
    case optionalParamsBadCombo = -1128
    case invalidParameter = -1130
    case badStrategyType = -1134
    case invalidJson = -1135
    case invalidTickerType = -1139
    case invalidCancelRestrictions = -1145
    case duplicateSymbols = -1151
    case invalidSbeHeader = -1152
    case unsupportedSchemaId = -1153
    case sbeDisabled = -1155
    case ocoOrderTypeRejected = -1158
    case ocoIcebergQtyTimeInForce = -1160
    case deprecatedSchema = -1161
    case buyOcoLimitMustBeBelow = -1165
    case sellOcoLimitMustBeAbove = -1166
    case bothOcoOrdersCannotBeLimit = -1168
    case invalidTagNumber = -1169
    case tagNotDefinedInMessage = -1170
    case tagAppearsMoreThanOnce = -1171
    case tagOutOfOrder = -1172
    case groupFieldsOutOfOrder = -1173
    case invalidComponent = -1174
    case resetSeqNumSupport = -1175
    case alreadyLoggedIn = -1176
    case garbledMessage = -1177
    case badSenderCompId = -1178
    case badSeqNum = -1179
    case expectedLogon = -1180
    case tooManyMessages = -1181
    case paramsBadCombo = -1182
    case notAllowedInDropCopySessions = -1183
    case dropCopySessionNotAllowed = -1184
    case dropCopySessionRequired = -1185
    case notAllowedInOrderEntrySessions = -1186
    case notAllowedInMarketDataSessions = -1187
    case incorrectNumInGroupCount = -1188
    case duplicateEntriesInAGroup = -1189
    case invalidRequestId = -1190
    case tooManySubscriptions = -1191
    case invalidTimeUnit = -1194
    case buyOcoStopLossMustBeAbove = -1196
    case sellOcoStopLossMustBeBelow = -1197
    case buyOcoTakeProfitMustBeBelow = -1198
    case sellOcoTakeProfitMustBeAbove = -1199
    
    // Order & API Key Issues (20xx)
    case newOrderRejected = -2010
    case cancelRejected = -2011
    case noSuchOrder = -2013
    case badApiKeyFmt = -2014
    case rejectedMbxKey = -2015
    case noTradingWindow = -2016
    case orderArchived = -2026
}
