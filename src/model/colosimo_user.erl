-module(colosimo_user, [Id, Email, Username, Password::string()]).
-compile(export_all).

-define(SETEC_ASTRONOMY, "Too many secrets").

session_identifier() ->
  mochihex:to_hex(erlang:md5(?SETEC_ASTRONOMY ++ Id)).

check_password(PasswordAttempt) ->
  bcrypt:start(),
  {ok, Password} =:= bcrypt:hashpw(PasswordAttempt, Password).

login_cookies() ->
  [ mochiweb_cookies:cookie("colosimo_user_id", Id, [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ].
