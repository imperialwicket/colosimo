-module(colosimo_user_controller, [Req]).
-compile(export_all).

login('GET', []) ->
  {ok, [{redirect, Req:header(referer)}]};

login('POST', []) ->
  Username = Req:post_param("username"),
  case boss_db:find(colosimo_user, [{username, 'equals', Username}]) of
    [ColosimoUser] ->
      case ColosimoUser:check_password(Req:post_param("password")) of
      true ->
        {redirect, proplists:get_value("redirect",
        Req:post_params(), "/"), ColosimoUser:login_cookies()};
      false ->
        {ok, [{error, "Authentication error: password check failed"}]}
      end;
    [] ->
      {ok, [{error, "Authentication error: no user found"}]}
  end.

register('GET', []) ->
  {ok, []};

register('POST', []) ->
  bcrypt:start(),
  Email = Req:post_param("email"),
  Username = Req:post_param("username"),
  %% I needed to do a bit of pattern-matching for gen_salt() and
  %% hashpw() in order to make the password store correctly.
  {ok, Salt} = bcrypt:gen_salt(),
  {ok, Hash} = bcrypt:hashpw(Req:post_param("password"), Salt),
  ColosimoUser = colosimo_user:new(id, Email, Username, Hash),
  Result = ColosimoUser:save(),
  {ok, [Result]}.

logout('GET', []) ->
  {redirect, "/",
    [ mochiweb_cookies:cookie("colosimo_user_id", "", [{path, "/"}]),
      mochiweb_cookies:cookie("session_id", "", [{path, "/"}]) ]}.
