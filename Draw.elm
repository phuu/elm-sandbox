import Debug
import Mouse
import Window

main : Signal Element
main =
  scene <~ Window.dimensions ~ clickLocations

clickLocations : Signal [(Int,Int)]
clickLocations =
  sampleOn (always () <~ every 10) Mouse.position
    |> dropRepeats
    |> foldp (::) []

scene : (Int,Int) -> [(Int,Int)] -> Element
scene (iw,ih) locs =
  let drawPentagon (ix,iy) =
        let (x,y) = (toFloat ix, toFloat iy)
            (w,h) = (toFloat iw, toFloat ih)
            cycle = w / 16
        in
            ngon 4 (200 * y / h + 50)
                |> filled (hsla (x / cycle) 0.9 0.6 0.1)
                |> move (x - w/2, h/2 - y)
                |> rotate (x / cycle)
  in
      collage iw ih (map drawPentagon (reverse locs))
