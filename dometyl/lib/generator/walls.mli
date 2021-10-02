open! Base
open! Scad_ml

(** Used for lookups, indicating whether to place a wall at a particular position
    on the plate, and if so, whether there should be an eyelet attached. *)
type presence =
  | No
  | Yes
  | Eye

(** Generation and storage of {!Wall.t}s from the {!KeyHole.t}s of the main body
    of the plate (excluding the thumb cluster). *)
module Body : sig
  module Cols : sig
    type col =
      { north : Wall.t option
      ; south : Wall.t option
      }

    val map_col : f:(Wall.t -> Wall.t) -> col -> col

    type t = col Map.M(Int).t

    (** Basic transformation functions *)
    include Sigs.Transformable with type t := t

    val make
      :  ?d1:float
      -> ?d2:float
      -> ?z_off:float
      -> ?thickness:float
      -> ?index_thickness:float
      -> ?north_clearance:float
      -> ?south_clearance:float
      -> ?n_steps:[< `Flat of int | `PerZ of float > `Flat ]
      -> ?n_facets:int
      -> ?north_lookup:(int -> presence)
      -> ?south_lookup:(int -> presence)
      -> ?eyelet_config:Eyelet.config
      -> 'k Plate.t
      -> t

    val get : col -> [< `N | `S ] -> Wall.t option
    val col_to_scad : col -> Scad.t
    val to_scad : t -> Scad.t
    val collect_screws : ?init:Eyelet.t list -> t -> Eyelet.t list
  end

  module Sides : sig
    type t =
      { west : Wall.t Map.M(Int).t
      ; east : Wall.t Map.M(Int).t
      }

    val map : f:(Wall.t -> Wall.t) -> t -> t

    (** Basic transformation functions *)
    include Sigs.Transformable with type t := t

    val make
      :  ?d1:float
      -> ?d2:float
      -> ?z_off:float
      -> ?thickness:float
      -> ?clearance:float
      -> ?n_steps:[< `Flat of int | `PerZ of float > `Flat ]
      -> ?n_facets:int
      -> ?west_lookup:(int -> presence)
      -> ?east_lookup:(int -> presence)
      -> ?eyelet_config:Eyelet.config
      -> 'a Plate.t
      -> t

    val to_scad : t -> Scad.t
    val collect_screws : ?init:Eyelet.t list -> t -> Eyelet.t list
  end

  type t =
    { cols : Cols.t
    ; sides : Sides.t
    }

  (** Basic transformation functions *)
  include Sigs.Transformable with type t := t

  val make
    :  ?d1:float
    -> ?d2:float
    -> ?z_off:float
    -> ?thickness:float
    -> ?index_thickness:float
    -> ?north_clearance:float
    -> ?south_clearance:float
    -> ?side_clearance:float
    -> ?n_steps:[< `Flat of int | `PerZ of float > `Flat ]
    -> ?n_facets:int
    -> ?north_lookup:(int -> presence)
    -> ?south_lookup:(int -> presence)
    -> ?west_lookup:(int -> presence)
    -> ?east_lookup:(int -> presence)
    -> ?eyelet_config:Eyelet.config
    -> 'a Plate.t
    -> t

  val to_scad : t -> Scad.t
  val collect_screws : ?init:Eyelet.t list -> t -> Eyelet.t list
end

module Thumb : sig
  type key =
    { north : Wall.t option
    ; south : Wall.t option
    }

  val map_key : f:(Wall.t -> Wall.t) -> key -> key

  type sides =
    { west : Wall.t option
    ; east : Wall.t option
    }

  val map_sides : f:(Wall.t -> Wall.t) -> sides -> sides
  val get_side : sides -> [ `W | `E ] -> Wall.t option

  type t =
    { keys : key Map.M(Int).t
    ; sides : sides
    }

  val map : f:(Wall.t -> Wall.t) -> t -> t

  (** Basic transformation functions *)
  include Sigs.Transformable with type t := t

  val make
    :  ?d1:float
    -> ?d2:float
    -> ?z_off:float
    -> ?thickness:float
    -> ?clearance:float
    -> ?n_steps:[ `Flat of int | `PerZ of float ]
    -> ?n_facets:int
    -> ?north_lookup:(int -> presence)
    -> ?south_lookup:(int -> presence)
    -> ?west:presence
    -> ?east:presence
    -> ?eyelet_config:Eyelet.config
    -> 'a Plate.t
    -> t

  val to_scad : t -> Scad.t
  val collect_screws : ?init:Eyelet.t list -> t -> Eyelet.t list
end

type t =
  { body : Body.t
  ; thumb : Thumb.t
  }

(** Basic transformation functions *)
include Sigs.Transformable with type t := t

val to_scad : t -> Scad.t
val collect_screws : t -> Eyelet.t list
