Class {
	#name : #MoldableAnalysisPresentation,
	#superclass : #Object,
	#category : #MoldableAnalysisPresentation
}

{ #category : #utils }
MoldableAnalysisPresentation >> codeFromMethod: aMethod [
	| notTemp |
	notTemp := aMethod ast body children detect: [:aNode | aNode isTemp not ].

	^ String streamContents: [ :stream |
		aMethod ast comments ifNotEmpty: [
			stream
				nextPutAll: '"';
				nextPutAll: aMethod ast comments first contents;
				nextPutAll: '"';
				nextPutAll: String cr].
			
		(aMethod sourceCode 
			copyFrom: notTemp start to: aMethod ast stop) linesDo: [ :aLine |
				stream 
					nextPutAll: (aLine removePrefix: String tab);
					cr ] ]
]

{ #category : #utils }
MoldableAnalysisPresentation >> codeFromSelector: aSelector [
	^ self codeFromMethod: self class >> aSelector
]

{ #category : #code }
MoldableAnalysisPresentation >> downloadArgoUMLCodeAndMSE [
	| targetFolder archiveFileName archiveUrl |
	"Download ArgoUML code and MSE model file"
	targetFolder := 'models' asFileReference ensureCreateDirectory.
	archiveFileName := 'ArgoUML-0-34.zip'.
	archiveUrl := 'https://dl.feenk.com/moose-tutorial/argouml/'. 
	ZnClient new
		url: archiveUrl, archiveFileName;
		signalProgress: true;
		downloadTo: targetFolder.
	(ZipArchive new 
		readFrom: targetFolder / archiveFileName) 
		extractAllTo: targetFolder.
	targetFolder
]

{ #category : #code }
MoldableAnalysisPresentation >> extractBuildFoldersAndFiles [
	| interestingDirectories model |
	interestingDirectories := model rootFolder/ 'src' withDeepCollect: [: each | 
		(each files anySatisfy: [ :f |
			f basename asLowercase = 'build.xml' ])
				ifTrue: [ #() ]
				ifFalse: [ each directories ] ].        
]

{ #category : #code }
MoldableAnalysisPresentation >> extractUsedDeprecatedClasses [
	| model deprecatedClasses stillUsedClasses |
	"Used deprecated classes"

	deprecatedClasses := model allModelClasses select: [ :each |
		each isAnnotatedWith: 'Deprecated' ].

	stillUsedClasses := deprecatedClasses select: [ :each |
		(each isAnnotatedWith: 'Deprecated') and: [
			each clientTypes isNotEmpty ] ]
]

{ #category : #code }
MoldableAnalysisPresentation >> getArgoUMLModel [
	| model |
	model := MooseModel root allModels detect: [ :each | 
		each name = 'ArgoUML-0-34' ]
]

{ #category : #code }
MoldableAnalysisPresentation >> loadMSEModelIntoImage [
	"Load the MSE file into a FAMIX model"
	| modelFile model |
	modelFile := 'models' asFileReference
		/ 'ArgoUML-0-34'
		/ 'ArgoUML-0-34.mse'.
	model := MooseModel new
		importMSEFromFile: modelFile.
	model
]

{ #category : #code }
MoldableAnalysisPresentation >> saveTheModel [
	"Save the model so we can reuse it other sides"
	| model |
	MooseModel root add: model
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide1For: aSlide [
	"<gtSlide>"
	^ aSlide element
		priority: 1.1;
		element: [| form |
			form := PNGReadWriter formFromFileNamed: (Path 
				* 'MooseEngines.png') fullName.
			"form := PNGReadWriter formFromFileNamed: (GtResourceReference
					path: Path * 'feenkcom' / 'gtoolkit' / 'doc' / 'feenk.png') fullName."
			BlElement new 
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical matchParent ];
				addChild: form asElement asScalableElement 
					fitWidth ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide2For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 2;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #downloadArgoUMLCodeAndMSE. 
				self codeFromSelector: #loadMSEModelIntoImage.
				self codeFromSelector: #saveTheModel
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide3For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 3;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #extractUsedDeprecatedClasses.
				self codeFromSelector: #visualizeDeprecatedClasses
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide4For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 4;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #extractUsedDeprecatedClasses.
				self codeFromSelector: #visualizeDeprecatedClassesWithSize
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide5For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 5;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #extractUsedDeprecatedClasses.
				self codeFromSelector: #visualizeDeprecatedClassesWithMethods
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide6For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 6;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #extractUsedDeprecatedClasses.
				self codeFromSelector: #visualizeDeprecatedClassesWithMethodWithUsageSize
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide7For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 7;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #extractBuildFoldersAndFiles.
				self codeFromSelector: #visualizeBuildFiles
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> titleSlideFor: aSlide [
	<gtSlide>
	^ aSlide title
		priority: 1;
		titleWithFormat: ('Moldable Analysis' asRopedText 
			fontSize: 80;
			glamorousRegularFont;
			thin; 
			in: [:t | (t from: 'Moldable' size + 1 to: t size) bold]; yourself)
]

{ #category : #code }
MoldableAnalysisPresentation >> visualizeBuildFiles [
	| interestingDirectories view |
	view := GtMondrian new.
	view nodes
		shape: [ :each |
			BlElement new
				size: 5@5;
				geometry: BlCircle new;
            background: ((each files anySatisfy: [ :f |
					f basename asLowercase = 'build.xml'])
						ifTrue: [  Color red]
						ifFalse: [Color gray])  ];
		with: interestingDirectories.
	view edges connectFrom: #parent.
	view layout tree. 
	view
]

{ #category : #code }
MoldableAnalysisPresentation >> visualizeDeprecatedClasses [
	| view stillUsedClasses |
	view := GtMondrian new. 
	
	view nodes
		shape: [:each |
			BlElement new
				size: 5@5;
				geometry: BlCircle new;
				background:((each isAnnotatedWith: 'Deprecated')
					ifTrue: [Color red]
					ifFalse: [Color gray]) ];
		with: (stillUsedClasses, (stillUsedClasses flatCollect: #clientTypes)) asSet.

	view edges connectFromAll: #clientTypes. 
	view layout force. 
	view
]

{ #category : #code }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesWithMethodWithUsageSize [
	| deprecateMethods clientMethods interestingMethods view stillUsedClasses |
	deprecateMethods := (stillUsedClasses flatCollect: #methods)
		select: [ :aMethod | aMethod clientTypes notEmpty ].
	clientMethods := (deprecateMethods collect: [ :aMethod | 
		aMethod clientMethods reject: [ :each | 
	each parentType = aMethod parentType ] ]) flatten.
	interestingMethods := deprecateMethods, clientMethods.
	
	view := GtMondrian new.
	view nodes 
		shape: [ :each |
			BlElement new 
				padding: (BlInsets all: 2);
				constraintsDo: [:c | 
					c horizontal fitContent.
					c vertical fitContent ];
				background: ((each isAnnotatedWith: 'Deprecated')
					ifTrue: [ Color lightRed ]
					ifFalse: [ Color veryLightGray ]) ];
		with: (stillUsedClasses, 
			(stillUsedClasses flatCollect: #clientTypes)) asSet;
		forEach: [ :aClass |
			view nodes
				shape: [ :each |
					BlElement new
						margin: (BlInsets all: 2);
						geometry: BlCircle new;
						size: ((each parentType 
							isAnnotatedWith: 'Deprecated')
								ifTrue: [ (each clientMethods 
									intersection: clientMethods) size + 5  ]
								ifFalse: [ 5 ]) asPoint;
						background: Color gray ];
				with:(aClass methods intersection: interestingMethods).
			view layout rectanglePack ].
	view edges connectFromAll: #clientTypes.
	view layout force
		strength: 0.15;
		charge: -250;
		length: 70.
	view
]

{ #category : #code }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesWithMethods [
	| deprecateMethods clientMethods interestingMethods view stillUsedClasses |
	deprecateMethods := (stillUsedClasses flatCollect: #methods)
		select: [ :aMethod | aMethod clientTypes notEmpty ].
	clientMethods := (deprecateMethods collect: [ :aMethod | 
		aMethod clientMethods reject: [ :each | 
	each parentType = aMethod parentType ] ]) flatten.
	interestingMethods := deprecateMethods, clientMethods.
	
	view := GtMondrian new.
	view nodes 
		shape: [ :each |
			BlElement new 
				background: ((each isAnnotatedWith: 'Deprecated')
					ifTrue: [ Color lightRed ]
					ifFalse: [ Color veryLightGray ]) ];
		with: (stillUsedClasses, 
			(stillUsedClasses flatCollect: #clientTypes)) asSet;
		forEach: [ :aClass |
			view nodes
				shape: [ :each |
					BlElement new 
						size: 5@5;
						background: Color gray ];
				with:(aClass methods intersection: interestingMethods).
			view layout grid ].
	view edges connectFromAll: #clientTypes.
	view layout force
		strength: 0.15;
		charge: -250;
		length: 70.
	view
]

{ #category : #code }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesWithSize [
	| view stillUsedClasses |
	view := GtMondrian new.
	view nodes 
		shape: [ :each |
			BlElement new 
				size: (each numberOfMethods min: 50) asPoint;
				geometry: BlCircle new;
				background: ((each isAnnotatedWith: 'Deprecated')
					ifTrue: [ Color red ]
					ifFalse: [ Color gray ]);
				border: (BlBorder paint: 
					((each mooseName includesSubstring: '::ui')
						ifTrue: [ Color blue ]
						ifFalse: [ Color transparent ])) ];
		with: (stillUsedClasses, 
			(stillUsedClasses flatCollect: #clientTypes)) asSet.
	view edges connectFromAll: #clientTypes.
	view layout force
		strength: 0.15;
		charge: -250;
		length: 70.
	view
]

{ #category : #code }
MoldableAnalysisPresentation >> visualizeXMLFileTargets [
	| tags view |
	tags := self // 'target'.
	view := GtMondrian new.
	view nodes with: tags.
	view edges connectFromAll:  [:aTag | |depends|
		depends:=(aTag @ 'depends') stringValue splitOn: ', '.
		tags select: [ :each | 
			depends includes: (each @ 'name') stringValue] ].
	view layout dominanceTree.
	view.
]