Class {
	#name : #MsalOneNotePageVisitor,
	#superclass : #Object,
	#instVars : [
		'note'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNotePageVisitor class >> visit: aPage [

	^ self new 
		note: aPage;
		visit: aPage
]

{ #category : #accessing }
MsalOneNotePageVisitor >> application [
	^ self note application
]

{ #category : #accessing }
MsalOneNotePageVisitor >> note [
	^ note
]

{ #category : #accessing }
MsalOneNotePageVisitor >> note: aPage [
	note := aPage
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visit: aPage [

	self visitTitle: aPage title.
	self visitID: aPage id.
	self visitCreationTimetamp: aPage creationTimestamp.
	self visitModificationTimestampUTC: aPage modificationTimestampUTC.
	self visitBodyOf: aPage
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitAnchorElement: anXMLElement [ 
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitBodyElement: anXMLElement [

	anXMLElement name = 'img' ifTrue: [ ^ self visitImageElement: anXMLElement ].
	anXMLElement name = 'a' ifTrue: [ ^ self visitAnchorElement: anXMLElement ]
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitBodyOf: aPage [ 

	aPage htmlBody descendantElementsDo: [ :el |
		self visitBodyElement: el ]
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitCreationTimetamp: aDateAndTime [ 
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitID: aString [
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitImage: resource [ 
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitImageElement: anXMLElement [
	
	| image |
	image := MsalOneNoteImage inNote: self note fromDictionary: anXMLElement attributes.
	self visitImage:image
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitModificationTimestampUTC: aDateAndTime [
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitTitle: anObject [ 
]
