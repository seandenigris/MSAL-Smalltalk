"
nil
"
Class {
	#name : #MsalOneNote,
	#superclass : #Object,
	#instVars : [
		'application',
		'pages',
		'missingPageIDs'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNote class >> forApplication: anMsalApplication [

	^ self new
		application: anMsalApplication;
		yourself
]

{ #category : #accessing }
MsalOneNote class >> url [

	| baseUrl endpoint |
	baseUrl := 'https://graph.microsoft.com/v1.0/' asUrl.
	endpoint := baseUrl / 'me'.
	^ endpoint asUrl / 'onenote'
]

{ #category : #accessing }
MsalOneNote >> application [

	^ application
]

{ #category : #accessing }
MsalOneNote >> application: anObject [

	application := anObject
]

{ #category : #accessing }
MsalOneNote >> getPages [

	| url totalPages pageDicts result |
	url := MsalOneNotePage urlFromRoot: self class url.
	result := OrderedCollection new.
	
	[
		self application 
			getJsonAt: url ? ('skip' -> result size)
			do: [ :json |
				totalPages := (json at: '@odata.count').
				pageDicts := (json at: 'value').
				pageDicts do: [ :dict |
					| page |
					page := MsalOneNotePage 
						fromDictionary: dict
						forApplication: self application.
					result add: page ] ]
	]
		doWhileTrue: [ result size < totalPages ].
		
	^ result	
]

{ #category : #accessing }
MsalOneNote >> missingPageIDs [
	^ missingPageIDs ifNil: [ missingPageIDs := Set new ]
]

{ #category : #accessing }
MsalOneNote >> notebooks [

	^ self application 
		getJsonAt: MsalOneNoteBook url
		do: [ :json |
			(json at: 'value') collect: [ :dict |
				MsalOneNoteBook 
					fromDictionary: dict
					forApplication: self application ] ]
]

{ #category : #accessing }
MsalOneNote >> notebooksViewOn: aView [
	<gtView>
	
	^ aView list
		title: 'Notebooks';
		priority: 50;
		items: [ self notebooks asAsyncStream ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNote >> pages [

	^ pages select: [ :page | page status isActive ]
]

{ #category : #accessing }
MsalOneNote >> syncPages [

	| freshPages |
	freshPages := self getPages.
	
	pages ifNil: [ ^ pages := freshPages ].
	
	self syncPagesPresentIn: freshPages.
	self syncPagesMissingFrom: freshPages.
]

{ #category : #'private-syncing' }
MsalOneNote >> syncPagesMissingFrom: aCollection [ 

	pages do: [ :existingPage |
		aCollection
			detect: [ :freshPage | freshPage id = existingPage id ]
			ifNone: [ existingPage status: MsalNotePageDeletedExternallyStatus new ] ].
]

{ #category : #'private-syncing' }
MsalOneNote >> syncPagesPresentIn: aCollection [

	aCollection do: [ :freshPage | 
		pages
			detect: [ :existingPage | freshPage id = existingPage id ]
			ifFound: [ :existingPage | existingPage syncFrom: freshPage ]
			ifNone: [ pages add: freshPage ] ]
]
