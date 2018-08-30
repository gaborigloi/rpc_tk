type boxedwidget = W : 'a Widget.widget -> boxedwidget

type gengui_implementation = boxedwidget -> unit

module GenGui () = struct

  type implementation = boxedwidget -> unit

  let funcs = ref []

  let implement interface boxedwidget =
    let W widget = boxedwidget in
    let top_frame = Frame.create widget in
    let interface_name = Label.create top_frame ~text:interface.Idl.Interface.name in
    Tk.pack [top_frame] ~side:`Top ~expand:true ~fill:`Both;
    Tk.pack [interface_name] ~side:`Left ~anchor:`E;

    List.iter
      (fun f ->
         let fn_frame = Frame.create widget in
         f (W fn_frame);
         Tk.pack [fn_frame] ~side:`Top ~expand:true ~fill:`Both
      )
      (!funcs)

  type 'a res = 'a -> unit

  type ('a, 'b) comp = 'a

  type _ fn =
    | Function : 'a Idl.Param.t * 'b fn -> ('a -> 'b) fn
    | Returning : ('a Idl.Param.t * 'b Idl.Error.t) -> ('a, _) comp fn

  let (@->) param fn = Function (param, fn)

  let returning result error = Returning (result, error)

  let declare name _description ty impl =
    let buildguifn boxedwidget =
      let W widget = boxedwidget in
      let method_name = Label.create widget ~text:name in
      Tk.pack [method_name] ~side:`Left ~anchor:`E;

      let rec inner : type a. a fn -> (unit -> a) -> unit = fun f impl ->
        match f with
        | Function (p, f) ->
          let ty = p.Idl.Param.typedef.Rpc.Types.ty in

          let param_name = match p.Idl.Param.name with Some n -> n | None -> p.Idl.Param.typedef.Rpc.Types.name in
          let param_name = Label.create widget ~text:param_name in
          Tk.pack [param_name] ~side:`Left ~anchor:`E;

          let e = Entry.create ~width:10 ~relief:`Sunken widget in
          Tk.pack [e] ~side:`Left ~anchor:`E;

          let arg () =
            let arg = Rpcmarshal.unmarshal ty (Jsonrpc.of_string (Entry.get e)) in
            match arg with
            | Result.Ok arg -> arg
            | Result.Error (`Msg _m) -> failwith "Marshal error"
          in
          inner f (fun () -> (impl ()) (arg ()))
        | Returning (r, _e) ->
          let ty = r.Idl.Param.typedef.Rpc.Types.ty in
          let command () =
            let res = impl () in
            let message = Jsonrpc.to_string (Rpcmarshal.marshal ty res) in
            let _d : int = Dialog.create ~parent:widget ~title:"Result" ~message ~buttons:["Ok"] () in
            ()
          in
          let b = Button.create ~text:"Run" ~command widget in
          Tk.pack [b] ~side:`Left ~anchor:`E
      in
      inner ty (fun () -> impl)
    in
    funcs := !funcs @ [buildguifn];
    ()
end

let creategui interface implementation =
  let top = Tk.openTk () in
  Wm.title_set top interface.Idl.Interface.name;
  implementation (W top);
  Tk.mainLoop ()
