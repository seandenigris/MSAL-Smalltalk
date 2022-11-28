"
nil
"
Class {
	#name : #MsalOneNote,
	#superclass : #Object,
	#instVars : [
		'application',
		'pages'
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
MsalOneNote >> getPagesUrls [

	| url totalPages pageDicts result |
	url := MsalOneNotePage urlFromRoot: self class url.
	result := OrderedCollection new.
	totalPages := 0.
	[
		result add: (url queryRemoveKey: '$top') ? ('$top' -> 50) & ('skip' -> totalPages).
		totalPages := totalPages + 50.
	]
		doWhileTrue: [ totalPages <= 100 ].
		
	^ result	
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

	| freshPages sync |
	freshPages := self getPages.
	
	pages ifNil: [ ^ pages := freshPages ].
	
	sync := MsalNoteSync from: freshPages to: pages.
	Halt now.
	sync execute
]
