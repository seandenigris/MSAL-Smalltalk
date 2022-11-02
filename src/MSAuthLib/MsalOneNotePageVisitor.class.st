Class {
	#name : #MsalOneNotePageVisitor,
	#superclass : #Object,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNotePageVisitor class >> visit: aPage [

	^ self new 
		note: aPage;
		visit: aPage
]

{ #category : #accessing }
MsalOneNotePageVisitor >> note: aPage [ 
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
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitTitle: anObject [ 
]
