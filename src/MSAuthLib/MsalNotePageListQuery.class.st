Class {
	#name : #MsalNotePageListQuery,
	#superclass : #MsalNoteCommand,
	#instVars : [
		'baseUrl',
		'path'
	],
	#category : #MSAuthLib
}

{ #category : #'instance creation' }
MsalNotePageListQuery class >> fromRootUrl: aUrl [

	^ self new
		baseUrl: aUrl / 'pages';
		yourself
]

{ #category : #accessing }
MsalNotePageListQuery >> baseUrl [

	^ baseUrl
]

{ #category : #accessing }
MsalNotePageListQuery >> baseUrl: anObject [

	baseUrl := anObject
]

{ #category : #accessing }
MsalNotePageListQuery >> batchJsonReader [

	^ [ :body :app | 
		| pageDicts |
		pageDicts := body at: 'value'.
		pageDicts collect: [ :dict | 
			| page |
			page := MsalOneNotePage 
				fromDictionary: dict 
				forApplication: app ] ]
]

{ #category : #accessing }
MsalNotePageListQuery >> beCountOnly [

	self path queryRemoveAll.
	
	self 
		top: 1; "setting top to 0 -> 500 error"
		count: true. 
	"Above, we would like to say:
		self path addPathSegment: '$count', but see https://github.com/seandenigris/MSAL-Smalltalk/issues/4"
		
	self jsonReader: [ :json | (json at: '@odata.count') asNumber ]
]

{ #category : #accessing }
MsalNotePageListQuery >> count: aBoolean [

	| countKey |
	countKey := '$count'.

	aBoolean 
		ifTrue: [ self path queryAt: countKey put: true ]
		ifFalse: [ 	
			self path 
				queryAt: countKey 
				ifPresent: [ self path queryRemoveKey: countKey ] ]
]

{ #category : #accessing }
MsalNotePageListQuery >> headerAccept [

	^ ZnMimeType applicationJson
	
	"Reference: https://learn.microsoft.com/en-us/graph/api/onenote-list-pages?view=graph-rest-1.0#request-headers"
]

{ #category : #accessing }
MsalNotePageListQuery >> path [

	^ path ifNil: [ path := ZnUrl new ]
]

{ #category : #accessing }
MsalNotePageListQuery >> path: anObject [

	path := anObject
]

{ #category : #accessing }
MsalNotePageListQuery >> printOn: aStream [

	aStream
		nextPutAll: 'GET ';
		print: self url;
		nextPutAll: ' -> ';
		print: self jsonReader.
]

{ #category : #accessing }
MsalNotePageListQuery >> skip: aNumber [

	self path queryAt: '$skip' put: aNumber
]

{ #category : #accessing }
MsalNotePageListQuery >> top: aNumber [

	self path queryAt: '$top' put: aNumber
]

{ #category : #accessing }
MsalNotePageListQuery >> topMaxPages [

	^ 100
	
	"Reference: https://learn.microsoft.com/en-us/graph/api/onenote-list-pages?view=graph-rest-1.0#optional-query-parameters"
]

{ #category : #accessing }
MsalNotePageListQuery >> url [

	| result |
	result := baseUrl copy
		addPathSegments: self path pathSegments;
		yourself.
		
	self path query ifNotNil: [ :pathQuery | result queryAddAll: pathQuery ].
	
	^ result
]
