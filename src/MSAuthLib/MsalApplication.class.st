Class {
	#name : #MsalApplication,
	#superclass : #Object,
	#instVars : [
		'accessToken',
		'pythonInstance',
		'id',
		'authorityUrl',
		'client'
	],
	#category : #MSAuthLib
}

{ #category : #accessing }
MsalApplication >> accessToken [

	accessToken ifNil: [ self logIn ].
	^ accessToken
]

{ #category : #accessing }
MsalApplication >> accessToken: anObject [

	accessToken := anObject
]

{ #category : #accessing }
MsalApplication >> authorityUrl [

	^ authorityUrl ifNil: [ 'https://login.microsoftonline.com/common/' asUrl ]
]

{ #category : #accessing }
MsalApplication >> authorityUrl: anObject [

	authorityUrl := anObject
]

{ #category : #accessing }
MsalApplication >> client [

	| client |
	client ifNotNil: [ ^ client ].
	
	client := ZnClient new.
	self accessToken configureClient: client.
	^ client
]

{ #category : #accessing }
MsalApplication >> get: aUrl do: aBlock [

	| response |
	response := self client
		url: aUrl;
		get.
		
	^ aBlock value: response
]

{ #category : #accessing }
MsalApplication >> getJsonAt: aUrl do: aBlock [

	^ self
		get: aUrl
		do: [ :response |
			| json |
			json := STONJSON fromString: response.
			json 
				at: 'error'
				ifPresent: [ :err | 
					| errMsg |
					errMsg := err at: 'message'.
					self error: errMsg ].
			aBlock value: json ]
]

{ #category : #accessing }
MsalApplication >> get_accounts [

	| response |
	response := self pythonInstance send: #get_accounts.
	^ response collect: [ :aDictionary | 
		MsalAccount 
			fromDictionary: aDictionary 
			forApplication: self ]
			
	"
	- Optional username parameter
	- Reference: https://msal-python.readthedocs.io/en/latest/index.html#msal.PublicClientApplication.get_accounts"
]

{ #category : #accessing }
MsalApplication >> id [

	^ id
]

{ #category : #accessing }
MsalApplication >> id: anObject [

	id := anObject
]

{ #category : #accessing }
MsalApplication >> logIn [

	| tokenResponse |
	tokenResponse := self
		pythonSend: '
response = app.acquire_token_interactive(scopes=scopes)
response' 
		withBindings: {
			#app -> self pythonInstance.
			#scopes -> self scopes }.
	accessToken := MsalAccessToken 
		fromDictionary: tokenResponse
		forApplication: self
]

{ #category : #accessing }
MsalApplication >> oneNote [
	
	^ MsalOneNote forApplication: self
]

{ #category : #accessing }
MsalApplication >> pages [

	| baseUrl endpoint url client pagesResponse pagesJson |
	baseUrl := 'https://graph.microsoft.com/v1.0/' asUrl.
	endpoint := baseUrl / 'me'.
	url := endpoint asUrl / 'onenote' / 'pages'.
	client := ZnClient new.
	self accessToken configureClient: client.
	pagesResponse := client
		url: url;
		get.
	^ pagesJson := STONJSON fromString: pagesResponse
]

{ #category : #accessing }
MsalApplication >> pythonInstance [

	pythonInstance ifNotNil: [ ^ pythonInstance ].
	
	^ pythonInstance := self
		pythonSend: 'app = msal.PublicClientApplication(client_id=app_id,authority=authority_url)
app' 
		withBindings: {
			#app_id -> self id.
			#authority_url -> self authorityUrl asString }
]

{ #category : #accessing }
MsalApplication >> pythonInstance: anObject [

	pythonInstance := anObject
]

{ #category : #accessing }
MsalApplication >> pythonSend: aString withBindings: convertibleToDictionary [ 

	^ PBApplication uniqueInstance 
		sendSource: 'import msal
' , aString
		withBindings: convertibleToDictionary
]

{ #category : #accessing }
MsalApplication >> scopes [
	"Default to using scopes granted in Azure dashboard. You can also explicitly specify scopes e.g. { 'User.Read'. 'Notes.Read' }"
	^ { 'https://graph.microsoft.com/.default' }
]
