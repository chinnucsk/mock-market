%%%----------------------------------------------------------------------------
%%% Copyright (c) 2011-2012 Siraaj Khandkar
%%% Licensed under MIT license. See LICENSE file for details.
%%%
%%% File    : mmtr_config.hrl
%%% Author  : Siraaj Khandkar <siraaj@khandkar.net>
%%% Purpose : Global configuration knobs.
%%%----------------------------------------------------------------------------

-define(NUM_AGENTS, 3).
-define(MAX_SHARES_PER_TRANSACTION, 10).
-define(LOG_FIELD_DELIMITER, "|").
-define(PATH_DIR__DATA, "data").
-define(PATH_FILE__LOG, filename:join(?PATH_DIR__DATA, "transactions.dat")).
