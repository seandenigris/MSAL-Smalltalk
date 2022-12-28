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

	| pageQueries batch result |
	result := OrderedCollection new.
	pageQueries := self getPagesUrls.
	pageQueries do: [ :query | 
		query onSuccess: [ :col |
			result addAll: col ] ].
	batch := MsalGraphBatchRequest forGraphV1.
	batch requests: pageQueries.
	batch sendTo: self application.
	
	batch := MsalGraphBatchRequest forGraphV1.				
	result do: [ :page | batch addRequest: page contentUpdateQuery ].
	batch sendTo: MsalDynabookApp uniqueInstance.
	
	^ result
]

{ #category : #accessing }
MsalOneNote >> getPagesUrls [

	| query totalPages handledPages result pageSize |
	query := MsalNotePageListQuery fromRootUrl: self class url.
	totalPages := query beCountOnly sendTo: self application.
	
	result := OrderedCollection new.
	pageSize := query topMaxPages.
	handledPages := 0.
	[
		query := MsalNotePageListQuery fromRootUrl: self class url.
		query top: pageSize; skip: handledPages.
		result add: query.
		handledPages := handledPages + pageSize.
	]
		doWhileTrue: [ handledPages < totalPages ].
		
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
