.PHONY: all

ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
all: priv/rounding.so

priv/rounding.so: src/rounding.c
	gcc -fPIC -shared -o rounding.so src/rounding.c -I$(ERL_INCLUDE_PATH)
