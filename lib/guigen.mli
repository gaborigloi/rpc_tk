(** We need to box the widget because the [implementation] cannot have a type
    parameter *)
type boxedwidget = W : 'a Widget.widget -> boxedwidget

type gengui_implementation = boxedwidget -> unit

module GenGui () : sig
  include Idl.RPC with
    type implementation = gengui_implementation
                   and type 'a res = 'a -> unit
                   and type ('a, 'b) comp = 'a
end

(** Convenience function for building a whole GUI instead of just adding it to
    an existing window *)
val creategui : Idl.Interface.description -> gengui_implementation -> unit
