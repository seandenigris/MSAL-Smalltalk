Class {
	#name : #MsalGraphBatchPost,
	#superclass : #Object,
	#instVars : [
		'requests',
		'url'
	],
	#category : #MSAuthLib
}

{ #category : #'instance creation' }
MsalGraphBatchPost class >> fromRootUrl: aUrl [

	^ self new
		url: aUrl / '$batch';
		yourself
]

{ #category : #accessing }
MsalGraphBatchPost >> handleResponses: responses fromApplication: application [
	^ self requests
		collectWithIndex: [ :req :idx | 
			responses
				detect: [ :response | (response at: 'id') asNumber = idx ]
				ifFound: [ :response | 
					(response at: 'status') = 200 ifFalse: [ self error: 'request unsuccessful' ].
					self
						handleSuccessfulResponse: response
						to: req
						fromApplication: application ]
				ifNone: [ self error: 'no response for request! Should never get here' ] ]
]

{ #category : #accessing }
MsalGraphBatchPost >> handleSuccessfulResponse: response to: request fromApplication: application [ 

	| result |
	result := request batchJsonReader cull: (response at: 'body') cull: application.
	request successBlock value: result.
	^ result
]

{ #category : #accessing }
MsalGraphBatchPost >> headerAccept [

	^ ZnMimeType applicationJson
	
	"Reference: https://learn.microsoft.com/en-us/graph/api/onenote-list-pages?view=graph-rest-1.0#request-headers"
]

{ #category : #accessing }
MsalGraphBatchPost >> json [

	| requestDicts jsonDict |
	requestDicts := Array streamContents: [ :str | 
		self requests doWithIndex: [ :request :index | 
			| requestDict |
			requestDict := request asBatchDictionary
				at: 'id' put: index asString;
				yourself.
			str << requestDict ] ].
	jsonDict := Dictionary newFromPairs: { 'requests'. requestDicts }.
	^ STONJSON toStringPretty: jsonDict.
]

{ #category : #accessing }
MsalGraphBatchPost >> maxRequestsPerPost [
	^ 20
	
	"Reference: https://learn.microsoft.com/en-us/graph/json-batching?context=graph%2Fapi%2F1.0&view=graph-rest-1.0#batch-size-limitations"
]

{ #category : #accessing }
MsalGraphBatchPost >> printOn: aStream [

	aStream
		nextPutAll: 'POST ';
		print: self url;
		nextPutAll: ' (';
		print: self requests size;
		nextPutAll: ' requests)'
]

{ #category : #accessing }
MsalGraphBatchPost >> requests [

	^ requests ifNil: [ requests := OrderedCollection new ]
]

{ #category : #accessing }
MsalGraphBatchPost >> requests: anObject [

	requests := anObject
]

{ #category : #accessing }
MsalGraphBatchPost >> sendTo: application [
	[ 
		application client
			contents: self json;
			contentType: ZnMimeType applicationJson.
	
		^ application
			clientHTTP: #post
			jsonAt: self url
			do: [ :json | 
				| responses |
				responses := json at: 'responses'.
				self handleResponses: responses fromApplication: application ]
	]
		ensure: [ application client resetEntity ]
]

{ #category : #accessing }
MsalGraphBatchPost >> url [

	^ url
]

{ #category : #accessing }
MsalGraphBatchPost >> url: anObject [

	url := anObject
]
