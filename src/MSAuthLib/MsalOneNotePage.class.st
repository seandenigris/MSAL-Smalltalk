Class {
	#name : #MsalOneNotePage,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNotePage >> displayStringOn: aStream [
	aStream nextPutAll: self title
]

{ #category : #accessing }
MsalOneNotePage >> html [

	^ self application
		get: (self rawData at: 'contentUrl') asUrl
		do: [ :r | r ]
]

{ #category : #accessing }
MsalOneNotePage >> htmlRawViewOn: aView [
	<gtView>
	
	^ aView textEditor
		title: 'HTML (raw)';
		priority: 50;
		text: [ self html ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNotePage >> links [

	^ self rawData at: 'links'
]

{ #category : #accessing }
MsalOneNotePage >> presentInClient [

	^ ((self links at: 'oneNoteClientUrl') at: 'href') asUrl open
]

{ #category : #accessing }
MsalOneNotePage >> presentOnWeb [

	^ ((self links at: 'oneNoteWebUrl') at: 'href') asUrl open
]

{ #category : #accessing }
MsalOneNotePage >> printOn: aStream [
	self title ifNotNil: [ :title |
		aStream nextPutAll: title ].
	aStream nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MsalOneNotePage >> title [
	^ self rawData at: 'title'
]
