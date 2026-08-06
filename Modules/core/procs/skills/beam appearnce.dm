// ─────────────────────────────────────────────────────────────────────────────
// update_beam_appearance
//
// Repositions and transforms all visual parts of a continuous beam every frame
// so they connect seamlessly from the caster to the beam tip.
//
// Arguments:
//   m            - caster mob; all parts are anchored to m's world position.
//   angle        - firing angle in degrees (GetAngleStep / locked_mouse_degree).
//   size         - uniform beam thickness scale (0.0-1.0).
//   reach        - current beam length in screen pixels from origin to tip.
//   sprite_half  - half the body sprite's natural width in pixels.
//                    32  for 64-px sprites  (pixel_x / pixel_y = -16)
//                    64  for 128-px sprites (pixel_x / pixel_y = -48)
//                  Defaults to 32.
//   origin_part  - energy-orb at the caster's hand     (null-safe).
//   body_part    - elongated shaft scaled to fill gap   (null-safe).
//   end_part     - end-cap at the beam tip              (null-safe).
//   head_part    - front tip at the beam tip            (null-safe).
//   hit_part     - impact glow at the beam tip          (null-safe).
//
// Geometry guarantee:
//   body near edge = reach/2 - reach/2 = 0      (flush with caster)
//   body far  edge = reach/2 + reach/2 = reach  (flush with tip)
//   all tip parts land exactly at reach pixels ahead
// ─────────────────────────────────────────────────────────────────────────────
proc/update_beam_appearance(mob/m, angle, size, reach, sprite_half = 32, \
                             obj/origin_part, obj/body_part, \
                             obj/end_part,    obj/head_part, obj/hit_part)
	if(!m || !m.loc) return

	var/ox = cos(angle)
	var/oy = sin(angle)
	var/safe_reach = max(reach, 1)

	// Origin: half a sprite ahead so it caps the body's near seam.
	if(origin_part)
		var/op = sprite_half * 0.5
		origin_part.Move(m.loc, 0, m.step_x + op * ox, m.step_y - op * oy)
		var/matrix/OR = matrix()
		OR.Scale(size, size)
		OR.Turn(angle)
		origin_part.transform = OR

	// Body: anchored at the caster, stretched so near edge = 0, far edge = reach.
	//   pix   = safe_reach / (sprite_half * 2)   -> Scale(pix, size) fills exactly reach px
	//   trans = safe_reach * 0.5                 -> Translate centres the stretched sprite
	if(body_part)
		var/pix   = safe_reach / (sprite_half * 2.0)
		var/trans = safe_reach * 0.5
		body_part.Move(m.loc, 0, m.step_x, m.step_y)
		var/matrix/BO = matrix()
		BO.Scale(pix, size)
		BO.Translate(trans, 0)
		BO.Turn(angle)
		body_part.transform = BO

	// Tip pieces: all placed flush with the body's far edge at reach pixels ahead.
	var/tip_dx = safe_reach * ox
	var/tip_dy = safe_reach * oy

	var/matrix/TIP = matrix()
	TIP.Scale(size, size)
	TIP.Turn(angle)

	if(end_part)
		end_part.Move(m.loc, 0, m.step_x + tip_dx, m.step_y - tip_dy)
		end_part.transform = TIP
	if(head_part)
		head_part.Move(m.loc, 0, m.step_x + tip_dx, m.step_y - tip_dy)
		head_part.transform = TIP
	if(hit_part)
		hit_part.Move(m.loc, 0, m.step_x + tip_dx, m.step_y - tip_dy)
		hit_part.transform = TIP