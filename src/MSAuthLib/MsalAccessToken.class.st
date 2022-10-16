Class {
	#name : #MsalAccessToken,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalAccessToken >> configureClient: aZnClient [

	aZnClient setBearerAuthentication: (self rawData at: 'access_token')
]
