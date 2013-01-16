-module(colosimo_user, [Id, Email, Username, Password::string()]).
-compile(export_all).

-define(SETEC_ASTRONOMY, "Too many secrets").

session_identifier() ->
  mochihex:to_hex(erlang:md5(?SETEC_ASTRONOMY ++ Id)).

check_password(PasswordAttempt) ->
  bcrypt:start(),
  {ok, Password} =:= bcrypt:hashpw(PasswordAttempt, Password).

set_login_cookies() ->
  [ mochiweb_cookies:cookie("colosimo_user_id", Id, [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ].

validation_tests() ->
    [{fun() -> length(Username) > 0 end, "Username cannot be blank.<br/>"},
     {fun() ->
        case re:run(Username, "^[A-z0-9_]+$") of
          {match, _ } -> true;
          nomatch -> false
        end
      end, "Invalid Username: valid characters are A-z, 0-9, and _.<br/>"},
     {fun() -> length(Password) > 0 end, "Password cannot be blank.<br/>"},
     {fun() -> length(Email) > 0 end, "Email cannot be blank.<br/>"},
     {fun() ->
        case re:run(Email, "^[A-z0-9._%+-]+@[A-z0-9.-]+\.[A-z]{2,4}") of
          {match, _ } -> true;
          nomatch -> false
        end
      end, "Invalid Email.<br/>"}
    ].
