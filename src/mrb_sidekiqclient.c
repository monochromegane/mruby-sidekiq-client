/*
** mrb_sidekiqclient.c - SidekiqClient class
**
** Copyright (c) monochromegane 2016
**
** See Copyright Notice in LICENSE
*/

#include "mruby.h"
#include "mruby/data.h"
#include "mrb_sidekiqclient.h"

#define DONE mrb_gc_arena_restore(mrb, 0);

typedef struct {
  char *str;
  int len;
} mrb_sidekiqclient_data;

static const struct mrb_data_type mrb_sidekiqclient_data_type = {
  "mrb_sidekiqclient_data", mrb_free,
};

static mrb_value mrb_sidekiqclient_init(mrb_state *mrb, mrb_value self)
{
  mrb_sidekiqclient_data *data;
  char *str;
  int len;

  data = (mrb_sidekiqclient_data *)DATA_PTR(self);
  if (data) {
    mrb_free(mrb, data);
  }
  DATA_TYPE(self) = &mrb_sidekiqclient_data_type;
  DATA_PTR(self) = NULL;

  mrb_get_args(mrb, "s", &str, &len);
  data = (mrb_sidekiqclient_data *)mrb_malloc(mrb, sizeof(mrb_sidekiqclient_data));
  data->str = str;
  data->len = len;
  DATA_PTR(self) = data;

  return self;
}

static mrb_value mrb_sidekiqclient_hello(mrb_state *mrb, mrb_value self)
{
  mrb_sidekiqclient_data *data = DATA_PTR(self);

  return mrb_str_new(mrb, data->str, data->len);
}

static mrb_value mrb_sidekiqclient_hi(mrb_state *mrb, mrb_value self)
{
  return mrb_str_new_cstr(mrb, "hi!!");
}

void mrb_mruby_sidekiqclient_gem_init(mrb_state *mrb)
{
    struct RClass *sidekiqclient;
    sidekiqclient = mrb_define_class(mrb, "SidekiqClient", mrb->object_class);
    mrb_define_method(mrb, sidekiqclient, "initialize", mrb_sidekiqclient_init, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, sidekiqclient, "hello", mrb_sidekiqclient_hello, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, sidekiqclient, "hi", mrb_sidekiqclient_hi, MRB_ARGS_NONE());
    DONE;
}

void mrb_mruby_sidekiqclient_gem_final(mrb_state *mrb)
{
}

