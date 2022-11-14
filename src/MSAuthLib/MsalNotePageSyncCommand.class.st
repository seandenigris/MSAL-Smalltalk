Class {
	#name : #MsalNotePageSyncCommand,
	#superclass : #Object,
	#instVars : [
		'page'
	],
	#category : #'MSAuthLib-OneNote'
}

{ #category : #'instance creation' }
MsalNotePageSyncCommand class >> page: aPage [

	^ self new
		page: aPage;
		yourself
]

{ #category : #accessing }
MsalNotePageSyncCommand >> page [

	^ page
]

{ #category : #accessing }
MsalNotePageSyncCommand >> page: anObject [

	page := anObject
]

{ #category : #accessing }
MsalNotePageSyncCommand >> printOn: aStream [

	| cmdName |
	cmdName := self className copyFrom: 'MsalNotePage' size + 1 to: self className size.
	aStream 
		nextPutAll: cmdName
]
