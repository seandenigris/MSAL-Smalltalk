Class {
	#name : #MsalNotePageDelete,
	#superclass : #MsalNotePageSyncCommand,
	#category : #'MSAuthLib-OneNote'
}

{ #category : #execution }
MsalNotePageDelete >> execute [

	self page status: MsalNotePageDeletedExternallyStatus new
]
