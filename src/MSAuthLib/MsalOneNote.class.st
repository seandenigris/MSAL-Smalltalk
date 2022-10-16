Class {
	#name : #MsalOneNote,
	#superclass : #Object,
	#instVars : [
		'application'
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

	| url |
	url := MsalOneNotePage url ? ('$top' -> 100).
	^ self application 
		getJsonAt: url
		do: [ :json |
			(json at: 'value') collect: [ :dict |
				MsalOneNotePage 
					fromDictionary: dict
					forApplication: self application ] ]
]
