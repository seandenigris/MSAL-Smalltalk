Class {
	#name : #MsalNotePageSyncCommand,
	#superclass : #Object,
	#instVars : [
		'page'
	],
	#category : #'MSAuthLib-OneNote'
}

{ #category : #'instance creation' }
MsalNotePageSyncCommand class >> page: aPage [

	^ self new
		page: aPage;
		yourself
]

{ #category : #accessing }
MsalNotePageSyncCommand >> isNoOp [

	^ false
]

{ #category : #accessing }
MsalNotePageSyncCommand >> page [

	^ page
]

{ #category : #accessing }
MsalNotePageSyncCommand >> page: anObject [

	page := anObject
]

{ #category : #accessing }
MsalNotePageSyncCommand >> pageViewOn: aView [
	<gtView>

	^ aView forward
		title: 'Page';
		priority: 25;
		object: [ self page ];
		view: #liveViewOn:;
		inspectButtonFor: [ self page ]
]

{ #category : #accessing }
MsalNotePageSyncCommand >> printOn: aStream [

	| cmdName |
	cmdName := self className copyFrom: 'MsalNotePage' size + 1 to: self className size.
	aStream 
		nextPutAll: cmdName;
		nextPutAll: ' - ';
		nextPutAll: self page title
]
