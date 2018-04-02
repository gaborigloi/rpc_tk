type implementation = unit -> unit

let implement interface () =
  let top = Tk.openTK () in
  Tk.Wm.title_set top interface.Idl.Interface.description;
  let b = Tk.Button.create ~test:"Send" ~command:(fun () -> ()) top in
  Tk.pack [Tk.coe b];
  Tk.mainLoop ();;

type 'a res = unit

type ('a, 'b) comp = unit

type 'a fn = unit

let (@->) param fn = ()

let returning result error = () 

let declare name description typ = ()
