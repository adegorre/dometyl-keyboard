open OCADml
open OSCADml

type t =
  { top_left : V3.t
  ; top_right : V3.t
  ; bot_left : V3.t
  ; bot_right : V3.t
  ; centre : V3.t
  }
[@@deriving cad]

type pos =
  [ `BL
  | `BR
  | `CN
  | `TL
  | `TR
  ]

val map : (V3.t -> V3.t) -> t -> t
val fold : ('a -> V3.t -> 'a) -> 'a -> t -> 'a
val to_cw_path : t -> Path3.t
val to_ccw_path : t -> Path3.t
val of_cw_path : Path3.t -> t
val of_ccw_path : Path3.t -> t
val overlapping_bounds : t -> t -> float
val get : t -> [< `BL | `BR | `CN | `TL | `TR ] -> V3.t
val direction : t -> V3.t
val mark : t -> Scad.d3
