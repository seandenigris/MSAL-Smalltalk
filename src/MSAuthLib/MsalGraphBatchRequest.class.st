Class {
	#name : #MsalGraphBatchRequest,
	#superclass : #Object,
	#instVars : [
		'requests',
		'url'
	],
	#category : #MSAuthLib
}

{ #category : #'instance creation' }
MsalGraphBatchRequest class >> fromRootUrl: aUrl [

	^ self new
		url: aUrl / '$batch';
		yourself
]

{ #category : #accessing }
MsalGraphBatchRequest >> headerAccept [

	^ ZnMimeType applicationJson
	
	"Reference: https://learn.microsoft.com/en-us/graph/api/onenote-list-pages?view=graph-rest-1.0#request-headers"
]

{ #category : #accessing }
MsalGraphBatchRequest >> json [

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
MsalGraphBatchRequest >> printOn: aStream [

	aStream
		nextPutAll: 'GET ';
		print: self url;
		nextPutAll: ' -> ';
		print: self jsonReader.
]

{ #category : #accessing }
MsalGraphBatchRequest >> requests [

	^ requests
]

{ #category : #accessing }
MsalGraphBatchRequest >> requests: anObject [

	requests := anObject
]

{ #category : #accessing }
MsalGraphBatchRequest >> sendTo: application [

	[ 
		application client
			contents: self json;
			contentType: ZnMimeType applicationJson.
			
		^ application
			clientHTTP: #post 
			jsonAt: self url 
			do: [ :json | json ]
	]
		ensure: [ application client resetEntity ]
]

{ #category : #accessing }
MsalGraphBatchRequest >> url [

	^ url
]

{ #category : #accessing }
MsalGraphBatchRequest >> url: anObject [

	url := anObject
]
