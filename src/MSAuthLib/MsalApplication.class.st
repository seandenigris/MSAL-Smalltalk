Class {
	#name : #MsalApplication,
	#superclass : #Object,
	#instVars : [
		'accessToken',
		'pythonInstance',
		'id',
		'authorityUrl',
		'client',
		'oneNote'
	],
	#category : #MSAuthLib
}

{ #category : #fuel }
MsalApplication class >> fuelIgnoredInstanceVariableNames [

	^ #('accessToken' 'pythonInstance' 'client')
]

{ #category : #accessing }
MsalApplication >> accessToken [

	accessToken ifNil: [ self logIn ].
	^ accessToken
]

{ #category : #accessing }
MsalApplication >> accessToken: anObject [

	accessToken := anObject.
	accessToken ifNotNil: [ accessToken configureClient: self client ].
]

{ #category : #accessing }
MsalApplication >> acquireToken [
	
	^ self acquire_token_silent 
		ifNotNil: [ :token | token ]
		ifNil: [ self acquire_token_interactive ]
		
	"Adapted from https://github.com/AzureAD/microsoft-authentication-library-for-python/blob/dev/sample/interactive_sample.py#L47"
]

{ #category : #accessing }
MsalApplication >> acquire_token_interactive [

	^ self
		pythonSend: '
response = app.acquire_token_interactive(scopes=scopes)
response'
		withBindings: {
			#app -> self pythonInstance.
			#scopes -> self scopes}.
			
	"Reference: https://msal-python.readthedocs.io/en/latest/index.html#msal.PublicClientApplication.acquire_token_interactive"
]

{ #category : #accessing }
MsalApplication >> acquire_token_silent [

	self get_accounts ifEmpty: [ ^ nil ].
	
	^ self
		pythonSend: '
response = app.acquire_token_silent(scopes, app.get_accounts()[0])
response' 
		withBindings: {
			#app -> self pythonInstance.
			#scopes -> self scopes }.
			
	"Reference: https://msal-python.readthedocs.io/en/latest/index.html#msal.PublicClientApplication.acquire_token_silent"
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
	client ifNotNil: [ ^ client ].

	client := ZnClient new
		systemPolicy;
		autoResetEntityMethods: #(GET POST HEAD DELETE);
		yourself.

	^ client
]

{ #category : #accessing }
MsalApplication >> client: anObject [
	
	client := anObject
]

{ #category : #accessing }
MsalApplication >> clientHTTP: aSelector jsonAt: aUrl do: aBlock [

	^ self
		clientHTTP: aSelector
		url: aUrl
		contentReader: [ :response |
			| json |
			json := STONJSON fromString: response contents.
			json 
				at: 'error'
				ifPresent: [ :err | 
					| errMsg |
					errMsg := err at: 'message'.
					self error: errMsg ].
			aBlock value: json ]
]

{ #category : #accessing }
MsalApplication >> clientHTTP: aSelector url: aUrl contentReader: aBlock [

	
	^ [ self client 
			contentReader: aBlock;
			url: aUrl;
			perform: aSelector
	]
		on: ZnHttpUnsuccessful
		do: [ :err |
			err response code = 401 
				ifTrue: [ 
					self logIn.
					self client perform: aSelector ]
				ifFalse: [ err pass ] ]
]

{ #category : #accessing }
MsalApplication >> delete: aUrl [

	self client delete: aUrl.
]

{ #category : #accessing }
MsalApplication >> get: aUrl [

	^ self 
		get: aUrl 
		contentReader: [ :response | 
			response ifNotNil: [ response contents ] ]
]

{ #category : #accessing }
MsalApplication >> get: aUrl contentReader: aBlock [
	
	^ self 
		clientHTTP: #get 
		url: aUrl 
		contentReader: aBlock
]

{ #category : #accessing }
MsalApplication >> getJsonAt: aUrl do: aBlock [

	^ self
		clientHTTP: #get 
		jsonAt: aUrl 
		do: aBlock
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
MsalApplication >> graphMetadata [

	^ self
		get: self graphServiceRootUrl / '$metadata'
		contentReader: [ :r | XMLDOMParser parse: r contents ]
		
	"Reference: https://learn.microsoft.com/en-us/graph/traverse-the-graph#microsoft-graph-api-metadata"
]

{ #category : #accessing }
MsalApplication >> graphServiceRootUrl [
	^ 'https://graph.microsoft.com/v1.0' asUrl
]

{ #category : #accessing }
MsalApplication >> head: aUrl responseDo: aBlock [

	self client head: aUrl.
	^ aBlock value: client response
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

	self acquireToken
		ifNil: [ self error: 'log in failed!' ]
		ifNotNil: [ :aDictionary |
			| token |
			token := MsalAccessToken 
				fromDictionary: aDictionary
				forApplication: self.
			self accessToken: token ]
]

{ #category : #accessing }
MsalApplication >> logOut [
	
	self get_accounts ifNotEmpty: [ 
		self 
			pythonSend: '
account = app.get_accounts()[0]
app.remove_account(account)'
			withBindings: {#app -> self pythonInstance} ].
				
	self reset.
	
	Smalltalk tools webBrowser new
		open: 'https://login.microsoftonline.com/common/oauth2/v2.0/logout'
]

{ #category : #accessing }
MsalApplication >> oneNote [
	
	^ oneNote ifNil: [ oneNote := MsalOneNote forApplication: self ]
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
MsalApplication >> reset [
	self pythonInstance: nil.	
	
	"Make sure credentials are cleared from memory so that they are not saved with the image. Tried to becomeForward -> nil, but apparently that's not allowed because there was an error"
	accessToken
		ifNotNil: [ accessToken becomeForward: MsalAccessToken new.
			self accessToken: nil ].
	client
		ifNotNil: [ client becomeForward: ZnClient new.
			self client: nil ]
]

{ #category : #accessing }
MsalApplication >> scopes [
	"Default to using scopes granted in Azure dashboard. You can also explicitly specify scopes e.g. { 'User.Read'. 'Notes.Read' }"
	^ { 'https://graph.microsoft.com/.default' }
]

{ #category : #accessing }
MsalApplication >> shutDown: isImageQuitting [
	"To use, register with SessionManager and send from-class side method of same name. See implementors"

	isImageQuitting ifFalse: [ ^ self ].
	
	self logOut
]
