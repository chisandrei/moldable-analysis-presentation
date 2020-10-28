# Modable Analysis with Glamorous Toolkit

A presentation of using Glamorous Toolkit to do moldable analyses. 

```
Metacello new
    baseline: 'MoldableAnalysisPresentation';
    repository: 'github://chisandrei/moldable-analysis-presentation:main/src';
    load
```

Inspect the presentation
```
GtLiveShow createWithArrowsVisible: MoldableAnalysisPresentation new) create.		
```

Open the presentation in a new window.
```
space := BlSpace new.
space root addChild: (GtLiveShow createWithArrowsVisible: MoldableAnalysisPresentation new) create.
space title: 'Moldable analysis'.
space show			
```
