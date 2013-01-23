-module(colosimo_user_controller, [Req]).
-compile(export_all).

login('GET', []) ->
  {ok, [{redirect, Req:header(referer)}]};

login('POST', []) ->
  Username = Req:post_param("username"),
  case boss_db:find(colosimo_user, [{username, 'equals', Username}]) of
    [ColosimoUser] ->
      error_logger:info_msg("Found User: ~p~n",[ColosimoUser]),
      user_lib:check_password_and_login(Req, ColosimoUser);
    [] ->
      {ok, [{error, "Authentication error: no user found"}]}
  end.

register('GET', []) ->
  {ok, []};

register('POST', []) ->
  bcrypt:start(),
  case boss_db:find(colosimo_user, [{username, 'equals', Req:post_param("username")}]) of
    [ColosimoUser] ->
      {ok, [{error, "Email already taken"}]};
    [] ->
      SavedUser = user_lib:register_user(Req),
      {redirect, "/user/login", []}
  end.

logout('GET', []) ->
  % error_logger:info_msg("Found user: ~p~n",[Before]),
  {redirect, "/", [user_lib:remove_cookies()]}.
