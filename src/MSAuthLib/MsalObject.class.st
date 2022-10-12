Class {
	#name : #MsalObject,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'application'
	],
	#category : #MSAuthLib
}

{ #category : #'instance creation' }
MsalObject class >> fromDictionary: aDictionary forApplication: anMsalApplication [

	^ self new
		rawData: aDictionary;
		application: anMsalApplication;
		yourself
]

{ #category : #accessing }
MsalObject >> application [

	^ application
]

{ #category : #accessing }
MsalObject >> application: anObject [

	application := anObject
]

{ #category : #accessing }
MsalObject >> rawData [

	^ rawData
]

{ #category : #accessing }
MsalObject >> rawData: anObject [

	rawData := anObject
]
