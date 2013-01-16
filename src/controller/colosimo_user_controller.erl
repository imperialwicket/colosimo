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
  Username = Req:post_param("username"),
  case boss_db:find(colosimo_user, [{username, 'equals', Username}]) of
    [ColosimoUser] ->
      {ok, [{error, "Email already taken"}]};
    [] ->
      HashedPassword = user_lib:get_hash(Req:post_param("password")),
      ColosimoUser = colosimo_user:new(id, Req:post_param("email"), Username, HashedPassword),
      Saved = ColosimoUser:save(),
      error_logger:info_msg("Saved User: ~p~n",[Saved]),
      {ok, [Saved]}
  end.

logout('GET', []) ->
  {redirect, "/", [user_lib:remove_cookies()]}.
