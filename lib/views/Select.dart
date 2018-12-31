
//Images

these are just the major parent widgets that would house our other widgets


But in this article the method i use is simple. You build a tree of widgets setting out the parent containers, rows and widgets (text can be included here also), then for more complex widgets like buttons, input Fields i create a final object and then return that widget as the value of the final object example:
///CODE

in doing this we can then in any part of the layout call the final object and it is created in that instance.

First we build the widgets we want to call from final values:
//code

Next, in this project we need to use a custom background and place our other wigets untop of it so i wont be using a Scaffold() as we dont need it. Instead i will be using a Stack() Widget with two Containers stacked above each other with the one at the buttom being our background like this:
//CODE
In the first container id like to have transparency, so as to show the second utop of it;

Notice how ive used my BoxDecoration() inside a container and styled it with a BoxFit, set the image to an AssetImage().

Next we style our second Container in the Stack() adding margins and a Padding().

