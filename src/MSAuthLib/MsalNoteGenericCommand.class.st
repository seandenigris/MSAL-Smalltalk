Class {
	#name : #MsalNoteGenericCommand,
	#superclass : #MsalNoteCommand,
	#instVars : [
		'url'
	],
	#category : #MSAuthLib
}

{ #category : #printing }
MsalNoteGenericCommand >> printOn: aStream [

	aStream
		nextPutAll: 'GET ';
		print: self url
]

{ #category : #accessing }
MsalNoteGenericCommand >> url [

	^ url
]

{ #category : #accessing }
MsalNoteGenericCommand >> url: anObject [

	url := anObject
]
