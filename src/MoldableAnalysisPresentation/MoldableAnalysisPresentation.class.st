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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> downloadArgoUMLCodeAndMSE [
	<gtExample>
	<noTest>
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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> extractBuildFoldersAndFilesFromModel: model [
	<gtExample>
	| interestingDirectories |
	interestingDirectories := model rootFolder/ 'src' withDeepCollect: [: each | 
		(each files anySatisfy: [ :f |
			f basename asLowercase = 'build.xml' ])
				ifTrue: [ #() ]
				ifFalse: [ each directories ] ].        
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> extractDeprecatedGraphicalComponentsFrom: graphicalComponents [
	<gtExample>
	graphicalComponents select: [ :each |
		each providerTypes anySatisfy: [ :provider |
			provider isAnnotatedWith: 'Deprecated'] ]
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> extractGraphicalComponentsFrom: model [
	<gtExample>
	| graphicalComponents |
	graphicalComponents := model allModelClasses select: [ :aClass |
		aClass superclassHierarchyGroup anySatisfy: [ :aSuperclass |
			aSuperclass mooseName = 'java::awt::Component' ] ]
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> extractUsedDeprecatedClassesFrom: model [
	<gtExample>
	| deprecatedClasses stillUsedClasses |
	"Used deprecated classes"

	deprecatedClasses := model allModelClasses select: [ :each |
		each isAnnotatedWith: 'Deprecated' ].

	stillUsedClasses := deprecatedClasses select: [ :each |
		(each isAnnotatedWith: 'Deprecated') and: [
			each clientTypes isNotEmpty ] ]
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> getArgoUMLModel [
	<gtExample>
	<noTest>
	| model |
	model := MooseModel root allModels detect: [ :each | 
		each name = 'ArgoUML-0-34' ]
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> loadMSEModelIntoImage [
	<gtExample>
	<noTest>
	"Load the MSE file into a FAMIX model"
	| modelFile model |
	modelFile := 'models' asFileReference
		/ 'ArgoUML-0-34'
		/ 'ArgoUML-0-34.mse'.
	model := MooseModel new
		importMSEFromFile: modelFile.
	model
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> openArgoUmlReportOn: model [
	<gtExample>
	ArgoUMLReport onModel: model
]

{ #category : #'code examples' }
MoldableAnalysisPresentation >> saveTheModel: model [
	<gtExample>
	"Save the model so we can reuse it other sides"
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
				self codeFromSelector: #saveTheModel:
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
				self codeFromSelector: #extractUsedDeprecatedClassesFrom:.
				self codeFromSelector: #visualizeDeprecatedClassesFor:
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
				self codeFromSelector: #extractUsedDeprecatedClassesFrom:.
				self codeFromSelector: #visualizeDeprecatedClassesWithSizeFor:
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
				self codeFromSelector: #extractUsedDeprecatedClassesFrom:.
				self codeFromSelector: #visualizeDeprecatedClassesWithMethodsFor:
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
				self codeFromSelector: #extractUsedDeprecatedClassesFrom:.
				self codeFromSelector: #visualizeDeprecatedClassesWithMethodWithUsageSizeFor:
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
				self codeFromSelector: #extractBuildFoldersAndFilesFromModel:.
				self codeFromSelector: #visualizeBuildFilesFrom:
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide8For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 8;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #extractGraphicalComponentsFrom:.
				self codeFromSelector: #extractDeprecatedGraphicalComponentsFrom:
			}) asElement. ]
]

{ #category : #slides }
MoldableAnalysisPresentation >> slide9For: aSlide [
	<gtSlide>
	^ aSlide element
		priority: 9;
		element: [
			(GtPlaygroundLiveSlide new snippets: {
				self codeFromSelector: #getArgoUMLModel. 
				self codeFromSelector: #openArgoUmlReportOn:
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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> visualizeBuildFilesFrom: interestingDirectories [
	<gtExample>
	| view |
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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesFor: stillUsedClasses [
	<gtExample>
	| view |
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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesWithMethodWithUsageSizeFor: stillUsedClasses [
	<gtExample>
	| deprecateMethods clientMethods interestingMethods view |
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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesWithMethodsFor: stillUsedClasses [
	<gtExample>
	| deprecateMethods clientMethods interestingMethods view |
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

{ #category : #'code examples' }
MoldableAnalysisPresentation >> visualizeDeprecatedClassesWithSizeFor: stillUsedClasses [
	<gtExample>
	| view |
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

{ #category : #'code examples' }
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
