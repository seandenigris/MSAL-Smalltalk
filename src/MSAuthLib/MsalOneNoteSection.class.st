Class {
	#name : #MsalOneNoteSection,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNoteSection >> displayStringOn: aStream [
	aStream nextPutAll: self name
]

{ #category : #accessing }
MsalOneNoteSection >> getPages [

	| url |
	url := MsalOneNotePage urlFromRoot: self url.

	^ self application
		getJsonAt: url
		do: [ :json | 
			(json at: 'value')
				collect: [ :dict | MsalOneNotePage fromDictionary: dict forApplication: self application ]
				thenSelect: #exists ]
]

{ #category : #accessing }
MsalOneNoteSection >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
MsalOneNoteSection >> name [
	^ self rawData at: 'displayName'
]

{ #category : #accessing }
MsalOneNoteSection >> pages [
	"Query parameters reference: https://learn.microsoft.com/en-us/graph/query-parameters"

	| url |
	url := MsalOneNotePage urlFromRoot: self url.

	^ self application
		getJsonAt: url
		do: [  "Implementation note: was sorting by modification timestamp, but apparently notes are considered 'modified' every time they are opened in the One Note client":json | 
			(json at: 'value')
				collect: [ :dict | MsalOneNotePage fromDictionary: dict forApplication: self application ]
				thenSelect: #exists ]
]

{ #category : #accessing }
MsalOneNoteSection >> pagesViewOn: aView [
	<gtView>
	
	^ aView list
		title: 'Pages';
		priority: 50;
		items: [ self pages asAsyncStream ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNoteSection >> printOn: aStream [
	self name ifNotNil: [ :name |
		aStream nextPutAll: name ].
	aStream nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MsalOneNoteSection >> url [
	^ MsalOneNote url / 'sections' / self id
]
