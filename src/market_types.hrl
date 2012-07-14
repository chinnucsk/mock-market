%%%----------------------------------------------------------------------------
%%% Copyright (c) 2011-2012 Siraaj Khandkar
%%% Licensed under MIT license. See LICENSE file for details.
%%%
%%% File    : market_types.hrl
%%% Author  : Siraaj Khandkar <siraaj@khandkar.net>
%%% Purpose : Data types/structures definitions.
%%%----------------------------------------------------------------------------

-record(transaction, {timestamp :: float()
                     ,broker    :: atom()
                     ,type      :: atom()
                     ,symbol    :: string()
                     ,amount    :: integer()
                     ,price     :: float()
                     }).
