Class {
	#name : #MsalNoteSync,
	#superclass : #Object,
	#instVars : [
		'commands',
		'source',
		'target'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalNoteSync class >> from: newPages to: oldPages [

	^ self basicNew
		source: newPages;
		target: oldPages;
		initialize.
]

{ #category : #accessing }
MsalNoteSync >> addCommandsForPagesMissingFromSource [

	self target do: [ :existingPage |
		self source
			detect: [ :freshPage | freshPage id = existingPage id ]
			ifNone: [ self handleDeletedPage: existingPage ] ].
]

{ #category : #accessing }
MsalNoteSync >> addCommandsForPagesPresentInSource [

	self source do: [ :freshPage | 
		| cmd |
		cmd := self target
			detect: [ :existingPage | freshPage id = existingPage id ]
			ifFound: [ :existingPage | 
				MsalNotePageMerge 
					newPage: freshPage 
					oldPage: existingPage ]
			ifNone: [ MsalNotePageAdd page: freshPage container: self target ].
		self commands add: cmd ]
]

{ #category : #accessing }
MsalNoteSync >> commands [
	^ commands ifNil: [ commands := Bag new ]
]

{ #category : #accessing }
MsalNoteSync >> commands: aCollection [

	commands := aCollection
]

{ #category : #accessing }
MsalNoteSync >> commandsViewOn: aView [
	<gtView>
	
	^ aView list
		title: 'All';
		priority: 45;
		items: [ self commands asOrderedCollection ];
		inspectButtonFor: [ self commands ];
		actionUpdateButton;
		yourself
]

{ #category : #accessing }
MsalNoteSync >> execute [
	self commands do: #execute
]

{ #category : #accessing }
MsalNoteSync >> handleDeletedPage: existingPage [

	| cmd |
	existingPage status isExternallyDeleted ifTrue: [ ^ self ].
	
	cmd := MsalNotePageDelete page: existingPage.
	self commands add: cmd
]

{ #category : #accessing }
MsalNoteSync >> initialize [

	super initialize.
	self 
		addCommandsForPagesPresentInSource;
		addCommandsForPagesMissingFromSource
]

{ #category : #accessing }
MsalNoteSync >> modifications [

	^ self commands reject: #isNoOp
]

{ #category : #accessing }
MsalNoteSync >> modificationsViewOn: aView [
	<gtView>
	
	^ aView list
		title: 'Modifications';
		priority: 25;
		items: [ self modifications asOrderedCollection ];
		inspectButtonFor: [ self modifications ];
		actionUpdateButton;
		yourself
]

{ #category : #accessing }
MsalNoteSync >> noOps [

	^ self commands select: #isNoOp
]

{ #category : #accessing }
MsalNoteSync >> noOpsViewOn: aView [
	<gtView>
	
	^ aView list
		title: 'No-Ops';
		priority: 35;
		items: [ self noOps asOrderedCollection ];
		inspectButtonFor: [ self noOps ];
		actionUpdateButton;
		yourself
]

{ #category : #accessing }
MsalNoteSync >> source [
	^ source
]

{ #category : #accessing }
MsalNoteSync >> source: anObject [
	source := anObject
]

{ #category : #accessing }
MsalNoteSync >> target [
	^ target
]

{ #category : #accessing }
MsalNoteSync >> target: anObject [
	target := anObject
]
