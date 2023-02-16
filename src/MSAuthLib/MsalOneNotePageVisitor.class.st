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
	
	| url imageType imageID imageFile class resource |
	url := (anXMLElement attributeAt: 'data-fullres-src') asUrl.
	imageType := ZnMimeType fromString: (anXMLElement attributeAt: 'data-fullres-src-type').
	imageID := url copy pathSegments allButLast last.
	
	"RlPicture fromMimeType: withBytes:."
	class := RlPicture allSubclasses
		detect: [ :e | e mimeTypes includes: imageType ]
		ifNone: [ RlPicture ].
		
	imageFile := FileSystem memory / imageID, class fileExtensions first.
	
	self application
		get: url
		contentReader: [ :r | 
			imageFile binaryWriteStreamDo: [ :str | 
				str nextPutAll: r contents ] ].
				
	resource := class new
		file: imageFile;
		source: url;
		yourself.
	
	self application
		get: url
		contentReader: [ :r | self visitImage: resource ]
		
	"`anXMLElement attributeAt: 'data-fullres-src-type'` returns a media type e.g. 'image/png'"
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitModificationTimestampUTC: aDateAndTime [
]

{ #category : #accessing }
MsalOneNotePageVisitor >> visitTitle: anObject [ 
]
