Class {
	#name : #MsalOneNoteImage,
	#superclass : #Object,
	#traits : 'PeTRawDataHolder',
	#classTraits : 'PeTRawDataHolder classTrait',
	#instVars : [
		'note',
		'cache'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNoteImage class >> inNote: aPage fromDictionary: aDictionary [

	^ (self fromDictionary: aDictionary)
		note: aPage;
		yourself
]

{ #category : #accessing }
MsalOneNoteImage >> application [

	^ self note application
]

{ #category : #accessing }
MsalOneNoteImage >> asElement [

	^ self asRlResource asElement
]

{ #category : #accessing }
MsalOneNoteImage >> asRlResource [

	| imageFile resource |
	
	self cache
		at: #resource
		ifPresent: [ :cacheResource | ^ cacheResource ].
	
	imageFile := Tempfile named: 'onenote_image_',self id, '.', self rlResourceClass fileExtensions first.
	
	self downloadTo: imageFile.

	resource := self rlResourceClass new
		file: imageFile;
		source: self url;
		"propertyAt: #oneNoteImage put: self; Don't want to drag in whole Msal apparatus"
		yourself.
		
	^ self cache at: #resource put: resource.
]

{ #category : #accessing }
MsalOneNoteImage >> cache [

	^ cache ifNil: [ cache := RlCache new ]
]

{ #category : #accessing }
MsalOneNoteImage >> downloadTo: aFileReference [

	self application
		get: self url
		contentReader: [ :r | 
			aFileReference binaryWriteStreamDo: [ :str | 
				str nextPutAll: r contents ] ].
				
	^ aFileReference
]

{ #category : #accessing }
MsalOneNoteImage >> height [

	^ self 
		rawDataAt: 'height'
		reader: #asInteger.
]

{ #category : #accessing }
MsalOneNoteImage >> id [

	^ self url pathSegments allButLast last
]

{ #category : #accessing }
MsalOneNoteImage >> liveGtViewFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Live';
		priority: 85;
		object: [ self asRlResource ];
		view: #gtFigureFor:
]

{ #category : #accessing }
MsalOneNoteImage >> mimeType [

	^ self
		rawDataAt: 'data-fullres-src-type'
		reader: [ :str | ZnMimeType fromString: str ].
]

{ #category : #accessing }
MsalOneNoteImage >> note [
	^ note
]

{ #category : #accessing }
MsalOneNoteImage >> note: anObject [
	note := anObject
]

{ #category : #accessing }
MsalOneNoteImage >> printOn: aStream [

	aStream
		print: self width;
		nextPut: $x;
		print: self height;
		space;
		nextPutAll: (self rlResourceClass name allButFirst: 'Rl' size)
]

{ #category : #accessing }
MsalOneNoteImage >> rlResourceClass [

	^ RlPicture allSubclasses
		detect: [ :e | e mimeTypes includes: self mimeType ]
		ifNone: [ RlPicture ].
]

{ #category : #accessing }
MsalOneNoteImage >> url [

	^ self 
		rawDataAt: 'data-fullres-src'
		reader: #asUrl.
]

{ #category : #accessing }
MsalOneNoteImage >> width [

	^ self 
		rawDataAt: 'width'
		reader: #asInteger.
]
