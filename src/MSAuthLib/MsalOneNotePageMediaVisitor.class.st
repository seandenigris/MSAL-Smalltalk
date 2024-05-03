Class {
	#name : #MsalOneNotePageMediaVisitor,
	#superclass : #MsalOneNotePageVisitor,
	#instVars : [
		'images'
	],
	#category : #'MSAuthLib-GToolkit'
}

{ #category : #accessing }
MsalOneNotePageMediaVisitor >> images [
	^ images ifNil: [ images := OrderedCollection new ]
]

{ #category : #accessing }
MsalOneNotePageMediaVisitor >> images: anObject [
	images := anObject
]

{ #category : #accessing }
MsalOneNotePageMediaVisitor >> visit: aPage [

	super visit: aPage.
	^ self images
]

{ #category : #accessing }
MsalOneNotePageMediaVisitor >> visitImage: aOneNoteImage [

	self images add: aOneNoteImage
]
