Class {
	#name : #MsalNotePageAdd,
	#superclass : #MsalNotePageSyncCommand,
	#instVars : [
		'container'
	],
	#category : #'MSAuthLib-OneNote'
}

{ #category : #accessing }
MsalNotePageAdd class >> page: aPage container: aCollection [

	^ (self page: aPage)
		container: aCollection;
		yourself
]

{ #category : #accessing }
MsalNotePageAdd >> container [
	^ container
]

{ #category : #accessing }
MsalNotePageAdd >> container: anObject [
	container := anObject
]

{ #category : #execution }
MsalNotePageAdd >> execute [

	self container add: self page
]
