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
	self visitCreationTimetamp: aPage creationTimestamp.
	self visitBodyOf: aPage
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitBodyElement: anXMLElement [

	anXMLElement name = 'img' ifTrue: [ ^ self visitImageElement: anXMLElement ]
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
MsalOneNotePageVisitor >> visitImageElement: anXMLElement [
	
	| url |
	(anXMLElement attributeAt: 'data-src-type') = 'image/png' ifFalse: [ self error: 'only handles pngs' ].
	
	url := (anXMLElement attributeAt: 'src') asUrl.
	
	self application
		get: url
		contentReader: [ :r | self visitImageBytes: r contents ]
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitTitle: anObject [ 
]
