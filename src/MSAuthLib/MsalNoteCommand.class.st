Class {
	#name : #MsalNoteCommand,
	#superclass : #Object,
	#instVars : [
		'jsonReader',
		'successBlock',
		'ifFailBlock'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalNoteCommand >> asBatchDictionary [

	| relativeUrl |
	relativeUrl := self url asRelativeUrl removeFirstPathSegment.
	^ {
		'method' -> 'GET'.
		'url' -> relativeUrl asString } asDictionary.
]

{ #category : #accessing }
MsalNoteCommand >> batchJsonReader [

	^ self jsonReader
]

{ #category : #accessing }
MsalNoteCommand >> ifFail: aBlock [

	ifFailBlock := aBlock
]

{ #category : #accessing }
MsalNoteCommand >> ifFailBlock [
	
	^ ifFailBlock ifNil: [ [ :exception | exception pass ] ]
]

{ #category : #accessing }
MsalNoteCommand >> jsonReader [

	^ jsonReader ifNil: [ #yourself ]
]

{ #category : #accessing }
MsalNoteCommand >> jsonReader: anObject [

	jsonReader := anObject
]

{ #category : #accessing }
MsalNoteCommand >> onSuccess: aBlock [

	successBlock := aBlock
]

{ #category : #accessing }
MsalNoteCommand >> printOn: aStream [

	aStream
		nextPutAll: 'GET ';
		print: self url
]

{ #category : #accessing }
MsalNoteCommand >> sendTo: application [

	| result |
	result := application 
		getJsonAt: self url
		do: self jsonReader.
		
	^ self successBlock value: result
]

{ #category : #accessing }
MsalNoteCommand >> successBlock [

	^ successBlock ifNil: [ #yourself ]
]

{ #category : #accessing }
MsalNoteCommand >> url [

	self subclassResponsibility
]
