%%%----------------------------------------------------------------------------
%%% Copyright (c) 2011-2012 Siraaj Khandkar
%%% Licensed under MIT license. See LICENSE file for details.
%%%
%%% File    : mmtr_scribe.erl
%%% Author  : Siraaj Khandkar <siraaj@khandkar.net>
%%% Purpose : Scribe process.
%%%----------------------------------------------------------------------------

-module(mmtr_scribe).
-behaviour(gen_event).


%% API
-export([start_link/0
        ,register_with_logger/0
        ,add_handler/0
        ,delete_handler/0
        ,log_transaction/1
        ]).

%% Callbacks
-export([init/1
        ,terminate/2
        ,code_change/3
        ,handle_event/2
        ,handle_call/2
        ,handle_info/2
        ]).


-define(EVENT_MGR_REF, ?MODULE).
-define(HANDLER, ?MODULE).


-include("mmtr_config.hrl").
-include("mmtr_types.hrl").


-record(state, {log_file :: file:io_device()}).


%% ============================================================================
%% API
%% ============================================================================

start_link() ->
    EventMgrName = {local, ?EVENT_MGR_REF},
    gen_event:start_link(EventMgrName).


register_with_logger() ->
    error_logger:add_report_handler(?HANDLER).


add_handler() ->
    Args = [],
    gen_event:add_handler(?EVENT_MGR_REF, ?HANDLER, Args).


delete_handler() ->
    Args = [],
    gen_event:delete_handler(?EVENT_MGR_REF, ?HANDLER, Args).


log_transaction(Data) ->
    Event = {transaction, Data},
    gen_event:notify(?EVENT_MGR_REF, Event).


%% ============================================================================
%% Callbacks
%% ============================================================================

init([]) ->
    file:make_dir(?PATH_DIR__DATA),
    {ok, LogFile} = file:open(?PATH_FILE__LOG, write),
    {ok, #state{log_file=LogFile}}.


terminate(_Reason, #state{log_file=LogFile}=State) ->
    file:close(LogFile),
    {ok, State}.


code_change(_Old, State, _Other) ->
    {ok, State}.


handle_call(_Request, State) ->
    Reply = ok,
    {ok, Reply, State}.


handle_info(_Info, State) ->
    {ok, State}.


handle_event({transaction, Data}, #state{log_file=LogFile}=State) ->
    LogEntry = string:join(
        [
            float_to_string(10, Data#transaction.timestamp),
            atom_to_list(Data#transaction.agent),
            atom_to_list(Data#transaction.type),
            Data#transaction.symbol,
            integer_to_list(Data#transaction.amount),
            float_to_string(2, Data#transaction.price)
        ],
        ?LOG_FIELD_DELIMITER
    ),
    io:format(LogFile, "~s~n", [LogEntry]),
    {ok, State};

handle_event({error, _Gleader, Info}, State) ->
    io:format(">>> ERROR:~n~p~n", [Info]),
    {ok, State};

handle_event({error_report, _Gleader, Info}, State) ->
    io:format(">>> ERROR REPORT:~n~p~n", [Info]),
    {ok, State};

handle_event({warning_msg, _Gleader, Info}, State) ->
    io:format(">>> WARNING MSG:~n~p~n", [Info]),
    {ok, State};

handle_event({warning_report, _Gleader, Info}, State) ->
    io:format(">>> WARNING REPORT:~n~p~n", [Info]),
    {ok, State};

handle_event({info_msg, _Gleader, _Info}, State) ->
    %io:format(">>> INFO MSG:~n~p~n", [Info]),
    {ok, State};

handle_event({info_report, _Gleader, _Info}, State) ->
    %io:format(">>> INFO REPORT:~n~p~n", [Info]),
    {ok, State};

handle_event(Event, State) ->
    io:format(">>> EVENT:~n~p~n", [Event]),
    {ok, State}.


%% ============================================================================
%% Internal
%% ============================================================================

float_to_string(Precision, Float) ->
    io_lib:format("~."++integer_to_list(Precision)++"f", [Float]).
