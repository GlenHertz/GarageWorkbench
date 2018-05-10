module GarageWorkbench

export gen_side_hole_templates, gen_leg_template

using Luxor

const kl = 0.15mm  # half kerf of laser
const kr = (1/16)inch # half kerf of router guide

function gen_side_hole_templates(verbose=false)
   h = 9inch  # height of sides
   r = 3inch  # radius of holes
   b = 0.5inch  # pdf border
   W = 24inch
   H = h + 2b  # width of drawing
   w = W - 2b
   btb = 1.5inch # border around hole (top and bottom)
   bfb = 5inch  # border at end of hole (front/back)
   fname = "wb_side_slots_template.svg"
   if verbose
     fname="wb_side_slots_template_vebose.svg"
   end
   Drawing(W, H, fname)
   setline(1)
   sethue("black")
   p0 = Point(b, b)
   origin(p0)
   # outer edge:
   o1 = O            # upper left of edge
   o2 = Point(w, h)  # lower right of edge
   k = Point(kr - kl, kr - kl)  # kerf
   kx = Point(k.x, 0)
   ky = Point(0, k.y)
   # inner hole:
   c1 = Point(bfb + r, btb + r)           # center of semi-circle
   p1 = Point(bfb + r, btb + 2r)          # bottom of semi-circle
   p2 = Point(bfb + r, btb)               # top of semi-circle
   p3 = Point(W - btb - 2b, btb)          # upper right side of hole
   p4 = Point(W - btb - 2b, btb + 2r)     # lower right side of hole
   if verbose
      @layer begin
              # Path without kerf adjustments
              newpath()
	      sethue("red")
              setdash("dot")
              # outside edge:
	      box(o1, o2, :path)
              # inside cut hole:
              newsubpath()
              arc2r(c1, p1, p2, :path)
              line(p3)
              line(p4)
              closepath()
              strokepath()
      end
   end
   newpath()
   # outside cut:
   box(k, o2 + -k, :path)
   # inside cut hole:
   newsubpath()
   arc2r(c1, p1 + ky, p2 - ky, :path)
   line(p3 + kx - ky)
   line(p4 + kx + ky)
   closepath()
   strokepath()
   
   finish()
   preview()
end

function gen_leg_template(verbose=false)
   w = 36inch
   h = 27inch
   b = 0.5inch # pdf border
   W = w + 2b
   H = h + 2b
   fname = "wb_leg_template.svg"
   if verbose
     fname="wb_leg_template_vebose.svg"
   end
   Drawing(W, H, fname)
   setline(1)
   sethue("black")
   p0 = Point(b, b)
   origin(p0)
   ###############
   # helpers:
   b4 = 4inch
   b6 = 6inch
   b8 = 8inch
   
   # extra points for calculating intersections:
   pw14  = Point(b8 + b6, 0)
   pw14h = Point(b8 + b6, h)
   pw26  = Point(w - b4 - b6, 0)
   pw26h = Point(w - b4 - b6, h)

   ph0f16  = Point(0, (1/16)inch)
   ph0f16w = Point(w, (1/16)inch)
   ph4  = Point(0, 4inch)
   ph4w = Point(w, 4inch)
   ph7d5  = Point(0, 7.5inch)
   ph7d5w = Point(w, 7.5inch)
   ph11d5  = Point(0, 11.5inch)
   ph11d5w = Point(w, 11.5inch)
   ph16  = Point(0, 16inch)
   ph16w = Point(w, 16inch)
   ph19  = Point(0, 19inch)
   ph19w = Point(w, 19inch)
   ph20  = Point(0, 20inch)
   ph20w = Point(w, 20inch)
   ph23  = Point(0, 23inch)
   ph23w = Point(w, 23inch)
   phf16  = Point(0, h - (1/16)inch)
   phf16w = Point(w, h - (1/16)inch)
   # outer edge:
   p1 = Point(b8, 0)
   p2 = Point(w - b4, 0)
   p3 = Point(w, h)
   p4 = p3 - Point(b6, 0)
   p7 = Point(b4 + b6, h)
   p8 = Point(b4, h)
   p10 = Point(0, h - b4)
   p11 = Point(0, h - b4 - b4)
   p14 = Point(0, 11.5inch)
   p15 = Point(0, 7.5inch)
   # intersection to get inbetween points:
   _, p5 = intersection(pw26, p4, ph20, ph20w)
   _, p6 = intersection(pw14, p7, ph20, ph20w)
   _, p9 = intersection(p1, p8, p10, ph23w)
   _, p12 = intersection(p1, p8, p11, ph19w)
   _, p13 = intersection(p1, p8, p14, ph11d5w)
   _, p16 = intersection(p1, p8, p15, ph7d5w)
   _, p20 = intersection(pw14, p7, ph4, ph4w)
   _, p21 = intersection(pw26, p4, ph4, ph4w)
   _, p22 = intersection(pw26, p4, ph16, ph16w)
   _, p23 = intersection(pw14, p7, ph16, ph16w)
   _, p1kerf = intersection(p1, p8, ph0f16, ph0f16w)
   _, p2kerf = intersection(p2, p3, ph0f16, ph0f16w)
   _, p3kerf = intersection(p2, p3, phf16, phf16w)
   _, p4kerf = intersection(p4, p5, phf16, phf16w)
   _, p7kerf = intersection(p6, p7, phf16, phf16w)
   _, p8kerf = intersection(p1, p8, phf16, phf16w)
   outer = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p1]
   inner = [p20, p21, p22, p23]
   k = Point(kr - kl, kr - kl)  # kerf
   kx = Point(k.x, 0)
   ky = Point(0, k.y)
   if verbose
      @layer begin
              # Path without kerf adjustments
              newpath()
	      sethue("red")
              setdash("dot")
              # outside edge:
              for p in outer
                line(p)
              end
              # inside cut hole:
              newsubpath()
              for p in inner
                line(p)
              end
              closepath()
              strokepath()
      end
   end
   outer = [p1kerf, p2kerf, p3kerf, p4kerf, p5, p6, p7kerf, p8kerf, p9, p10, p11, p12, p13, p14, p15, p16, p1kerf]
   inner = [p20, p21, p22, p23]
   newpath()
   # outside edge:
   for p in outer
     line(p)
   end
   # inside cut hole:
   newsubpath()
   for p in inner
     line(p)
   end
   closepath()
   strokepath()
   finish()
   preview()
end




end # module
