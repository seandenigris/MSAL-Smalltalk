Class {
	#name : #MsalAccessToken,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #MSAuthLib
}

{ #category : #'instance creation' }
MsalAccessToken class >> fromDictionary: aDictionary [

	^ self new
		rawData: aDictionary;
		yourself
]

{ #category : #accessing }
MsalAccessToken >> configureClient: aZnClient [

	aZnClient headerAt: 'Authorization' put: 'Bearer ' , (self rawData at: 'access_token')
]

{ #category : #accessing }
MsalAccessToken >> rawData [

	^ rawData
]

{ #category : #accessing }
MsalAccessToken >> rawData: anObject [

	rawData := anObject
]
