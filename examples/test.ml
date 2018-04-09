
module Interface(R: Idl.RPC) = struct
  open R

  let str = Idl.Param.mk Rpc.Types.string

  let concat =
    declare
      "concat"
      ["Concatenates the inputs"]
      (str @-> str @-> returning str Idl.DefaultError.err)

  let description = Idl.Interface.{
      name = "Test interface";
      namespace = None;
      description =
        [ "Test interface that has a function"
        ; "for concatenating the inputs" ];
      version=(1,0,0)
    }

  let implementation = implement description

end

let () =
  let module Gui = Interface(Rpc_tk.Guigen) in
  Gui.implementation ();
  ()