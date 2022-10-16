Class {
	#name : #MsalAccount,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #comparing }
MsalAccount >> = rhs [

	self species = rhs species ifFalse: [ ^ false ].
	^ self username = rhs username
]

{ #category : #comparing }
MsalAccount >> hash [

	^ self username hash
]

{ #category : #accessing }
MsalAccount >> printOn: aStream [
	self username ifNotNil: [ :name |
		aStream nextPutAll: name ].
	super printOn: aStream.
]

{ #category : #accessing }
MsalAccount >> username [

	^ self rawData at: 'username'
]
