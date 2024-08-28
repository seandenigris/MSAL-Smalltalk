Class {
	#name : #BaselineOfMSAL,
	#superclass : #BaselineOf,
	#category : #BaselineOfMSAL
}

{ #category : #baseline }
BaselineOfMSAL >> baseline: spec [
	<baseline>
	
	spec for: #'common' do: [
		spec
			baseline: #'ResourcesLive' with: [
				spec repository: 'github://seandenigris/Resources-Live' ].
				
		spec package: #'MSAuthLib' with: [ spec requires: #(ResourcesLive) ] ]
]

{ #category : #accessing }
BaselineOfMSAL >> customProjectAttributes [
	^ self isGTImage
			ifFalse: [ #(notGToolkit) ]
			ifTrue: [ #(GToolkit) ]
]

{ #category : #accessing }
BaselineOfMSAL >> isGTImage [
	
	^ RPackageOrganizer default packageNames anySatisfy: [ :pn | pn beginsWith: 'Lepiter-' ].
	"Implementation note: used to check for GToolkit prefix, but P7 has a GToolkit-Examples package. Lepiter, OTOH, could only be loaded in a GT image"
]
