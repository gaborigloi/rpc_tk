type implementation = unit -> unit

let implement interface () =
  let top = Tk.openTk () in
  Wm.title_set top interface.Idl.Interface.name;
  let b = Button.create ~text:"Send" ~command:(fun () -> ()) top in
  Tk.pack [Tk.coe b];
  Tk.mainLoop ();;

type 'a res = unit

type ('a, 'b) comp = unit

type 'a fn = unit

let (@->) param fn = ()

let returning result error = ()

let declare name description typ = ()
