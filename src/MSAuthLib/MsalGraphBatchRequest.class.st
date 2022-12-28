Class {
	#name : #MsalGraphBatchRequest,
	#superclass : #Object,
	#instVars : [
		'posts',
		'graphVersion'
	],
	#category : #MSAuthLib
}

{ #category : #examples }
MsalGraphBatchRequest class >> exampleGraphV1 [
	<gtExample>
	
	| result |
	result := self forGraphV1.
	self assert: result graphVersionEndpoint equals: 'https://graph.microsoft.com/v1.0' asUrl
]

{ #category : #examples }
MsalGraphBatchRequest class >> forGraphV1 [

	^ self forGraphVersion: 'v1.0'
]

{ #category : #'instance creation' }
MsalGraphBatchRequest class >> forGraphVersion: aString [

	^ self new
		graphVersion: aString;
		yourself
]

{ #category : #accessing }
MsalGraphBatchRequest >> addPost [

	| post |
	post := MsalGraphBatchPost fromRootUrl: self graphVersionEndpoint.
	self posts add: post
]

{ #category : #accessing }
MsalGraphBatchRequest >> addRequest: aRequest [

	| hasAvailablePost |
	hasAvailablePost := self posts isNotEmpty and: [ self posts last requests size < 20 ].
	hasAvailablePost ifFalse: [ self addPost ].
	self posts last requests add: aRequest.
]

{ #category : #accessing }
MsalGraphBatchRequest >> graphVersion [

	^ graphVersion
]

{ #category : #accessing }
MsalGraphBatchRequest >> graphVersion: anObject [

	graphVersion := anObject
]

{ #category : #accessing }
MsalGraphBatchRequest >> graphVersionEndpoint [

	^ 'https://graph.microsoft.com' asUrl / self graphVersion
]

{ #category : #accessing }
MsalGraphBatchRequest >> gtRequestsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Requests';
		priority: 50;
		items: [ self posts flatCollect: #requests ];
		column: 'Method' 
			text: [ :eachItem | 
				'GET' ]
			width: 50;
		column: 'URL' 
			text: [ :eachItem | eachItem url ].
]

{ #category : #accessing }
MsalGraphBatchRequest >> posts [

	^ posts ifNil: [ posts := OrderedCollection new ]
]

{ #category : #accessing }
MsalGraphBatchRequest >> posts: anObject [

	posts := anObject
]

{ #category : #accessing }
MsalGraphBatchRequest >> requests: aCollection [
	self posts removeAll.
	aCollection do: [ :e | self addRequest: e ]
]

{ #category : #sending }
MsalGraphBatchRequest >> sendTo: application [

	^ self posts flatCollect: [ :post | post sendTo: application ]
]
