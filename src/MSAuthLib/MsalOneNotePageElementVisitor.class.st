Class {
	#name : #MsalOneNotePageElementVisitor,
	#superclass : #MsalOneNotePageVisitor,
	#instVars : [
		'element'
	],
	#category : #'MSAuthLib-GToolkit'
}

{ #category : #accessing }
MsalOneNotePageElementVisitor >> element [
	element ifNotNil: [ ^ element ].
	
	^ element := BrVerticalPane new
		matchParent;
		yourself
]

{ #category : #accessing }
MsalOneNotePageElementVisitor >> element: aBlElement [

	element := aBlElement 
]

{ #category : #accessing }
MsalOneNotePageElementVisitor >> visit: aPage [

	super visit: aPage.
	^ self element
]

{ #category : #accessing }
MsalOneNotePageElementVisitor >> visitAnchorElement: anXMLElement [
	
	| url clickAttr text |
	url := anXMLElement attributeAt: #href.
	clickAttr := BrTextClickAttribute new 
		beNotOverwritableByStyler;
		action: [ :aText :aTarget :aTextEditor :anEvent | 
			Smalltalk tools webBrowser open: url  ].
	text := url asRopedText
		attribute: clickAttr;
		"bold; what is the Lepiter link styling"
		yourself.
		
	self element addChild: (BlTextElement text: text).
]

{ #category : #accessing }
MsalOneNotePageElementVisitor >> visitCreationTimetamp: aDateAndTime [
	"self project status timestamp: aDateAndTime."
]

{ #category : #accessing }
MsalOneNotePageElementVisitor >> visitImage: anRlResource [
	
	| imageElement |
	imageElement := (Form fromBinaryStream: anRlResource file binaryReadStream) asElement
		when: BlDoubleClickEvent 
			do: [ :anEvent | 
				anEvent target phlow spawnObject: anRlResource.
				anEvent consumed: true  ];
		yourself.
	
	self element addChild: imageElement asScalableElement.
]

{ #category : #accessing }
MsalOneNotePageElementVisitor >> visitTitle: aString [

	| textEl |
	textEl := BlTextElement text: aString asRopedText bold underline.
	self element addChild: textEl
]
