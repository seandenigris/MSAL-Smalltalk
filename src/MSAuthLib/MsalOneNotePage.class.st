Class {
	#name : #MsalOneNotePage,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNotePage class >> url [

	^ MsalOneNote url / 'pages'
]

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
MsalOneNotePage >> id [

	^ self rawData at: 'id'
]

{ #category : #accessing }
MsalOneNotePage >> links [

	^ self rawData at: 'links'
]

{ #category : #accessing }
MsalOneNotePage >> markdown [

	| pySource |
	pySource := 'import html2text
h = html2text.HTML2Text()
h.handle(input)'.

	^ PBApplication uniqueInstance
		sendSource: pySource 
		withBindings: { #input -> self html }
]

{ #category : #accessing }
MsalOneNotePage >> markdownViewOn: aView [
	<gtView>
	
	^ aView explicit
		title: 'Markdown';
		priority: 25;
		stencil: [ LeCoderTextElement coderElementFor: self markdown ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNotePage >> presentInClient [

	^ ((self links at: 'oneNoteClientUrl') at: 'href') asUrl open
]

{ #category : #accessing }
MsalOneNotePage >> presentInClientDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #presentInClient;
		yourself
]

{ #category : #accessing }
MsalOneNotePage >> presentOnWeb [

	^ ((self links at: 'oneNoteWebUrl') at: 'href') asUrl open
]

{ #category : #accessing }
MsalOneNotePage >> presentOnWebDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #presentOnWeb;
		yourself
]

{ #category : #accessing }
MsalOneNotePage >> preview [

	^ self application
		getJsonAt: (self rawData at: 'self') asUrl / 'preview'
		do: [ :r | r ]
		
	"Reference: https://learn.microsoft.com/en-us/graph/onenote-get-content#page-preview"
]

{ #category : #accessing }
MsalOneNotePage >> previewText [

	^ self preview at: 'previewText'
]

{ #category : #accessing }
MsalOneNotePage >> printOn: aStream [
	self title ifNotNil: [ :title |
		aStream nextPutAll: title ].
	super printOn: aStream.
]

{ #category : #accessing }
MsalOneNotePage >> title [
	^ self rawData at: 'title'
]

{ #category : #accessing }
MsalOneNotePage >> url [

	^ self class url / self id
]
