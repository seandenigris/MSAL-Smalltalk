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
MsalOneNoteSection >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
MsalOneNoteSection >> name [
	^ self rawData at: 'displayName'
]

{ #category : #accessing }
MsalOneNoteSection >> pages [
	| url baseUrl endpoint |
	baseUrl := 'https://graph.microsoft.com/v1.0/' asUrl.
	endpoint := baseUrl / 'me'.
	url := endpoint asUrl / 'onenote' / 'sections' / self id / 'pages' ? ('$top' -> 100).
	^ self application
		getJsonAt: url
		do: [ :json | 
			(json at: 'value')
				collect: [ :dict | MsalOneNotePage fromDictionary: dict forApplication: self application ] ]
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