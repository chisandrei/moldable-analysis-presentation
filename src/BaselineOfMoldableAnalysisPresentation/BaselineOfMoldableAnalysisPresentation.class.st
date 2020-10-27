Class {
	#name : #BaselineOfMoldableAnalysisPresentation,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoldableAnalysisPresentation
}

{ #category : #baselines }
BaselineOfMoldableAnalysisPresentation >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec
			baseline: 'ArgoumlArchitectureReport' with: [ 
				spec repository: 'github://feenkcom/argouml-report/src' ].
		spec 
			package: #'MoldableAnalysisPresentation' ].

]
