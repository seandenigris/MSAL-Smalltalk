Class {
	#name : #MsalNotePageHandler,
	#superclass : #Object,
	#instVars : [
		'note'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalNotePageHandler class >> forNote: aNote [

	^ self new
		note: aNote;
		yourself
]

{ #category : #accessing }
MsalNotePageHandler >> execute [

	self subclassResponsibility
]

{ #category : #accessing }
MsalNotePageHandler >> note [

	^ note
]

{ #category : #accessing }
MsalNotePageHandler >> note: anObject [

	note := anObject
]
