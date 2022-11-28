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
MsalOneNotePageVisitor >> visitImageBytes: anObject [ 
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitImageElement: anXMLElement [
	
	| url |
	url := (anXMLElement attributeAt: 'data-fullres-src') asUrl.
	
	self application
		get: url
		contentReader: [ :r | self visitImageBytes: r contents ]
		
	"`anXMLElement attributeAt: 'data-fullres-src-type'` returns a media type e.g. 'image/png'"
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitTitle: anObject [ 
]
