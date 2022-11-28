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
	
	self isNoOp ifTrue: [ ^ self ].
	
	self oldPage syncFrom: self newPage
]

{ #category : #accessing }
MsalNotePageMerge >> hasEqualModificationTimestamps [

	^ self oldPage modificationTimestampUTC = self newPage modificationTimestampUTC
]

{ #category : #accessing }
MsalNotePageMerge >> isNoOp [

	^ self hasEqualModificationTimestamps 
		and: [
			"Apparently, the content HTML is not guaranteed to be exact the same even if the modification stamps are equal. See https://github.com/seandenigris/MSAL-Smalltalk/issues/4 for an example where the OCR from a receipt image has been inserted somehow in the alt attribute of the img tag, but the modification stamps are equal." 
			self oldPage htmlString = self newPage htmlString ]
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
MsalNotePageMerge >> newPageViewOn: aView [
	<gtView>

	^ aView forward
		title: 'New Page';
		priority: 25;
		object: [ self newPage ];
		view: #liveViewOn:;
		inspectButtonFor: [ self page ]
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
MsalNotePageMerge >> pageViewOn: aView [

	^ (super pageViewOn: aView)
		title: 'Old Page'
]

{ #category : #accessing }
MsalNotePageMerge >> printOn: aStream [

	super printOn: aStream.
	
	self hasEqualModificationTimestamps ifTrue: [ aStream nextPutAll: ' - NO OP - mod times equal' ]
]

{ #category : #accessing }
MsalNotePageMerge >> verifyIsNoOp [
	self oldPage rawData = self newPage rawData ifFalse: [ self error: 'Raw data differs' ].
	self oldPage htmlString = self newPage htmlString ifFalse: [ self error: 'HTML string differs' ].
	self oldPage title = self newPage title ifFalse: [ self error: 'Title differs' ].
	self oldPage status class = self newPage status class ifFalse: [ self error: 'Status differs' ]
]
