local firebaseAuth = require "plugin.firebaseAuth"
local widget = require("widget")
local json = require("json")
firebaseAuth.init()

local loadProfilePage
local signOut
local signInGroup = display.newGroup( )
local profileGroup = display.newGroup( )
local sceneGroup = display.newGroup( )
sceneGroup:insert( signInGroup )
sceneGroup:insert( profileGroup )



local emailOfAccount = display.newText( profileGroup, "", display.contentCenterX, display.contentCenterY-100, native.systemFont, 15 )
local uid = display.newText( profileGroup, "", display.contentCenterX, display.contentCenterY-50, native.systemFont, 12)
profileGroup.alpha = 0
local signOutButton
signOutButton = widget.newButton( {
 x = display.contentCenterX,
 y = display.contentCenterY+200,
 id = "signOutButton",
 labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
 label = "Sign Out",
 onEvent = function ( e )
 if (e.phase == "ended") then
 firebaseAuth.signOut(function (ev)
      if(ev.isError) then
                      native.showAlert( "Could not Sign Out", ev.error ,{"Ok"} )
      else
                      signOut(  )
      end
      end)
    end
 end
 } )
profileGroup:insert(signOutButton)

local bg = display.newRect( sceneGroup,display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor( 1,.5,0 )
local title = display.newText( {parent = signInGroup,text = "Firebase Auth", fontSize = 30} )
title.width, title.height = 300, 168
title.x, title.y = display.contentCenterX, 40

title:setFillColor(1,0,0)
local email = native.newTextField( display.contentCenterX, display.contentCenterY-100, 280, 40 )
signInGroup:insert( email )
local emailText= display.newText( "Email", email.x, email.y-50, native.systemFont, 20 )
signInGroup:insert( emailText )
local password = native.newTextField( display.contentCenterX, display.contentCenterY, 280, 40 )
signInGroup:insert( password )
local passwordText= display.newText( "Password", password.x, password.y-50, native.systemFont, 20 )
signInGroup:insert( passwordText )
local signIn
signIn = widget.newButton( {
  x = display.contentCenterX,
  y = display.contentCenterY+120,
  id = "signIn",
  labelColor = { default={ 0, 0, 0 }, over={ .5, 0, 0, 0.5 } },
  label = "Sign In",
  onEvent = function ( e )
    if (e.phase == "ended") then
        firebaseAuth.signIn(email.text, password.text,function (ev)
            if(ev.isError) then
                native.showAlert( "Could not Sign in", ev.error ,{"Ok"} )
            else
                native.showAlert( "Signed in", "" ,{"Ok"} )
                loadProfilePage( )
            end
        end)
    end
  end
} )
signInGroup:insert( signIn )

local createAccount
createAccount = widget.newButton( {
  x = display.contentCenterX,
  y = display.contentCenterY+80,
  id = "createAccount",
  labelColor = { default={ 0, 0, 0 }, over={ .5, 0, 0, 0.5 } },
  label = "Create Account",
  onEvent = function ( e )
    if (e.phase == "ended") then
        firebaseAuth.createAccount(email.text, password.text,function (ev)
            if(ev.isError) then
                native.showAlert( "Could not create account", ev.error ,{"Ok"} )
            else
                native.showAlert( "Account Created", "please sign in now" ,{"Ok"} )
            end
        end)
    end
  end
} )
signInGroup:insert( createAccount )
signInGroup:toFront( )
profileGroup:toFront( )

Runtime:addEventListener( "touch", function (  )
  native.setKeyboardFocus( nil )
end )
function signOut(  )
  profileGroup.alpha = 0
  signInGroup.alpha = 1
  email = native.newTextField( display.contentCenterX, display.contentCenterY-100, 280, 40 )
  signInGroup:insert( email )
  password = native.newTextField( display.contentCenterX, display.contentCenterY, 280, 40 )
  signInGroup:insert( password )

end
function loadProfilePage( )
  profileGroup.alpha = 1
  signInGroup.alpha = 0
  display.remove( email )
  display.remove( password )
  if(firebaseAuth.getEmail()) then
      emailOfAccount.text="Email:"..firebaseAuth.getEmail()
  else
      emailOfAccount.text="Name:"..firebaseAuth.getDisplayName()
  end
  uid.text = "UID:"..firebaseAuth.getUID()
end
if (firebaseAuth.isSignedIn() and firebaseAuth.isSignedIn() == true) then
  loadProfilePage( )
end
