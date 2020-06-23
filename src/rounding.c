#include <stdio.h>
#include <stdlib.h>
#include <fenv.h>
#include <math.h>
#include "erl_nif.h"

#define FLT_ROUNDS

int get_mode(void) {
    switch (fegetround()) {
           case FE_TONEAREST:   1;  break;
           case FE_DOWNWARD:    3;  break;
           case FE_UPWARD:      2;  break;
           case FE_TOWARDZERO:  0;  break;
           default:            -1;
    };
}

int set_mode(int i) {
    switch (i) {
           case -1: fesetround(FE_DOWNWARD); break;
           case 0: fesetround(FE_TONEAREST); break;
           case 1: fesetround(FE_UPWARD); break;
    };
    return 0;
}

int main(void) {
    int rounding_mode;
    rounding_mode = get_mode();
    printf("%d\n", rounding_mode);
    return 0;
}

/* NIF library code */
static ERL_NIF_TERM rounding_get_mode(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    int rounding_mode;
    rounding_mode = get_mode();
    return enif_make_int(env, rounding_mode);
}

static ERL_NIF_TERM rounding_set_mode(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    int rounding_mode;
    enif_get_int(env, argv[0], &rounding_mode);
    int result = set_mode(rounding_mode);
    return enif_make_int(env, result);
}

static ErlNifFunc nif_funcs[] = {
    {"get_mode", 0, rounding_get_mode},
    {"set_mode", 1, rounding_set_mode},
};

ERL_NIF_INIT(Elixir.ExInterval.Rounding, nif_funcs, NULL, NULL, NULL, NULL)