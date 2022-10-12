Class {
	#name : #MsalAccessToken,
	#superclass : #MsalObject,
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalAccessToken >> configureClient: aZnClient [

	aZnClient headerAt: 'Authorization' put: 'Bearer ' , (self rawData at: 'access_token')
]
