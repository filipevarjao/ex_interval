#include <stdio.h>
#include <stdlib.h>
#include <fenv.h>
#include <math.h>
#include "erl_nif.h"

#define FLT_ROUNDS

/* NIF library code */
static ERL_NIF_TERM get_mode(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    return enif_make_int(env, fegetround());
}

static ERL_NIF_TERM restore_mode(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    int rounding_mode = 0;
    enif_get_int(env, argv[0], &rounding_mode);
    fesetround(rounding_mode);
    return enif_make_int(env, 0);
}

static ERL_NIF_TERM set_mode_to_nearest(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    fesetround(FE_TONEAREST);
    return enif_make_int(env, 0);
}

static ERL_NIF_TERM set_mode_downward(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    fesetround(FE_DOWNWARD);

    return enif_make_int(env, 0);
}

static ERL_NIF_TERM set_mode_upward(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    fesetround(FE_UPWARD);

    return enif_make_int(env, 0);
}

static ERL_NIF_TERM set_mode_toward_zero(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    fesetround(FE_TOWARDZERO);

    return enif_make_int(env, 0);
}

static ErlNifFunc nif_funcs[] = {
    {"get_mode", 0, get_mode},
    {"restore_mode", 1, restore_mode},
    {"set_mode_to_nearest", 0, set_mode_to_nearest},
    {"set_mode_downward", 0, set_mode_downward},
    {"set_mode_upward", 0, set_mode_upward},
    {"set_mode_toward_zero", 0, set_mode_toward_zero}};

ERL_NIF_INIT(Elixir.ExInterval.Rounding.Nif, nif_funcs, NULL, NULL, NULL, NULL)
