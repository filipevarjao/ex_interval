.PHONY: all

ERL_INCLUDE_PATH="/home/filipe/.asdf/installs/erlang/22.1.2/erts-10.5.2/include/"
all: priv/rounding.so

priv/rounding.so: rounding.c
	gcc -fPIC -shared -o rounding.so rounding.c -I$(ERL_INCLUDE_PATH)
