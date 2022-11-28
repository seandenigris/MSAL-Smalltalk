"
nil
"
Class {
	#name : #MsalNotePageStatus,
	#superclass : #Object,
	#instVars : [
		'timestamp'
	],
	#classInstVars : [
		'label'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalNotePageStatus class >> label [
	^ label ifNil: [ 
		| labelFromName |
		labelFromName := self name copyFrom: 'MsalNotePage' size + 1 to: self name size - 'Status' size.
		labelFromName normalizeCamelCase ]
]

{ #category : #accessing }
MsalNotePageStatus class >> label: aString [
	label := aString
]

{ #category : #comparing }
MsalNotePageStatus >> = rhs [

	^ self class = rhs class and: [ self timestamp = rhs timestamp ]
]

{ #category : #comparing }
MsalNotePageStatus >> hash [

	^ self class hash bitXor: self timestamp hash
]

{ #category : #testing }
MsalNotePageStatus >> isActive [
	^ false
]

{ #category : #accessing }
MsalNotePageStatus >> isExternallyDeleted [
	^ false
]

{ #category : #testing }
MsalNotePageStatus >> isInactive [
	^ false
]

{ #category : #accessing }
MsalNotePageStatus >> printOn: aStream [
	
	aStream
		nextPutAll: self class label;
		space;
		nextPutAll: 'Status'
]

{ #category : #accessing }
MsalNotePageStatus >> timestamp [

	^ timestamp
]

{ #category : #accessing }
MsalNotePageStatus >> timestamp: aDateAndTime [

	"Translate to UTC because Pharo's Date offset support is fatally broken. See [Pharo Issue 12147: Date>>#= fooled by daylight savings time](https://pharo.fogbugz.com/default.asp?12147)"
	timestamp := aDateAndTime translateToUTC
]
