Class {
	#name : #MsgNotePagePreviewQuery,
	#superclass : #MsalNoteCommand,
	#instVars : [
		'url'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsgNotePagePreviewQuery class >> fromUrl: aUrl [
	
	^ self new
		url: aUrl;
		yourself
]

{ #category : #accessing }
MsgNotePagePreviewQuery >> ifFailBlock [
	
	ifFailBlock ifNotNil: [ ^ ifFailBlock ].
	
	^ [ :err | 
		err response isNotFound 
			ifTrue: [ err return: nil ]
			ifFalse: [ super ifFailBlock ] ]
]

{ #category : #accessing }
MsgNotePagePreviewQuery >> pageID [

	| urlPathSegments |
	urlPathSegments := self url pathSegments.
	^ urlPathSegments at: urlPathSegments size - 1
]

{ #category : #accessing }
MsgNotePagePreviewQuery >> url [

	^ url
]

{ #category : #accessing }
MsgNotePagePreviewQuery >> url: anObject [

	url := anObject
]
