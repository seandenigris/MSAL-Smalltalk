Class {
	#name : #MsalOneNoteBook,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNoteBook >> name [
	^ self rawData at: 'displayName'
]

{ #category : #accessing }
MsalOneNoteBook >> printOn: aStream [
	self name ifNotNil: [ :name |
		aStream nextPutAll: name ].
	aStream nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MsalOneNoteBook >> sections [

	| url |
	url := self rawData at: 'sectionsUrl'.
	^ self application
		getJsonAt: url
		do: [ :json |
			(json at: 'value') collect: [ :dict |
				MsalOneNoteSection 
					fromDictionary: dict
					forApplication: self application ] ]
]
