Class {
	#name : #MsgBatchStepResponse,
	#superclass : #ZnResponse,
	#instVars : [
		'json',
		'request',
		'application'
	],
	#category : #MSAuthLib
}

{ #category : #'instance creation' }
MsgBatchStepResponse class >> json: aDictionary inResponseTo: request of: application [

	^ self new
		json: aDictionary;
		request: request;
		application: application;
		yourself
]

{ #category : #accessing }
MsgBatchStepResponse >> application [

	^ application
]

{ #category : #accessing }
MsgBatchStepResponse >> application: anObject [

	application := anObject
]

{ #category : #accessing }
MsgBatchStepResponse >> handle [
	| result |
	result := self request batchJsonReader 
		cull: self jsonBody 
		cull: self application.
	self request successBlock value: result.
	^ result
]

{ #category : #accessing }
MsgBatchStepResponse >> json [

	^ json
]

{ #category : #accessing }
MsgBatchStepResponse >> json: aDictionary [

	json := aDictionary.
	
	self statusLine: (ZnStatusLine code: self jsonStatus).
	headers := ZnHeaders withAll: self jsonHeaders.
	entity := ZnStringEntity type: self contentType.
	entity string: (STON toJsonString: self jsonBody).
]

{ #category : #accessing }
MsgBatchStepResponse >> jsonBody [
	^ self json at: 'body'
]

{ #category : #accessing }
MsgBatchStepResponse >> jsonHeaders [
	^ self json at: 'headers'
]

{ #category : #accessing }
MsgBatchStepResponse >> jsonStatus [
	^ self json at: 'status'
]

{ #category : #accessing }
MsgBatchStepResponse >> request [

	^ request
]

{ #category : #accessing }
MsgBatchStepResponse >> request: anObject [

	request := anObject
]
