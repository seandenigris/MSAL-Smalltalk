Class {
	#name : #MsalOneNotePage,
	#superclass : #MsalObject,
	#instVars : [
		'creationTimestamp',
		'htmlString'
	],
	#classVars : [
		'Handlers'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalOneNotePage class >> handlers [

	^ Handlers ifNil: [ Handlers := Set new ]
]

{ #category : #accessing }
MsalOneNotePage class >> handlers: anObject [

	Handlers := anObject
]

{ #category : #accessing }
MsalOneNotePage class >> url [

	^ MsalOneNote url / 'pages'
]

{ #category : #accessing }
MsalOneNotePage >> creationTimestamp [
	"We use this complicated method of extracting from HTML because the API returns the UTC time and Pharo doesn't have a reliable way to translate that to local time"

	| creationMeta |
	
	creationTimestamp ifNotNil: [ ^ creationTimestamp ].
	
	creationMeta := self htmlHeadElements detect: [ :element | 
		element attributes 
			at: #name 
			ifPresent: [ :val | val = 'created' ]
			ifAbsent: [ false ] ].
			
	^ creationTimestamp := (creationMeta attributeAt: #content) asDateAndTime translateToUTC.
]

{ #category : #accessing }
MsalOneNotePage >> creationTimestampUTC [

	^ self rawData at: 'createdDateTime'
]

{ #category : #accessing }
MsalOneNotePage >> displayStringOn: aStream [
	aStream nextPutAll: self title
]

{ #category : #accessing }
MsalOneNotePage >> exists [

	^ true.
	
	"fetching contents takes too long and HEAD fails with a 405 error
	self application 
		head: self htmlUrl 
		responseDo: [ :response | response isNotFound not ]."
]

{ #category : #accessing }
MsalOneNotePage >> handlers [

	^ self class handlers
		select: [ :handler | handler canHandleNote: self ]
		thenCollect: [ :handler | handler forNote: self ]
]

{ #category : #accessing }
MsalOneNotePage >> handlersViewOn: aView [
	<gtView>
	
	^ aView list
		title: 'Handlers';
		priority: 25;
		items: [ self handlers asOrderedCollection ];
		itemContextMenuStencil: [ :element :item |
			BrGlamorousSimpleContextMenuContent new
				items: {
					'Execute' -> [ item execute ] };
				yourself ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNotePage >> htmlDocument [
	"I am intended to be a temporary object which will not be refreshed, so it seems safe to cache my HTML. To sync updates, one would fetch again as a new object"
	
	^ (XMLDOMParser parse: self htmlString)
		removeAllFormattingNodes;
		yourself.
]

{ #category : #accessing }
MsalOneNotePage >> htmlHeadElements [

	^ (self htmlDocument / #html / #head) first elements
]

{ #category : #accessing }
MsalOneNotePage >> htmlLinks [

	^ self htmlBody // 'a'
]

{ #category : #accessing }
MsalOneNotePage >> htmlRawViewOn: aView [
	<gtView>
	
	^ aView textEditor
		title: 'HTML (raw)';
		priority: 50;
		text: [ self htmlString ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNotePage >> htmlString [

	htmlString ifNotNil: [ ^ htmlString ].
	
	^ htmlString := self application get: self htmlUrl
]

{ #category : #accessing }
MsalOneNotePage >> htmlUrl [

	^ (self rawData at: 'contentUrl') asUrl
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
MsalOneNotePage >> liveViewOn: aView [
	<gtView>
	
	^ aView explicit
		title: 'Live';
		priority: 12;
		stencil: [ MsalOneNotePageElementVisitor visit: self ];
		actionUpdateButton
]

{ #category : #accessing }
MsalOneNotePage >> markdown [

	| pySource |
	pySource := 'import html2text
h = html2text.HTML2Text()
h.handle(input)'.

	^ PBApplication uniqueInstance
		sendSource: pySource 
		withBindings: { #input -> self htmlString }
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

	| apiTitle htmlTitleElement htmlTitle objectReplacementCharacterValue wasTitleHandwritten |
	apiTitle := (self rawData at: 'title') trimRight.
	htmlTitleElement := self htmlHeadElements detect: [ :element | element name = 'title' ].
	htmlTitle := htmlTitleElement contentString trimRight.
	objectReplacementCharacterValue := 65532. "per https://www.charset.org/utf-8/66"
	
	"No added value from html title"
	wasTitleHandwritten := htmlTitle size = 1 and: [ htmlTitle first asciiValue = objectReplacementCharacterValue ].
	(wasTitleHandwritten or: [ htmlTitle isEmpty or: [ htmlTitle = apiTitle ] ]) ifTrue: [ ^ apiTitle ].
	
	(htmlTitle includesSubstring: apiTitle) ifFalse: [ self error: 'violated assumption that html title is addition to api title' ].
	
	^ htmlTitle
]

{ #category : #accessing }
MsalOneNotePage >> url [

	^ self class url / self id
]
