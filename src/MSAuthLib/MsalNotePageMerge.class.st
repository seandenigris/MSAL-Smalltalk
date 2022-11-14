Class {
	#name : #MsalNotePageMerge,
	#superclass : #MsalNotePageSyncCommand,
	#instVars : [
		'newPage'
	],
	#category : #'MSAuthLib-OneNote'
}

{ #category : #'instance creation' }
MsalNotePageMerge class >> newPage: newPage oldPage: oldPage [

	^ self new
		newPage: newPage;
		oldPage: oldPage;
		yourself
]

{ #category : #accessing }
MsalNotePageMerge >> execute [

	self oldPage syncFrom: self newPage
]

{ #category : #accessing }
MsalNotePageMerge >> hasEqualModificationTimestamps [

	^ self oldPage modificationTimestampUTC = self newPage modificationTimestampUTC
]

{ #category : #accessing }
MsalNotePageMerge >> newPage [

	^ newPage
]

{ #category : #accessing }
MsalNotePageMerge >> newPage: anObject [

	newPage := anObject
]

{ #category : #accessing }
MsalNotePageMerge >> oldPage [

	^ page
]

{ #category : #accessing }
MsalNotePageMerge >> oldPage: anObject [

	page := anObject
]

{ #category : #accessing }
MsalNotePageMerge >> printOn: aStream [

	super printOn: aStream.
	
	self hasEqualModificationTimestamps ifTrue: [ aStream nextPutAll: ' - NO OP - mod times equal' ]
]
