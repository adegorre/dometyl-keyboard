open! Base
open! Scad_ml

module Face : sig
  type t =
    { scad : Scad.t
    ; points : Points.t
    }
  [@@deriving scad]

  val make : Vec3.t -> t
  val direction : t -> Vec3.t
end

module Faces : sig
  type t =
    { north : Face.t
    ; south : Face.t
    ; east : Face.t
    ; west : Face.t
    }
  [@@deriving scad]

  val map : f:(Face.t -> Face.t) -> t -> t
  val fold : f:('k -> Face.t -> 'k) -> init:'k -> t -> 'k
  val make : float -> float -> float -> t
  val face : t -> [< `East | `North | `South | `West ] -> Face.t
end

module Kind : sig
  type niz =
    { clip_height : float
    ; snap_slot_h : float
    }

  type mx = unit

  type _ t =
    | Mx : mx -> mx t
    | Niz : niz -> niz t
end

type 'k config =
  { spec : 'k Kind.t
  ; outer_w : float
  ; outer_h : float
  ; inner_w : float
  ; inner_h : float
  ; thickness : float
  ; clip : Scad.t -> Scad.t
  ; cap_height : float
  ; clearance : float
  }

type 'k t =
  { config : 'k config [@scad.ignore]
  ; scad : Scad.t
  ; origin : Vec3.t
  ; faces : Faces.t
  ; cap : Scad.t option
  ; cutout : Scad.t option
  }
[@@deriving scad]

val rotate_about_origin : Vec3.t -> 'k t -> 'k t
val quaternion_about_origin : float -> 'k t -> 'k t
val cycle_faces : 'k t -> 'k t
val orthogonal : 'k t -> [< `East | `North | `South | `West ] -> Vec3.t
val normal : 'k t -> Vec3.t
val make : ?cap:Scad.t -> ?cutout:Scad.t -> 'k config -> 'k t
val mirror_internals : 'k t -> 'k t
val cutout_scad : 'k t -> Scad.t
