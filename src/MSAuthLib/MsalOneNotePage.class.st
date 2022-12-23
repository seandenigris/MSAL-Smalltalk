"
nil
"
Class {
	#name : #MsalOneNotePage,
	#superclass : #MsalObject,
	#instVars : [
		'creationTimestamp',
		'htmlString',
		'doesContentExist',
		'title',
		'log'
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
MsalOneNotePage class >> urlFromRoot: aUrl [

	^ aUrl / 'pages' ? ('$top' -> 100) & ('$orderby' -> 'createdDateTime desc') & ('count' -> true)
	
	"
	Other possible parameter examples:
	- ?search=""Socrates""
	
	Implementation note: was sorting by modification timestamp, but apparently notes are considered 'modified' every time they are opened in the One Note client
	
	Query parameters reference: https://learn.microsoft.com/en-us/graph/query-parameters"
]

{ #category : #accessing }
MsalOneNotePage >> contentQuery [

	| result |
	result := MsgNotePageContentQuery fromUrl: self htmlUrl.
	^ result
		onSuccess: [ :contentString | htmlString := contentString ];
		yourself
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

{ #category : #actions }
MsalOneNotePage >> delete [

	self application delete: self url.
	self status: MsalNotePageDeletedLocallyStatus new
	
	"Reference: https://learn.microsoft.com/en-us/graph/api/page-delete?view=graph-rest-1.0&tabs=http"
]

{ #category : #accessing }
MsalOneNotePage >> displayStringOn: aStream [
	aStream nextPutAll: self title
]

{ #category : #accessing }
MsalOneNotePage >> exists [
		
	^ self isContentMissing
	
	"Would like to do a HEAD, but fails with a 405 error
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

	(self isContentMissing or: [ htmlString isNotNil ]) ifTrue: [ ^ htmlString ].
	
	[ htmlString := self application get: self htmlUrl ]
		on: ZnHttpUnsuccessful
		do: [ :err |
			err response isNotFound 
				ifTrue: [ self status: MsalNotePageContentsMissingStatus new ]
				ifFalse: [ err pass ] ].
				
	^ htmlString
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
MsalOneNotePage >> isContentMissing [

	^ self status isKindOf: MsalNotePageContentsMissingStatus
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
MsalOneNotePage >> log [

	^ log ifNil: [ log := OrderedCollection new ]
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
MsalOneNotePage >> modificationTimestampUTC [

	^ self rawData at: 'lastModifiedDateTime'
]

{ #category : #accessing }
MsalOneNotePage >> parentSectionID [

	^ (self rawData at: 'parentSection') at: 'id'
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
MsalOneNotePage >> status [
	^ self log
		ifNotEmpty: [ :lg | lg last ]
		ifEmpty: [ 
			"We don't lazy initialize because it is done in #initialize"
			nil ]
]

{ #category : #accessing }
MsalOneNotePage >> status: aStatus [
	
	"This guard was added because Magritte was adding duplicate statuses"
	self status = aStatus ifTrue: [ ^ self ].
	
	aStatus timestamp ifNil: [ aStatus timestamp: DateAndTime now translateToUTC ].

	self log add: aStatus
]

{ #category : #'as yet unclassified' }
MsalOneNotePage >> syncFrom: newPage [ 
	
	self rawData: newPage rawData.
	htmlString := newPage htmlString.
	title := newPage title.
	
	self status class = newPage status class ifFalse: [ self status: newPage status ]
]

{ #category : #accessing }
MsalOneNotePage >> title [

	| apiTitle htmlTitleElement htmlTitle objectReplacementCharacterValue wasTitleHandwritten |
	
	title ifNotNil: [ ^ title ].
	
	apiTitle := (self rawData at: 'title') trimRight.
	
	self htmlString ifNil: [ ^ title := apiTitle ].
	
	htmlTitleElement := self htmlHeadElements detect: [ :element | element name = 'title' ].
	htmlTitle := htmlTitleElement contentString trimRight.
	objectReplacementCharacterValue := 65532. "per https://www.charset.org/utf-8/66"
	
	"No added value from html title"
	wasTitleHandwritten := htmlTitle size = 1 and: [ htmlTitle first asciiValue = objectReplacementCharacterValue ].
	(wasTitleHandwritten or: [ htmlTitle isEmpty or: [ htmlTitle = apiTitle ] ]) ifTrue: [ ^ title := apiTitle ].
	
	(htmlTitle includesSubstring: apiTitle) ifFalse: [ self error: 'violated assumption that html title is addition to api title' ].
	
	^ title := htmlTitle
]

{ #category : #accessing }
MsalOneNotePage >> updateStatus [

	| statusType |
	self htmlString.
	statusType := self isContentMissing
		ifTrue: [ MsalNotePageContentsMissingStatus ]
		ifFalse: [ MsalNotePageActiveStatus ].
		
	self status: statusType new
]

{ #category : #accessing }
MsalOneNotePage >> url [

	^ MsalOneNote url / 'pages' / self id
]
