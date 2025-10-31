I want you to change these variables and their values to the following:

1. isConflictDialog - keep the name, but value should be when anywhere in the window, the string "A version of this font is already installed" is found
2. otherCase, change name to "canSkip", change value to function that
   determines if the Skip button should be clicked. If the Skip button is enabled, and either the Install button or Replace button is present and disabled, Then click "Skip".
3. fontNotValidatedCase - if there is text in the window that says "The font
   could not be validated" then if the "Install" button is enabled, click the "Install" button. Otherwise, if the Install button is disabled, click the "Skip" button.
