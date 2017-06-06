FileStream startUp: true.
[| parentDir runner loader starting |
FileStream stdout nextPutAll: 'Installing SOM benchmarks'.

Utilities setAuthorInitials: 'SomLoader'.

parentDir := (FileDirectory default fileNamed: Smalltalk documentPath)
	directoryEntry containingDirectory.

#('Scripting.st' 'SomLoader-Compiler.st' 'SomLoader-Tests.st') do: [:ea |
	(parentDir fileNamed: ea) fileIn].

ByteString compile: 'asFileReference
    ^ FileDirectory default on: self' classified: '*SomLoader'.

DosFileDirectory compile: 'entries
    ^ super entries reject: [:e | e fullName includes: $#]' classified: '*SomLoader'.

Behavior compile: 'subclass: a instanceVariableNames: b classVariableNames: c package: d
    ^ self subclass: a instanceVariableNames: b classVariableNames: c poolDictionaries: '''' category: d' classified: '*SomLoader'.

Character compile: 'canBeGlobalVarInitial
    ^ self isLetter' classified: '*SomLoader-override'.

Time class methodDict at: #primUTCMicrosecondsClock put: (Time class >> #utcMicrosecondClock).

SmallInteger methodDict at: #'&' put: (SmallInteger >> #bitAnd:).
SmallInteger methodDict at: #'%' put: (SmallInteger >> #\\).

Integer compile: 'awfy
    ^ Harness new run: Smalltalk arguments' classified: '*SomLoader-TruffleSqueak'.

Smalltalk class compile: 'exit: code
    ^ Smalltalk quitPrimitive' classified: '*SomLoader'.

FileStream class compile: 'voidStdioHandlesForTruffleSqueak
    StdioFiles := Array new: 3.
    TheStdioHandles
        at: 1 put: 0;
        at: 2 put: 1;
        at: 3 put: 2.' classified: '*SomLoader-TruffleSqueak'.

Smalltalk at: #DiskStore put: FileDirectory.
FileDirectory class methodDict at: #delimiter put: (FileDirectory class >> #slash).

FileStream stdout nextPutAll: '== Run Tests'; cr.
runner := (Smalltalk classNamed: 'SomLoaderTests') suite run.

FileStream stdout nextPutAll: '== Load Code'; cr.
loader := (Smalltalk classNamed: 'SomLoader') load: parentDir fullName.
loader createClasses.
loader createMethods.

(runner hasPassed)
	ifFalse: [FileStream stderr nextPutAll: '==== Test errors ===='; cr; nextPutAll: runner printString; cr.].

FileStream stdout nextPutAll: '== Save and Exit'; cr.

PreferenceWizardMorph allInstances do: #delete.
SystemWindow allSubInstances do: #delete.

FileStream voidStdioHandlesForTruffleSqueak.
Smalltalk saveAs: 'AWFY'] on: Error do: [:e |
    FileStream stdout nextPutAll: e printString.
].

Project current addDeferredUIMessage: [
  FileStream voidStdioHandlesForTruffleSqueak.
  Smalltalk snapshot: true andQuit: true].
