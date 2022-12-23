Class {
	#name : #MsgNotePageContentQuery,
	#superclass : #MsalNoteCommand,
	#instVars : [
		'url'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsgNotePageContentQuery class >> fromUrl: aUrl [
	
	^ self new
		url: aUrl;
		yourself
]

{ #category : #accessing }
MsgNotePageContentQuery >> batchJsonReader [

	^ [ :e | e base64Decoded utf8Decoded ]
]

{ #category : #accessing }
MsgNotePageContentQuery >> pageID [

	| urlPathSegments |
	urlPathSegments := self url pathSegments.
	^ urlPathSegments at: urlPathSegments size - 1
]

{ #category : #accessing }
MsgNotePageContentQuery >> url [

	^ url
]

{ #category : #accessing }
MsgNotePageContentQuery >> url: anObject [

	url := anObject
]
