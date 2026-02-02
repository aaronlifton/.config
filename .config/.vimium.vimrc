#!no-check

unmapAll
unmap 0
map ? showHelp
map <a-/> enterInsertMode

# map <a-/> openUrl url=\vimium://status/toggle-disabled/^\\u0020<a-/>\

" map ; enterInsertMode
map i enterInsertMode
map <a-r> reloadTab

map <a-,> moveTabLeft count=99
map <a-.> moveTabRight count=99

map j scrollDown
map k scrollUp
map h scrollLeft
map l scrollRight

map gg scrollToTop
map G scrollToBottom

map d scrollPageDown
map u scrollPageUp

map H goBack
map L goForward

map J nextTab
map K previousTab
map 0 firstTab
map $ lastTab

map t createTab
map <f3> sortTabs

map r reload
map R reloadGivenTab

map f LinkHints.activate
map F LinkHints.activateOpenInNewTab
map <a-f> LinkHints.activateWithQueue

map o Vomnibar.activate
map O Vomnibar.activateInNewTab preferTabs=\new\
map T Vomnibar.activateTabSelection tree=\from-start\ currentWindow preferTabs=\new\
#map Vomnibar.activateInNewTab keyword=\bing\
map B Vomnibar.activateBookmarksInNewTab
map b Vomnibar.activateBookmarks

map X restoreTab
map q removeTab highlighted
map z restoreGivenTab
map xj closeTabsOnLeft $count=-1
map xk closeTabsOnRight $count=1
map xo closeOtherTabs

map ct copyCurrentTitle
map ca LinkHints.activateCopyLinkUrl sed
map cc autoCopy url decode
map cs searchAs
map cv autoOpen
map Cb autoOpen keyword=\bing\
map cd autoOpen keyword=\duckduckgo\
map cg autoOpen keyword=\google\
map cT openCopiedUrlInNewTab keyword=\t\
map E duplicateTab

" TODO: fixme
map i focusInput keep reachable prefer=\#js-issues-search\
map I focusInput keep reachable select=\all-line\ prefer=\#js-issues-search\
map UU goToRoot
map W moveTabToNewWindow
map p visitPreviousTab
map Pp togglePinTab
map Pn passNextKey
map Pm passNextKey normal
map <a-m> toggleMuteTab
map <a-c-n> moveTabToIncognito

map v enterVisualMode

map / enterFindMode postOnEsc
map n performFind
map N performBackwardsFind
map <a-.> performAnotherFind
map : enterVisualLineMode
map > moveTabRight
map < moveTabLeft
map m Marks.activate swap
map M Marks.activateCreateMode swap
map <c-m> mainFrame
map <a-s-h> clearFindHistory

map ` Marks.activate swap
map ~ Marks.activateCreateMode swap
map <a-~> Marks.clearGlobal
map <a-`> Marks.clearLocal

map <f1> simBackspace
map <s-f1> switchFocus select=\all-line\
map <a-f3> autoOpen keyword=\dict\
map <a-s-f12> debugBackground
map <s-f12> focusOrLaunch url=\vimium://options\

#shortcut createTab position=\end\
#shortcut userCustomized1 command=\autoOpen\ keyword=\dict\
